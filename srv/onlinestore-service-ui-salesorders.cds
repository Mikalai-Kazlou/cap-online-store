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

@UI.LineItem                            : [
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
  TypeName      : 'Sales order',
  TypeNamePlural: 'Sales orders',
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
    Label : 'Totals',
    Target: '@UI.FieldGroup#Totals'
  },
  {
    $Type : 'UI.ReferenceFacet',
    Label : 'Items',
    Target: 'items/@UI.LineItem'
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
  ID;

  @title               : 'ID'
  identifier;

  @title               : 'Status'
  @Common              : {
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
  }
  status;

  @title               : 'Delivery date'
  deliveryDate;

  @title               : 'Customer'
  customerName;

  @title               : 'Delivery Address'
  customerDeliveryAddress;

  @title               : 'Phone number'
  customerPhoneNumber;

  @title               : 'Email'
  customerEmail;

  @title               : 'Total amount'
  @Measures.ISOCurrency: currency_code
  totalAmount;
};

// -------------------------------------------------
// Sales order items
// -------------------------------------------------
annotate OnlineStoreService.SalesOrderItems with

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
  Label : 'Main',
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
  ID;

  @UI.Hidden
  parent;

  @title               : 'Product'
  @Common              : {
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
  }
  product;

  @title               : 'Quantity'
  quantity;

  @title               : 'Price'
  @Measures.ISOCurrency: currency_code
  price;

  @title               : 'Amount'
  @Measures.ISOCurrency: currency_code
  amount;
};
