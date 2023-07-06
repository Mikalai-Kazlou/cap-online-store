using {epam.btp.onlinestore as os} from '../db/schema';

@path: 'onlinestore'
service OnlineStoreService {
  @odata.draft.enabled
  entity Products @(restrict: [
    {
      grant: ['READ'],
      to   : ['Customer']
    },
    {
      grant: ['*'],
      to   : ['ShopManager']
    }
  ]) as projection on os.Products;

  @odata.draft.enabled
  entity Categories @(restrict: [
    {
      grant: ['READ'],
      to   : ['Customer']
    },
    {
      grant: ['*'],
      to   : ['ShopManager']
    }
  ]) as projection on os.Categories;

  @odata.draft.enabled
  entity Brands @(restrict: [
    {
      grant: ['READ'],
      to   : ['Customer']
    },
    {
      grant: ['*'],
      to   : ['ShopManager']
    }
  ]) as projection on os.Brands;

  function getProductRangeFilterParameters(property : String) returns os.RangeFilterParameters;
}
