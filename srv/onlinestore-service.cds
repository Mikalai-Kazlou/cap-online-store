using {epam.btp.onlinestore as os} from '../db/schema';

@path: 'onlinestore'
service OnlineStoreService {
  @odata.draft.enabled
  entity Products   as projection on os.Products;

  @odata.draft.enabled
  entity Categories as projection on os.Categories;

  @odata.draft.enabled
  entity Brands     as projection on os.Brands;

  function getProductCatalogRangeFilterParameters(property : String) returns {
    min : Decimal;
    max : Decimal;
  };
}
