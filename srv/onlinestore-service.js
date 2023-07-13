const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  const { Brands, Categories, Products, SalesOrders, SalesOrderItems, Statuses } = this.entities();

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

  this.after('PATCH', [SalesOrderItems], async (data, req) => {
    await recalculateSalesOrderTotals(data, req.target, SalesOrders);
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
}

async function setSalesOrderConfirmedStatus(data, Statuses) {
  if (data.deliveryDate) {
    const oStatusConfirmed = await SELECT.one.from(Statuses).where({ title: 'Confirmed' });
    data.status_ID = oStatusConfirmed.ID;
  }
}

async function recalculateSalesOrderItem(data, target, Products) {
  const [dbItemInfo] = await cds.read(target.drafts).where({ ID: data.ID });
  const oProduct = data.product_ID ? await SELECT.one.from(Products).where({ ID: data.product_ID }) : {};

  data.quantity = data.quantity || dbItemInfo?.quantity || 1;
  data.price = oProduct?.price || dbItemInfo?.price || 0;

  data.currency_code = oProduct?.currency_code || dbItemInfo?.currency_code;
  data.amount = data.quantity * data.price;
}

async function recalculateSalesOrderTotals(data, target, SalesOrders) {
  const oOrderInfo = { totalAmount: 0 };

  const [oItemData] = await cds.read(target.drafts).where({ ID: data.ID }).columns(['parent_ID']);
  const dbItemInfos = await cds.read(target.drafts).where({ parent_ID: oItemData.ID });

  dbItemInfos.forEach((dbItemInfo) => {
    oOrderInfo.totalAmount += dbItemInfo.amount;
    oOrderInfo.currency_code = dbItemInfo.currency_code;
  });

  await cds.update(SalesOrders.drafts, sOrderID).set(oOrderInfo);
}
