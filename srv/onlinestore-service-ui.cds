using OnlineStoreService from './onlinestore-service';

// -------------------------------------------------
// Categories
// -------------------------------------------------
annotate OnlineStoreService.Categories with
@UI.PresentationVariant: {
  Visualizations: ['@UI.LineItem'],
  SortOrder     : [{Property: identifier}]
}
@UI.HeaderInfo         : {
  TypeName      : 'Category',
  TypeNamePlural: 'Categories',
  Title         : {
    $Type: 'UI.DataField',
    Value: title
  }
}
@UI.LineItem           : [
  {Value: identifier},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  }
]
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
@UI.HeaderInfo         : {
  TypeName      : 'Brand',
  TypeNamePlural: 'Brands',
  Title         : {
    $Type: 'UI.DataField',
    Value: title
  }
}
@UI.LineItem           : [
  {Value: identifier},
  {
    Value                : title,
    ![@HTML5.CssDefaults]: {width: '100%'}
  }
]
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
