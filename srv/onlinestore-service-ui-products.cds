using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Products
// -------------------------------------------------
annotate OnlineStoreService.Products with

@UI.PresentationVariant     : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}

@UI.SelectionFields         : [
  category_ID,
  brand_ID,
  price,
  currency_code,
  discount,
  rating,
  stock
]

@UI.LineItem                : [
  {Value: identifier},
  {Value: category_ID},
  {Value: brand_ID},
  {
    Value                : title,
    Criticality          : criticality,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: price},
  {Value: discount},
  {Value: rating},
  {
    Value                    : stock,
    Criticality              : criticality,
    CriticalityRepresentation: #WithoutIcon
  },
]

@UI.HeaderInfo              : {
  TypeName      : '{i18n>ProductsTypeName}',
  TypeNamePlural: '{i18n>ProductsTypeNamePlural}',
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

@UI.Facets                  : [
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupMain}',
    Target: '@UI.FieldGroup#Main'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupProperties}',
    Target: '@UI.FieldGroup#Properties'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupPresentation}',
    Target: '@UI.FieldGroup#Presentation'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupImages}',
    Target: 'images/@UI.PresentationVariant#Main'
  }
]

@UI.FieldGroup #Main        : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: identifier},
    {Value: category_ID},
    {Value: brand_ID},
    {Value: title}
  ]
}

@UI.FieldGroup #Presentation: {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: description},
    {
      $Type: 'UI.DataFieldWithUrl',
      Value: thumbnail,
      Url  : thumbnail
    }
  ]
}

@UI.FieldGroup #Properties  : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: price},
    {Value: discount},
    {Value: rating},
    {
      Value      : stock,
      Criticality: criticality
    }
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

  @title               : '{i18n>ID}'
  @Core.Computed
  identifier;

  @title               : '{i18n>Category}'
  @mandatory
  @Common              : {
    Text           : category.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : '{i18n>CategoriesTypeNamePlural}',
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

  @title               : '{i18n>Brand}'
  @mandatory
  @Common              : {
    Text           : brand.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : '{i18n>BrandsTypeNamePlural}',
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

  @title               : '{i18n>Title}'
  @mandatory
  title;

  @title               : '{i18n>Description}'
  @UI.MultiLineText
  description;

  @title               : '{i18n>Price}'
  @mandatory
  @Measures.ISOCurrency: currency_code
  price;

  @mandatory
  currency;

  @title               : '{i18n>Discount}'
  discount;

  @title               : '{i18n>Rating}'
  rating;

  @title               : '{i18n>Stock}'
  stock;

  @title               : '{i18n>Thumbnail}'
  @mandatory
  @assert.format       : '^(http:\/\/|https:\/\/)'
  thumbnail;

  @UI.Hidden
  criticality;
};

// -------------------------------------------------
// Product images
// -------------------------------------------------
annotate OnlineStoreService.ProductImages with

@UI.PresentationVariant #Main: {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: createdAt}]
}

@UI.LineItem                 : [
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

  @title        : '{i18n>Url}'
  @mandatory
  @assert.format: '^(http:\/\/|https:\/\/)'
  url;
};
