sap.ui.define(
  [
    './BaseController',
    'sap/ui/model/Filter',
    'sap/ui/model/FilterType',
    'sap/ui/model/FilterOperator',
    'sap/ui/model/Sorter',
    'sap/ui/layout/cssgrid/GridBoxLayout',
    'sap/m/ButtonType',
  ],
  function (BaseController, Filter, FilterType, FilterOperator, Sorter, GridBoxLayout, ButtonType) {
    'use strict';

    return BaseController.extend('ns.shop.controller.ProductCatalog', {
      onInit: function () {
        const oRouter = this.getRouter();
        oRouter.getRoute('main').attachPatternMatched(this._onPatternMatched, this);
      },

      _onPatternMatched: function () {
        this._setAddToCartButtonsAttributes();
        this._setRangeFilterAttributes(this.byId('idFilterPrice'), 'price');
        this._setRangeFilterAttributes(this.byId('idFilterStock'), 'stock');
      },

      createProductCatalogListContent: function (sId) {
        const oListViewSelector = this.byId('idListViewSelector');

        let sListItemId = 'idListItemLarge';
        let oLayoutSettings = { boxMinWidth: '22rem' };

        if (oListViewSelector.getSelectedKey() === 'list') {
          sListItemId = 'idListItemSmall';
          oLayoutSettings = { boxMinWidth: '100%' };
        }

        const oUIControl = this.byId(sListItemId).clone(sId);
        const oLayout = new GridBoxLayout(oLayoutSettings);

        const oList = this.byId('idProductCatalog');
        oList.setCustomLayout(oLayout);

        return oUIControl;
      },

      onListViewSelectorChange: function (oEvent) {
        const oProductCatalog = this.byId('idProductCatalog');
        const oBindingInfo = oProductCatalog.getBindingInfo('items');

        let oBinding = oProductCatalog.getBinding('items');
        let aFilters = oBinding.getFilters(FilterType.Application);

        oProductCatalog.unbindItems();
        oProductCatalog.bindItems(oBindingInfo);

        oBinding = oProductCatalog.getBinding('items');
        oBinding.filter(aFilters, FilterType.Application);
        this._applySorts(this.byId('idListSortSelector'), oBinding);
      },

      onOpenDetails: function (oEvent) {
        const oButton = oEvent.getSource();
        this.navTo('details', {
          id: oButton.getBindingContext('main').getObject().ID,
        });
      },

      onProductCatalogUpdateFinished(oEvent) {
        this._setAddToCartButtonsAttributes();
      },

      _setAddToCartButtonsAttributes: function () {
        const oProductCatalog = this.byId('idProductCatalog');
        const aItems = oProductCatalog.getItems();

        aItems.forEach((item) => {
          const oItemData = item.getBindingContext('main').getObject();
          const oAddToCartButton = item.getContent()[0].getControlsByFieldGroupId('idAddToCartButtonGroup')[0];
          this._setAddToCartButtonAttributes(oItemData.ID, oAddToCartButton);
        });
      },

      _setAddToCartButtonAttributes: function (id, oButton) {
        const oBundle = this.getResourceBundle();

        if (this.oCart.has(id)) {
          oButton.setType(ButtonType.Success);
          oButton.setText(oBundle.getText('productCatalogDropFromCartButtonText'));
        } else {
          oButton.setType(ButtonType.Default);
          oButton.setText(oBundle.getText('productCatalogAddToCartButtonText'));
        }
      },

      _setRangeFilterAttributes: function (oFilter, sProperty) {
        const oModel = this.getModel('main');

        const oOperation = oModel.bindContext(`/getProductRangeFilterParameters(...)`);
        oOperation.setParameter('property', sProperty);

        oOperation.execute().then(() => {
          const oResults = oOperation.getBoundContext().getObject();
          const { min, max } = oResults;

          oFilter.setMin(+min);
          oFilter.setMax(+max);
          oFilter.setRange([+min, +max]);
        });
      },

      onSortingChange: function (oEvent) {
        const oProductCatalog = this.byId('idProductCatalog');
        const oBinding = oProductCatalog.getBinding('items');

        this._applySorts(oEvent.getSource(), oBinding);
      },

      _applySorts: function (oSource, oBinding) {
        const sSortingKey = oSource.getSelectedKey();
        const [sProperty, sDirection] = sSortingKey.split('-');
        oBinding.sort([new Sorter(sProperty, Boolean(sDirection))]);
      },

      _applyFilters: function (filters, property) {
        const oProductCatalog = this.byId('idProductCatalog');
        const oBinding = oProductCatalog.getBinding('items');

        let aFilters = oBinding.getFilters(FilterType.Application);
        aFilters = aFilters.filter((item) => item.getPath() !== property);
        aFilters = aFilters.concat(...filters);

        oBinding.filter(aFilters, FilterType.Application);
      },

      _applyTextFilter: function (oSource, property) {
        const aFilters = [];

        const sQuery = oSource.getValue();
        if (sQuery && sQuery.length > 0) {
          aFilters.push(new Filter(property, FilterOperator.Contains, sQuery));
        }

        this._applyFilters(aFilters, property);
      },

      _applyListFilter: function (oSource, property) {
        const aFilters = [];

        const aSelectedItems = oSource.getSelectedItems();
        aSelectedItems.forEach((item) => {
          const oItem = item.getBindingContext('main').getObject();
          aFilters.push(new Filter(property, FilterOperator.EQ, oItem.ID));
        });

        this._applyFilters(aFilters, property);
      },

      _applyRangeFilter: function (oSource, property) {
        const aFilters = [];

        const [min, max] = oSource.getRange().sort((a, b) => a - b);
        if (min !== oSource.getMin() || max !== oSource.getMax()) {
          aFilters.push(new Filter(property, FilterOperator.BT, min, max));
        }

        this._applyFilters(aFilters, property);
      },

      onClearFilters: function () {
        const oFilterSearch = this.byId('idFilterSearch');
        oFilterSearch.setValue('');
        this._applyTextFilter(oFilterSearch, 'title');

        const oFilterCategory = this.byId('idFilterCategory');
        oFilterCategory.removeSelections(true);
        this._applyListFilter(oFilterCategory, 'category_ID');

        const oFilterBrand = this.byId('idFilterBrand');
        oFilterBrand.removeSelections(true);
        this._applyListFilter(oFilterBrand, 'brand_ID');

        const oFilterPrice = this.byId('idFilterPrice');
        oFilterPrice.setRange([oFilterPrice.getMin(), oFilterPrice.getMax()]);
        this._applyRangeFilter(oFilterPrice, 'price');

        const oFilterStock = this.byId('idFilterStock');
        oFilterStock.setRange([oFilterStock.getMin(), oFilterStock.getMax()]);
        this._applyRangeFilter(oFilterStock, 'stock');
      },

      onSearch: function (oEvent) {
        this._applyTextFilter(oEvent.getSource(), 'title');
      },

      onFilterCategorySelectionChange: function (oEvent) {
        this._applyListFilter(oEvent.getSource(), 'category_ID');
      },

      onFilterBrandSelectionChange: function (oEvent) {
        this._applyListFilter(oEvent.getSource(), 'brand_ID');
      },

      onFilterPriceChange: function (oEvent) {
        this._applyRangeFilter(oEvent.getSource(), 'price');
      },

      onFilterStockChange: function (oEvent) {
        this._applyRangeFilter(oEvent.getSource(), 'stock');
      },

      onAddToCart: function (oEvent) {
        const oButton = oEvent.getSource();

        const oBindingContext = oButton.getBindingContext('main');
        const oItemData = oBindingContext.getObject();

        if (!this.oCart.has(oItemData.ID)) {
          this.oCart.add(oItemData.ID, 1, oItemData.price);
        } else {
          this.oCart.drop(oItemData.ID);
        }

        this._refreshCartModel();
        this._refreshLocalDataModel();

        this._setAddToCartButtonAttributes(oItemData.ID, oButton);
      },

      onFilterPanelExpand: function (oEvent) {
        const oParameters = oEvent.getParameters();

        const oFiltersTitle = this.byId('idFiltersTitle');
        oFiltersTitle.setVisible(oParameters.expand);

        const oFiltersClearButton = this.byId('idFiltersClearButton');
        oFiltersClearButton.setVisible(oParameters.expand);
      },
    });
  }
);
