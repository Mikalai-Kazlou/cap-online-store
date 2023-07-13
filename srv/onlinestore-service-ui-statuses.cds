using OnlineStoreService from './onlinestore-service';

annotate OnlineStoreService.Statuses with {

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
