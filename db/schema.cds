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
