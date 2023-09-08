sap.ui.define(
  ['ns/shop/controller/BaseController', 'sap/m/ButtonType', 'ns/shop/model/constants'],
  function (BaseController, ButtonType, constants) {
    'use strict';

    return BaseController.extend('ns.shop.controller.Details', {
      onInit: function () {
        const oRouter = this.getRouter();
        oRouter.getRoute('details').attachPatternMatched(this._onPatternMatched, this);
      },

      onOpenCart: function () {
        this.navTo('cart', {}, true);
      },

      _onPatternMatched: function (oEvent) {
        const sProductID = oEvent.getParameter('arguments').id;
        const oView = this.getView();

        oView.bindElement({
          path: `/Products(ID=${sProductID},IsActiveEntity=true)`,
          model: 'main',
          events: {
            change: this._onBindingChange.bind(this),
            dataRequested: function () {
              oView.setBusy(true);
            },
            dataReceived: function () {
              oView.setBusy(false);
            },
          },
        });

        const oAddToCartButton = this.byId('idAddToCartButton');
        this._setAddToCartButtonAttributes(sProductID, oAddToCartButton);

        const oQuantityStepInput = this.byId('idQuantityStepInput');
        this._setQuantityStepInputAttributes(sProductID, oQuantityStepInput);
      },

      _onBindingChange: function () {
        const oElementBinding = this.getView().getElementBinding();

        // No data for the binding
        if (oElementBinding && !oElementBinding.getBoundContext()) {
          this.getRouter().getTargets().display('notFound');
        }
      },

      onAddToCart: function (oEvent) {
        const oButton = oEvent.getSource();

        const oBindingContext = oButton.getBindingContext('main');
        const oItemData = oBindingContext.getObject();

        const oStepInput = this.byId('idQuantityStepInput');

        if (!this.oCart.has(oItemData.ID)) {
          this.oCart.add(oItemData.ID, oStepInput.getValue(), oItemData.price);
        } else {
          this.oCart.drop(oItemData.ID);
        }

        this._refreshCartModel();
        this._refreshLocalDataModel();

        this._setAddToCartButtonAttributes(oItemData.ID, oButton);
      },

      onBuyNow: function (oEvent) {
        const oButton = oEvent.getSource();

        const oBindingContext = oButton.getBindingContext('main');
        const oItemData = oBindingContext.getObject();

        const oStepInput = this.byId('idQuantityStepInput');

        if (!this.oCart.has(oItemData.ID)) {
          this.oCart.add(oItemData.ID, oStepInput.getValue(), oItemData.price);
        }

        this._refreshCartModel();
        this._refreshLocalDataModel();

        const oParameters = {
          '?query': {
            action: constants.actions.buyNow,
          },
        };

        this.navTo('cart', oParameters, true);
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

      _setQuantityStepInputAttributes: function (id, oStepInput) {
        const oCartItem = this.oCart.has(id);

        if (oCartItem) {
          oStepInput.setValue(oCartItem.q);
        } else {
          oStepInput.setValue(1);
        }
      },
    });
  }
);
