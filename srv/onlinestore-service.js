const cds = require("@sap/cds");

module.exports = cds.service.impl(function () {
  const {
    Brands,
    Categories,
    Products,
    SalesOrders,
    SalesOrderItems,
    Statuses,
  } = this.entities();

  this.on("getProductRangeFilterParameters", async (req) => {
    const sProperty = req.data.property;

    const sValues = `{ MIN(${sProperty}) as min, MAX(${sProperty}) as max }`;
    const oQuery = SELECT(`${sValues}`).from(Products);

    return await cds.run(oQuery);
  });

  this.before(
    "CREATE",
    [Categories, Brands, Products, SalesOrders],
    async (req) => {
      await assignNewIdentifier(req.data, req.target);
    }
  );

  this.before("NEW", [SalesOrders], async (req) => {
    await assignSalesOrderHeaderDefault(req.data, Statuses);
  });

  this.before("PATCH", [SalesOrders], async (req) => {
    await setSalesOrderConfirmedStatus(req.data, Statuses);
  });

  this.before(["NEW", "PATCH"], [SalesOrderItems], async (req) => {
    await recalculateSalesOrderItem(req.data, req.target, Products);
  });

  this.after("PATCH", [SalesOrderItems], async (data, req) => {
    await recalculateSalesOrderTotals(data, req.target, SalesOrders);
  });
});

async function assignNewIdentifier(data, target) {
  const oQuery = SELECT(`MAX(identifier) as max`).from(target);
  const [result] = await cds.run(oQuery);
  data.identifier = ++result.max;
}

async function assignSalesOrderHeaderDefault(data, Statuses) {
  const oStatusNew = await SELECT.one.from(Statuses).where({ title: "New" });
  data.status_ID = oStatusNew.ID;
}

async function setSalesOrderConfirmedStatus(data, Statuses) {
  if (data.deliveryDate) {
    const oStatusConfirmed = await SELECT.one
      .from(Statuses)
      .where({ title: "Confirmed" });

    data.status_ID = oStatusConfirmed.ID;
  }
}

async function recalculateSalesOrderItem(data, target, Products) {
  const dbItemInfo = await cds.read(target.drafts).where({ ID: data.ID });

  const oProduct = data.product_ID
    ? await SELECT.one.from(Products).where({ ID: data.product_ID })
    : {};

  data.quantity = data.quantity || dbItemInfo[0]?.quantity || 1;
  data.price = oProduct?.price || dbItemInfo[0]?.price || 0;

  data.currency_code = oProduct?.currency_code || dbItemInfo[0]?.currency_code;
  data.amount = data.quantity * data.price;
}

async function recalculateSalesOrderTotals(data, target, SalesOrders) {
  const orderInfo = { totalAmount: 0 };

  const result = await cds
    .read(target.drafts)
    .where({ ID: data.ID })
    .columns(["parent_ID"]);

  const sOrderID = result[0].parent_ID;

  const dbItemInfos = await cds
    .read(target.drafts)
    .where({ parent_ID: sOrderID });

  dbItemInfos.forEach((dbItemInfo) => {
    orderInfo.totalAmount += dbItemInfo.amount;
    orderInfo.currency_code = dbItemInfo.currency_code;
  });

  await cds.update(SalesOrders.drafts, sOrderID).set(orderInfo);
}
