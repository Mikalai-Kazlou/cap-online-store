using OnlineStoreService from './onlinestore-service';

annotate OnlineStoreService.Statuses with {

  @UI.Hidden
  @Core.Computed
  @Common: {
    Text           : title,
    TextArrangement: #TextOnly
  }
  ID;

  @title : '{i18n>ID}'
  @Core.Computed
  identifier;

  @title : '{i18n>Title}'
  @mandatory
  title;

};
