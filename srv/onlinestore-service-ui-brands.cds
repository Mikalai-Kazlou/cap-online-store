using OnlineStoreService from './onlinestore-service';

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

  @UI.Hidden
  @Common: {
    Text           : title,
    TextArrangement: #TextOnly
  }
  ID;

  @title : 'ID'
  identifier;

  @title : 'Title'
  title;

};
