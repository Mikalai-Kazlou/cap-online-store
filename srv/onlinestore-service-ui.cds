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
}

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
  identifier @title : 'Identifier';
  product    @title : 'Product';
  url        @title : 'Url';
}
