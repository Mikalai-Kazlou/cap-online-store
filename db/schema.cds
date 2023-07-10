namespace epam.btp.onlinestore;

using {
  managed,
  Currency
} from '@sap/cds/common';

entity Products : managed {
  key ID          : UUID                      @Core.Computed: true;
      identifier  : Integer                   @Core.Computed: true;
      category    : Association to Categories @mandatory;
      brand       : Association to Brands     @mandatory;
      title       : String(100)               @mandatory;
      description : String;
      price       : Decimal                   @mandatory;
      currency    : Currency                  @mandatory;
      discount    : Decimal;
      rating      : Decimal;
      stock       : Integer;
      thumbnail   : String;
      images      : Composition of many ProductImages
                      on images.parent = $self;
}

entity ProductImages : managed {
  key ID     : UUID   @Core.Computed: true;
      parent : Association to Products;
      url    : String @mandatory;
}

entity Categories : managed {
  key ID         : UUID       @Core.Computed: true;
      identifier : Integer    @Core.Computed: true;
      title      : String(50) @mandatory;
}

entity Brands : managed {
  key ID         : UUID       @Core.Computed: true;
      identifier : Integer    @Core.Computed: true;
      title      : String(50) @mandatory;
}

entity SalesOrders : managed {
  key ID                      : UUID                    @Core.Computed: true;
      identifier              : Integer                 @Core.Computed: true;
      status                  : Association to Statuses @mandatory;
      deliveryDate            : DateTime;
      customerName            : String(100)             @mandatory;
      customerDeliveryAddress : String(250)             @mandatory;
      customerPhoneNumber     : String(15)              @mandatory;
      customerEmail           : String(50);
      items                   : Composition of many SalesOrderItems
                                  on items.parent = $self;
}

entity SalesOrderItems : managed {
  key ID       : UUID                    @Core.Computed: true;
      parent   : Association to SalesOrders;
      product  : Association to Products @mandatory;
      quantity : Integer                 @mandatory;
      price    : Decimal                 @mandatory;
      amount   : Decimal                 @mandatory;
      currency : Currency                @mandatory;
}

entity Statuses {
  key ID         : UUID       @Core.Computed: true;
      identifier : Integer    @Core.Computed: true;
      title      : String(50) @mandatory;
}

type RangeFilterParameters : {
  min : Decimal;
  max : Decimal;
};
