namespace epam.btp.onlinestore;

using {
  managed,
  Currency
} from '@sap/cds/common';

@assert.unique.identifier: [identifier]
entity Products : managed {
  key ID          : UUID;
      identifier  : Integer;
      category    : Association to Categories;
      brand       : Association to Brands;
      title       : String(100);
      description : String;
      price       : Decimal;
      currency    : Currency;
      discount    : Decimal;
      rating      : Decimal;
      stock       : Integer;
      thumbnail   : String;
      criticality : Integer;
      images      : Composition of many ProductImages
                      on images.parent = $self;
};

entity ProductImages : managed {
  key ID     : UUID;
      parent : Association to Products;
      url    : String;
};

@assert.unique.identifier: [identifier]
entity Categories : managed {
  key ID         : UUID;
      identifier : Integer;
      title      : String(50);
};

@assert.unique.identifier: [identifier]
entity Brands : managed {
  key ID         : UUID;
      identifier : Integer;
      title      : String(50);
};

@assert.unique.identifier: [identifier]
entity SalesOrders : managed {
  key ID                      : UUID;
      identifier              : Integer;
      status                  : Association to Statuses;
      deliveryDate            : DateTime;
      customerName            : String(100);
      customerDeliveryAddress : String(250);
      customerPhoneNumber     : String(15);
      customerEmail           : String(50);
      totalAmount             : Decimal;
      currency                : Currency;
      criticality             : Integer;
      items                   : Composition of many SalesOrderItems
                                  on items.parent = $self;
      averageValues           : Association to AverageSalesOrderValues
                                  on averageValues.currency = currency;
};

entity SalesOrderItems : managed {
  key ID       : UUID;
      parent   : Association to SalesOrders;
      product  : Association to Products;
      quantity : Integer;
      price    : Decimal;
      amount   : Decimal;
      currency : Currency;
};

@assert.unique.identifier: [identifier]
entity Statuses {
  key ID         : UUID;
      identifier : Integer;
      title      : String(50);
};

type RangeFilterParameters : {
  min : Decimal;
  max : Decimal;
};

view AverageSalesOrderValues as
  select from SalesOrders {

        @Semantics.currencyCode       : true
    key currency,

        @Semantics.amount.currencyCode: 'currency'
        AVG(totalAmount) as avgTotalAmount : Decimal,

        @Semantics.amount.currencyCode: 'currency'
        MAX(totalAmount) as maxTotalAmount : Decimal
  }
  group by
    currency;
