using OnlineStoreService from './onlinestore-service';

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
]}

{
  @UI.Hidden
  @Core.Computed
  @Common: {
    Text           : title,
    TextArrangement: #TextOnly
  }
  ID;

  @title : 'ID'
  @Core.Computed
  identifier;

  @title : 'Title'
  @mandatory
  title;
};
