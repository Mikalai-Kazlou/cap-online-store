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
      await assignNewIdentifier(req.target, req.data);
    }
  );

  this.before("NEW", [SalesOrders], async (req) => {
    await assignSalesOrderHeaderDefault(req.data, Statuses);
  });

  this.before(["NEW", "PATCH"], [SalesOrderItems], async (req) => {
    await recalculateSalesOrderItem(req.target, req.data, Products);
  });
});

async function assignNewIdentifier(entity, data) {
  const oQuery = SELECT(`MAX(identifier) as max`).from(entity);
  const [result] = await cds.run(oQuery);
  data.identifier = ++result.max;
}

async function assignSalesOrderHeaderDefault(data, Statuses) {
  const oStatusNew = await SELECT.one.from(Statuses).where({ title: "New" });
  data.status_ID = oStatusNew.ID;
}

async function recalculateSalesOrderItem(entity, data, Products) {
  const dbItemInfo = await cds.read(entity.drafts).where({ ID: data.ID });
  let oProduct = {};

  if (data.product_ID) {
    oProduct = await SELECT.one.from(Products).where({ ID: data.product_ID });
  }

  data.quantity = data.quantity || dbItemInfo[0]?.quantity || 1;
  data.price = oProduct?.price || dbItemInfo[0]?.price || 0;
  data.currency_code = oProduct?.currency_code || dbItemInfo[0]?.currency_code;
  data.amount = data.quantity * data.price;
}
