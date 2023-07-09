using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Categories
// -------------------------------------------------
annotate OnlineStoreService.Categories with
@UI.PresentationVariant: {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}
@UI.LineItem           : [
  {Value: identifier},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  }
]
@UI.HeaderInfo         : {
  TypeName      : 'Category',
  TypeNamePlural: 'Categories',
  Title         : {
    $Type: 'UI.DataField',
    Value: title
  }
}
@UI.Facets             : [{
  $Type : 'UI.ReferenceFacet',
  Label : 'Main',
  Target: '@UI.FieldGroup#Main'
}]
@UI.FieldGroup #Main   : {Data: [
  {Value: identifier},
  {Value: title}
]} {
  ID         @UI.Hidden;
  identifier @title    : 'Identifier';
  title      @title    : 'Title';
};

// -------------------------------------------------
// Brands
// -------------------------------------------------
annotate OnlineStoreService.Brands with
@UI.PresentationVariant: {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}
@UI.LineItem           : [
  {Value: identifier},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  }
]
@UI.HeaderInfo         : {
  TypeName      : 'Brand',
  TypeNamePlural: 'Brands',
  Title         : {
    $Type: 'UI.DataField',
    Value: title
  }
}
@UI.Facets             : [{
  $Type : 'UI.ReferenceFacet',
  Label : 'Main',
  Target: '@UI.FieldGroup#Main'
}]
@UI.FieldGroup #Main   : {Data: [
  {Value: identifier},
  {Value: title}
]} {
  ID         @UI.Hidden;
  identifier @title    : 'Identifier';
  title      @title    : 'Title';
};

// -------------------------------------------------
// Products
// -------------------------------------------------
annotate OnlineStoreService.Products with
@UI.PresentationVariant   : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}
@UI.SelectionFields       : [
  category_ID,
  brand_ID,
  price,
  currency_code,
  discount,
  rating,
  stock
]
@UI.LineItem              : [
  {Value: identifier},
  {Value: category_ID},
  {Value: brand_ID},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: price},
  {Value: currency_code},
  {Value: discount},
  {Value: rating},
  {Value: stock},
]
@UI.HeaderInfo            : {
  TypeName      : 'Product',
  TypeNamePlural: 'Products',
  Title         : {
    $Type: 'UI.DataField',
    Value: title
  },
  Description   : {
    $Type: 'UI.DataField',
    Value: description
  },
  ImageUrl      : thumbnail
}
@UI.Facets                : [
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Main',
    Target: '@UI.FieldGroup#Main'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Properties',
    Target: '@UI.FieldGroup#Properties'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Images',
    Target: 'images/@UI.LineItem'
  }
]
@UI.FieldGroup #Main      : {Data: [
  {Value: identifier},
  {Value: category_ID},
  {Value: brand_ID},
  {Value: title}
]}
@UI.FieldGroup #Properties: {Data: [
  {Value: price},
  {Value: currency_code},
  {Value: discount},
  {Value: rating},
  {Value: stock}
]} {
  ID          @UI.Hidden;
  identifier  @title      : 'Identifier';
  category    @title      : 'Category';
  brand       @title      : 'Brand';
  title       @title      : 'Title';
  description @title      : 'Description';
  price       @title      : 'Price';
  discount    @title      : 'Discount';
  rating      @title      : 'Rating';
  stock       @title      : 'Stock';
  thumbnail   @title      : 'Thumbnail';
};

annotate OnlineStoreService.Products with {
  brand    @Common: {
    Text           : brand.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : 'Brands',
      CollectionPath: 'Brands',
      Parameters    : [
        {
          $Type            : 'Common.ValueListParameterInOut',
          LocalDataProperty: brand_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type            : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'title'
        }
      ]
    }
  };
  category @Common: {
    Text           : category.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : 'Categories',
      CollectionPath: 'Categories',
      Parameters    : [
        {
          $Type            : 'Common.ValueListParameterInOut',
          LocalDataProperty: category_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type            : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'title',
        }
      ]
    }
  };
};

