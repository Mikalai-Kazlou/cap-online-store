const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  const { Brands, Categories, Products, SalesOrders, SalesOrderItems, Statuses } = this.entities();
  const oProcessedData = {};

  this.on('getProductRangeFilterParameters', async (req) => {
    const sProperty = req.data.property;

    const sValues = `{ MIN(${sProperty}) as min, MAX(${sProperty}) as max }`;
    const oQuery = SELECT(`${sValues}`).from(Products);

    return await cds.run(oQuery);
  });

  this.on('setDeliveredStatus', async (req) => {
    const oParams = req.params[0];
    const oTarget = oParams.IsActiveEntity ? req.target : req.target.drafts;

    const oStatuses = await SELECT.from(Statuses)
      .where({ title: ['Confirmed', 'Delivered'] })
      .columns(['ID', 'title'])
      .orderBy(['title']);

    const [oStatusConfirmed, oStatusDelivered] = oStatuses;
    const [dbItemInfo] = await SELECT.from(oTarget).where({ ID: oParams.ID }).columns('status_ID');

    if (dbItemInfo.status_ID === oStatusConfirmed.ID) {
      const tx = cds.transaction(req);
      const affectedRows = await tx.run(
        UPDATE(oTarget, oParams.ID).set({ status_ID: oStatusDelivered.ID }).where({ status_ID: oStatusConfirmed.ID })
      );

      if (affectedRows === 0) {
        req.error(500, 'Sorry, something went wrong... Please try again later.');
      }
    }
  });

  this.before('CREATE', [Categories, Brands, Products, SalesOrders], async (req) => {
    await assignNewIdentifier(req.data, req.target);
  });

  this.before('NEW', [SalesOrders], async (req) => {
    await assignSalesOrderHeaderDefault(req.data, Statuses);
  });

  this.before('PATCH', [SalesOrders], async (req) => {
    await setSalesOrderConfirmedStatus(req.data, Statuses);
  });

  this.before(['NEW', 'PATCH'], [SalesOrderItems], async (req) => {
    await recalculateSalesOrderItem(req.data, req.target, Products);
  });

  this.before(['CANCEL'], [SalesOrderItems], async (req) => {
    addParentToProcessedData(req.data, req.target, oProcessedData);
  });

  this.after(['NEW', 'PATCH', 'CANCEL'], [SalesOrderItems], async (data, req) => {
    await recalculateSalesOrderTotals(req.data, req.target, SalesOrders, oProcessedData);
  });

  this.after('READ', Products, (data) => {
    setProductsCriticality(data);
  });
});

async function assignNewIdentifier(data, target) {
  const oQuery = SELECT(`MAX(identifier) as max`).from(target);
  const [result] = await cds.run(oQuery);
  data.identifier = ++result.max;
}

async function assignSalesOrderHeaderDefault(data, Statuses) {
  const oStatusNew = await SELECT.one.from(Statuses).where({ title: 'New' });
  data.status_ID = oStatusNew.ID;
  data.currency_code = 'USD';
}

async function setSalesOrderConfirmedStatus(data, Statuses) {
  if (data.deliveryDate) {
    const oStatusConfirmed = await SELECT.one.from(Statuses).where({ title: 'Confirmed' });
    data.status_ID = oStatusConfirmed.ID;
  }
}

async function addParentToProcessedData(data, target, oProcessedData) {
  const [dbItemInfo] = await cds.read(target.drafts).where({ ID: data.ID });
  oProcessedData.sParentID = dbItemInfo.parent_ID;
}

async function recalculateSalesOrderItem(data, target, Products) {
  const [dbItemInfo] = await cds.read(target.drafts).where({ ID: data.ID });
  const oProduct = data.product_ID ? await SELECT.one.from(Products).where({ ID: data.product_ID }) : {};

  data.quantity = data.quantity || dbItemInfo?.quantity || 1;
  data.price = oProduct?.price || dbItemInfo?.price || 0;

  data.currency_code = oProduct?.currency_code || dbItemInfo?.currency_code;
  data.amount = data.quantity * data.price;
}

async function recalculateSalesOrderTotals(data, target, SalesOrders, oProcessedData) {
  const oOrderInfo = { totalAmount: 0 };

  const [oItemData] = await cds.read(target.drafts).where({ ID: data.ID });
  const sParentID = oItemData?.parent_ID || oProcessedData?.sParentID;

  const dbItemInfos = await cds.read(target.drafts).where({ parent_ID: sParentID });
  oOrderInfo.totalAmount = dbItemInfos.reduce((sum, dbItemInfo) => sum + dbItemInfo.amount, 0);

  await cds.update(SalesOrders.drafts, sParentID).set(oOrderInfo);
}

function setProductsCriticality(data) {
  const aProducts = Array.isArray(data) ? data : [data];
  aProducts.forEach((oProduct) => {
    switch (true) {
      case oProduct.stock >= 20:
        oProduct.criticality = 3;
        break;
      case oProduct.stock >= 10:
        oProduct.criticality = 2;
        break;
      default:
        oProduct.criticality = 1;
        break;
    }
  });
}
