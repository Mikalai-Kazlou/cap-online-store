using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Sales orders
// -------------------------------------------------
annotate OnlineStoreService.SalesOrders with

@UI.PresentationVariant : {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}

@UI.SelectionFields     : [
  status_ID,
  deliveryDate,
  customerName,
  customerDeliveryAddress,
  customerPhoneNumber,
  customerEmail
]

@UI.LineItem            : [
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

@UI.HeaderInfo          : {
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

@UI.Facets              : [
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

@UI.FieldGroup #Main    : {Data: [
  {Value: identifier},
  {Value: status_ID},
  {Value: deliveryDate}
]}

@UI.FieldGroup #Customer: {Data: [
  {Value: customerName},
  {Value: customerDeliveryAddress},
  {Value: customerPhoneNumber},
  {Value: customerEmail}
]} {

  @UI.Hidden
  ID;

  @title : 'ID'
  identifier;

  @title : 'Status'
  @Common: {
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

  @title : 'Delivery date'
  deliveryDate;

  @title : 'Customer'
  customerName;

  @title : 'Delivery Address'
  customerDeliveryAddress;

  @title : 'Phone number'
  customerPhoneNumber;

  @title : 'Email'
  customerEmail;
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

  @UI.Hidden
  ID;

  @title : 'ID'
  identifier;

  @title : 'Sales order'
  salesOrder;

  @title : 'Product'
  @Common: {
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

  @title : 'Quantity'
  quantity;

  @title : 'Price'
  price;

  @title : 'Amount'
  amount;

  @title : 'Currency'
  currency;

};
