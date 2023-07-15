using {epam.btp.onlinestore as db} from '../db/schema';

@path: 'onlinestore'
service OnlineStoreService {
  @odata.draft.enabled
  entity Products @(restrict: [
    {
      grant: ['READ'],
      to   : [
        'Customer',
        'SalesManager'
      ]
    },
    {
      grant: ['*'],
      to   : [
        'ShopManager',
        'Administrator'
      ]
    }
  ])  as projection on db.Products;

  @odata.draft.enabled
  entity Categories @(restrict: [
    {
      grant: ['READ'],
      to   : [
        'Customer',
        'SalesManager'
      ]
    },
    {
      grant: ['*'],
      to   : [
        'ShopManager',
        'Administrator'
      ]
    }
  ])  as projection on db.Categories;

  @odata.draft.enabled
  entity Brands @(restrict: [
    {
      grant: ['READ'],
      to   : [
        'Customer',
        'SalesManager'
      ]
    },
    {
      grant: ['*'],
      to   : [
        'ShopManager',
        'Administrator'
      ]
    }
  ])  as projection on db.Brands;

  @odata.draft.enabled
  entity SalesOrders @(restrict: [
    {
      grant: ['CREATE'],
      to   : ['Customer']
    },
    {
      grant: [
        'READ',
        'UPDATE'
      ],
      to   : ['Customer'],
      where: 'CreatedBy = $user'
    },
    {
      grant: ['*'],
      to   : [
        'SalesManager',
        'Administrator'
      ]
    }
  ])  as projection on db.SalesOrders actions {

    @cds.odata.bindingparameter.name: '_it'
    @Common.SideEffects             : {TargetProperties: ['_it/status_ID']}
    action setDeliveredStatus();
  };

  @readonly
  entity Statuses @(restrict: [{
    grant: 'READ',
    to   : 'authenticated-user'
  }]) as projection on db.Statuses;

  function getProductRangeFilterParameters @(restrict: [{to: [
    'Customer',
    'SalesManager',
    'Administrator'
  ]}])(property : String) returns db.RangeFilterParameters;
}
