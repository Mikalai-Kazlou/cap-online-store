using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Sales orders
// -------------------------------------------------
annotate OnlineStoreService.SalesOrders with

@UI.PresentationVariant                 : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}

@UI.SelectionFields                     : [
  status_ID,
  deliveryDate,
  customerName,
  customerDeliveryAddress,
  customerPhoneNumber,
  customerEmail,
  totalAmount
]

@UI.Identification                      : [{
  $Type        : 'UI.DataFieldForAction',
  Label        : '{i18n>ButtonSetToDelivered}',
  Action       : 'OnlineStoreService.setDeliveredStatus',
  ![@UI.Hidden]: {$edmJson: {$Ne: [
    {$Path: 'status/title'},
    'Confirmed'
  ]}}
}]

@UI.LineItem                            : [
  {
    $Type : 'UI.DataFieldForAction',
    Label : '{i18n>ButtonSetToDelivered}',
    Action: 'OnlineStoreService.setDeliveredStatus'
  },
  {Value: identifier},
  {Value: status_ID},
  {Value: deliveryDate},
  {Value: customerName},
  {
    Value                : customerDeliveryAddress,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: customerPhoneNumber},
  {Value: customerEmail},
  {Value: totalAmount}
]

@UI.HeaderInfo                          : {
  TypeName      : '{i18n>SalesOrdersTypeName}',
  TypeNamePlural: '{i18n>SalesOrdersTypeNamePlural}',
  Title         : {
    $Type: 'UI.DataField',
    Value: customerName
  },
  Description   : {
    $Type: 'UI.DataField',
    Value: customerDeliveryAddress
  }
}

@UI.Facets                              : [
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupMain}',
    Target: '@UI.FieldGroup#Main'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupCustomer}',
    Target: '@UI.FieldGroup#Customer'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupTotals}',
    Target: '@UI.FieldGroup#Totals'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>FieldGroupItems}',
    Target: 'items/@UI.PresentationVariant#Main'
  }
]

@UI.FieldGroup #Main                    : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: identifier},
    {Value: status_ID},
    {Value: deliveryDate}
  ]
}

@UI.FieldGroup #Customer                : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: customerName},
    {Value: customerDeliveryAddress},
    {Value: customerPhoneNumber},
    {Value: customerEmail}
  ]
}

@UI.FieldGroup #Totals                  : {
  $Type: 'UI.FieldGroupType',
  Data : [{Value: totalAmount}, ]
}

@Common.SideEffects #DeliveryDateChanged: {
  SourceProperties: ['deliveryDate'],
  TargetProperties: ['status_ID']
}

@Common.SideEffects #ItemChanged        : {
  SourceEntities  : [items],
  TargetProperties: [
    'totalAmount',
    'currency_code'
  ]
}

{
  @UI.Hidden
  @Core.Computed
  ID;

  @title               : '{i18n>ID}'
  @Core.Computed
  identifier;

  @title               : '{i18n>Status}'
  @Core.Computed
  @Common              : {
    Text           : status.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : '{i18n>StatusesTypeNamePlural}',
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
  }
  status;

  @title               : '{i18n>DeliveryDate}'
  deliveryDate;

  @title               : '{i18n>Customer}'
  @mandatory
  customerName;

  @title               : '{i18n>DeliveryAddress}'
  @mandatory
  customerDeliveryAddress;

  @title               : '{i18n>PhoneNumber}'
  @mandatory
  @assert.format       : '^\+[0-9]{9,}$'
  customerPhoneNumber;

  @title               : '{i18n>Email}'
  customerEmail;

  @title               : '{i18n>TotalAmount}'
  @Core.Computed
  @Measures.ISOCurrency: currency_code
  totalAmount;

  @Core.Computed
  currency;
};

// -------------------------------------------------
// Sales order items
// -------------------------------------------------
annotate OnlineStoreService.SalesOrderItems with

@UI.PresentationVariant #Main       : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: createdAt}]
}

@UI.LineItem                        : [
  {
    Value                : product_ID,
    ![@HTML5.CssDefaults]: {width: '100%'}
  },
  {Value: quantity},
  {Value: price},
  {Value: amount}
]

@UI.Facets                          : [{
  $Type : 'UI.ReferenceFacet',
  Label : '{i18n>FieldGroupMain}',
  Target: '@UI.FieldGroup#Main'
}]

@UI.FieldGroup #Main                : {
  $Type: 'UI.FieldGroupType',
  Data : [
    {Value: product_ID},
    {Value: quantity},
    {Value: price},
    {Value: amount}
  ]
}

@Common.SideEffects #ProductChanged : {
  SourceProperties: ['product_ID'],
  TargetProperties: [
    'quantity',
    'price',
    'currency_code',
    'amount'
  ]
}

@Common.SideEffects #QuantityChanged: {
  SourceProperties: ['quantity'],
  TargetProperties: ['amount']
}

{
  @UI.Hidden
  @Core.Computed
  ID;

  @UI.Hidden
  parent;

  @title               : '{i18n>Product}'
  @mandatory
  @Common              : {
    Text           : product.title,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : '{i18n>ProductsTypeNamePlural}',
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
  }
  product;

  @title               : '{i18n>Quantity}'
  @mandatory
  quantity;

  @title               : '{i18n>Price}'
  @Core.Computed
  @Measures.ISOCurrency: currency_code
  price;

  @title               : '{i18n>Amount}'
  @Core.Computed
  @Measures.ISOCurrency: currency_code
  amount;

  @UI.Hidden
  currency;
};
