namespace epam.btp.onlinestore;

using {
  managed,
  Currency
} from '@sap/cds/common';

entity Products : managed {
  key ID          : UUID @(Core.Computed: true);
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
      images      : Composition of many ProductImages
                      on images.product = $self;
}

entity ProductImages : managed {
  key ID         : UUID @(Core.Computed: true);
      identifier : Integer;
      product    : Association to Products;
      url        : String;
}

entity Categories : managed {
  key ID         : UUID @(Core.Computed: true);
      identifier : Integer;
      title      : String(50);
}

entity Brands : managed {
  key ID         : UUID @(Core.Computed: true);
      identifier : Integer;
      title      : String(50);
}

entity SalesOrders : managed {
  key ID                      : UUID @(Core.Computed: true);
      identifier              : Integer;
      status                  : Association to Statuses;
      deliveryDate            : DateTime;
      customerName            : String(100);
      customerDeliveryAddress : String(250);
      customerPhoneNumber     : String(15);
      customerEmail           : String(50);
      items                   : Composition of many SalesOrderItems
                                  on items.salesOrder = $self;
}

entity SalesOrderItems : managed {
  key ID         : UUID @(Core.Computed: true);
      identifier : Integer;
      salesOrder : Association to SalesOrders;
      product    : Association to Products;
      quantity   : Integer;
      price      : Decimal;
      amount     : Decimal;
      currency   : Currency;
}

entity Statuses {
  key ID         : UUID @(Core.Computed: true);
      identifier : Integer;
      title      : String(50);
}

type RangeFilterParameters : {
  min : Decimal;
  max : Decimal;
};
