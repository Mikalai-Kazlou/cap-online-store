const cds = require("@sap/cds");

module.exports = cds.service.impl(function () {
  const { Products } = this.entities();

  this.on("getProductCatalogRangeFilterParameters", async (req) => {
    const sProperty = req.data.property;

    const sValues = `{ MIN(${sProperty}) as min, MAX(${sProperty}) as max }`;
    const oQuery = SELECT(`${sValues}`).from(Products);

    return await cds.run(oQuery);
  });
});
