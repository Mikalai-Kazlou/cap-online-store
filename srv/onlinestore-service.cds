using {epam.btp.onlinestore as os} from '../db/schema';

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
  ])              as projection on os.Products;

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
  ])              as projection on os.Categories;

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
  ])              as projection on os.Brands;

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
  ])              as projection on os.SalesOrders;

  @readonly
  entity Statuses as projection on os.Statuses;

  function getProductRangeFilterParameters(property : String) returns os.RangeFilterParameters;
}
