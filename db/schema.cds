namespace epam.btp.onlinestore;

using {
  cuid,
  managed,
  Currency
} from '@sap/cds/common';

@assert.unique.identifier: [identifier]
entity Products : cuid, managed {
  key ID          : UUID                      @Core.Computed;
      identifier  : Integer                   @Core.Computed;
      category    : Association to Categories @mandatory;
      brand       : Association to Brands     @mandatory;
      title       : String(100)               @mandatory;
      description : String;
      price       : Decimal                   @mandatory;
      currency    : Currency                  @mandatory;
      discount    : Decimal;
      rating      : Decimal;
      stock       : Integer;

      @assert.format: '^(http:\/\/|https:\/\/)'
      thumbnail   : String                    @mandatory;
      images      : Composition of many ProductImages
                      on images.parent = $self;
}

entity ProductImages : managed {
  key ID     : UUID   @Core.Computed;
      parent : Association to Products;

      @assert.format: '^(http:\/\/|https:\/\/)'
      url    : String @mandatory;
}

@assert.unique.identifier: [identifier]
entity Categories : cuid, managed {
  key ID         : UUID       @Core.Computed;
      identifier : Integer    @Core.Computed;
      title      : String(50) @mandatory;
}

@assert.unique.identifier: [identifier]
entity Brands : cuid, managed {
  key ID         : UUID       @Core.Computed;
      identifier : Integer    @Core.Computed;
      title      : String(50) @mandatory;
}

@assert.unique.identifier: [identifier]
entity SalesOrders : cuid, managed {
  key ID                      : UUID                    @Core.Computed;
      identifier              : Integer                 @Core.Computed;
      status                  : Association to Statuses @Core.Computed;
      deliveryDate            : DateTime;
      customerName            : String(100)             @mandatory;
      customerDeliveryAddress : String(250)             @mandatory;
      customerPhoneNumber     : String(15)              @mandatory;
      customerEmail           : String(50);
      totalAmount             : Decimal                 @Core.Computed;
      currency                : Currency                @Core.Computed;
      items                   : Composition of many SalesOrderItems
                                  on items.parent = $self;
}

entity SalesOrderItems : managed {
  key ID       : UUID                    @Core.Computed;
      parent   : Association to SalesOrders;
      product  : Association to Products @mandatory;
      quantity : Integer                 @mandatory;
      price    : Decimal                 @Core.Computed;
      amount   : Decimal                 @Core.Computed;
      currency : Currency                @Core.Computed;
}

@assert.unique.identifier: [identifier]
entity Statuses : cuid {
  key ID         : UUID       @Core.Computed;
      identifier : Integer    @Core.Computed;
      title      : String(50) @mandatory;
}

type RangeFilterParameters : {
  min : Decimal;
  max : Decimal;
};
