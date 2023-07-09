const cds = require("@sap/cds");

module.exports = cds.service.impl(function () {
  const { Brands, Categories, Products, SalesOrders } = this.entities();

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
});

async function assignNewIdentifier(entity, data) {
  const oQuery = SELECT(`MAX(identifier) as max`).from(entity);
  const [result] = await cds.run(oQuery);
  data.identifier = ++result.max;
}
