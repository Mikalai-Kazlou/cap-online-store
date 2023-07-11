using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Products
// -------------------------------------------------
annotate OnlineStoreService.Products with

@UI.PresentationVariant    : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}

@UI.SelectionFields        : [
  category_ID,
  brand_ID,
  price,
  currency_code,
  discount,
  rating,
  stock
]

@UI.LineItem               : [
  {Value: identifier},
  {Value: category_ID},
  {Value: brand_ID},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: price},
  {Value: discount},
  {Value: rating},
  {Value: stock},
]

@UI.HeaderInfo             : {
  TypeName      : 'Product',
  TypeNamePlural: 'Products',
  Title         : {
    $Type: 'UI.DataField',
    Value: title,
  },
  Description   : {
    $Type: 'UI.DataField',
    Value: brand.title
  },
  ImageUrl      : thumbnail
}

@UI.Facets                 : [
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Main',
    Target: '@UI.FieldGroup#Main'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Description',
    Target: '@UI.FieldGroup#Description'
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

@UI.FieldGroup #Main       : {Data: [
  {Value: identifier},
  {Value: category_ID},
  {Value: brand_ID},
  {Value: title}
]}

@UI.FieldGroup #Description: {Data: [{Value: description}]}

@UI.FieldGroup #Properties : {Data: [
  {Value: price},
  {Value: discount},
  {Value: rating},
  {Value: stock}
]}

{
  @UI.Hidden
  @Common              : {
    Text           : title,
    TextArrangement: #TextOnly
  }
  ID;

  @title               : 'ID'
  identifier;

  @title               : 'Category'
  @Common              : {
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
  }
  category;

  @title               : 'Brand'
  @Common              : {
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
  }
  brand;

  @title               : 'Title'
  title;

  @title               : 'Description'
  @UI.MultiLineText
  description;

  @title               : 'Price'
  @Measures.ISOCurrency: currency_code
  price;

  @title               : 'Discount'
  discount;

  @title               : 'Rating'
  rating;

  @title               : 'Stock'
  stock;

  @title               : 'Thumbnail'
  thumbnail;
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

@UI.FieldGroup #Main: {Data: [{Value: url}]}

{
  @UI.Hidden
  ID;

  @UI.Hidden
  parent;

  @title: 'Url'
  url;
};