// -------------------------------------------------
// Product images
// -------------------------------------------------
annotate OnlineStoreService.ProductImages with
@UI.LineItem        : [
  {
    Value                : url,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: createdAt},
  {Value: modifiedAt}
]
@UI.Facets          : [{
  $Type : 'UI.ReferenceFacet',
  Label : 'Main',
  Target: '@UI.FieldGroup#Main'
}]
@UI.FieldGroup #Main: {Data: [
  {Value: identifier},
  {Value: url}
]} {
  ID         @UI.Hidden;
  identifier @title : 'Identifier';
  product    @title : 'Product';
  url        @title : 'Url';
};

// -------------------------------------------------
// Sales orders
// -------------------------------------------------
annotate OnlineStoreService.SalesOrders with
@UI.PresentationVariant         : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}
@UI.SelectionFields             : [
  status_ID,
  deliveryDate,
  customerName,
  customerDeliveryAddress,
  customerPhoneNumber,
  customerEmail
]
@UI.LineItem                    : [
  {Value: identifier},
  {Value: status_ID},
  {Value: deliveryDate},
  {Value: customerName},
  {
    Value                : customerDeliveryAddress,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: customerPhoneNumber},
  {Value: customerEmail}
]
@UI.HeaderInfo                  : {
  TypeName      : 'Sales order',
  TypeNamePlural: 'Sales orders',
  Title         : {
    $Type: 'UI.DataField',
    Value: identifier
  },
  Description   : {
    $Type: 'UI.DataField',
    Value: customerName
  }
}
@UI.Facets                      : [
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Main',
    Target: '@UI.FieldGroup#Main'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Customer',
    Target: '@UI.FieldGroup#Customer'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Items',
    Target: 'items/@UI.LineItem'
  }
]
@UI.FieldGroup #Main            : {Data: [
  {Value: identifier},
  {Value: status_ID},
  {Value: deliveryDate}
]}
@UI.FieldGroup #Customer        : {Data: [
  {Value: customerName},
  {Value: customerDeliveryAddress},
  {Value: customerPhoneNumber},
  {Value: customerEmail}
]} {
  ID                      @UI.Hidden;
  identifier              @title: 'Identifier';
  status                  @title: 'Status';
  deliveryDate            @title: 'Delivery date';
  customerName            @title: 'Customer';
  customerDeliveryAddress @title: 'Delivery Address';
  customerPhoneNumber     @title: 'Phone number';
  customerEmail           @title: 'Email';
};

annotate OnlineStoreService.SalesOrders with {
  status @Common: {
    Text           : status.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : 'Statuses',
      CollectionPath: 'Statuses',
      Parameters    : [
        {
          $Type            : 'Common.ValueListParameterInOut',
          LocalDataProperty: status_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type            : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'title'
        }
      ]
    }
  };
};

// -------------------------------------------------
// Product images
// -------------------------------------------------
annotate OnlineStoreService.SalesOrderItems with
@UI.LineItem        : [
  {
    Value                : product_ID,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: quantity},
  {Value: price},
  {Value: amount},
  {Value: currency_code}
]
@UI.Facets          : [{
  $Type : 'UI.ReferenceFacet',
  Label : 'Main',
  Target: '@UI.FieldGroup#Main'
}]
@UI.FieldGroup #Main: {Data: [
  {Value: identifier},
  {Value: product_ID},
  {Value: quantity},
  {Value: price},
  {Value: amount},
  {Value: currency_code}
]} {
  ID         @UI.Hidden;
  identifier @title : 'Identifier';
  salesOrder @title : 'Sales order';
  product    @title : 'Product';
  quantity   @title : 'Quantity';
  price      @title : 'Price';
  amount     @title : 'Amount';
  currency   @title : 'Currency';
};

annotate OnlineStoreService.SalesOrderItems with {
  product @Common: {
    Text           : product.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : 'Products',
      CollectionPath: 'Products',
      Parameters    : [
        {
          $Type            : 'Common.ValueListParameterInOut',
          LocalDataProperty: product_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type            : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'title'
        }
      ]
    }
  };
};
