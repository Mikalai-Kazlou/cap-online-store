using OnlineStoreService from './onlinestore-service';

annotate OnlineStoreService.Statuses with {

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
