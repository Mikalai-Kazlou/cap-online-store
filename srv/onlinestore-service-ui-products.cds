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
    Value: title
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
    Label : 'Properties',
    Target: '@UI.FieldGroup#Properties'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Description',
    Target: '@UI.FieldGroup#Description'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Images',
    Target: 'images/@UI.LineItem'
  }
]

@UI.FieldGroup #Main       : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: identifier},
    {Value: category_ID},
    {Value: brand_ID},
    {Value: title}
  ]
}

@UI.FieldGroup #Description: {
  $Type: 'UI.FieldGroupType',
  Data : [
    {
      Value: description,
      Label: '',
    },
    {
      $Type: 'UI.DataFieldWithUrl',
      Value: thumbnail,
      Url  : thumbnail
    }
  ]
}

@UI.FieldGroup #Properties : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: price},
    {Value: discount},
    {Value: rating},
    {Value: stock}
  ]
}

{
  @UI.Hidden
  @Core.Computed
  @Common              : {
    Text           : title,
    TextArrangement: #TextOnly
  }
  ID;

  @title               : 'ID'
  @Core.Computed
  identifier;

  @title               : 'Category'
  @mandatory
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
  @mandatory
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
  @mandatory
  title;

  @title               : 'Description'
  @UI.MultiLineText
  description;

  @title               : 'Price'
  @mandatory
  @Measures.ISOCurrency: currency_code
  price;

  @mandatory
  currency;

  @title               : 'Discount'
  discount;

  @title               : 'Rating'
  rating;

  @title               : 'Stock'
  stock;

  @title               : 'Thumbnail'
  @mandatory
  @assert.format       : '^(http:\/\/|https:\/\/)'
  thumbnail;
};

// -------------------------------------------------
// Product images
// -------------------------------------------------
annotate OnlineStoreService.ProductImages with

@UI.LineItem: [
  {
    $Type                : 'UI.DataFieldWithUrl',
    Value                : url,
    Url                  : url,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: createdAt},
  {Value: modifiedAt}
]

{
  @UI.Hidden
  @Core.Computed
  ID;

  @UI.Hidden
  parent;

  @title        : 'Url'
  @mandatory
  @assert.format: '^(http:\/\/|https:\/\/)'
  url;
};
