sap.ui.define(
  [
    'sap/ui/core/mvc/Controller',
    'sap/ui/core/UIComponent',
    'sap/ui/core/routing/History',
    '../model/Cart',
    '../model/constants',
  ],
  function (Controller, UIComponent, History, Cart, constants) {
    'use strict';

    return Controller.extend('ns.shop.controller.BaseController', {
      oCart: new Cart(),

      getOwnerComponent: function () {
        return Controller.prototype.getOwnerComponent.call(this);
      },

      /**
       * Convenience method for accessing the router.
       * @public
       * @returns {sap.ui.core.routing.Router} the router for this component
       */
      getRouter: function () {
        return UIComponent.getRouterFor(this);
      },

      /**
       * Convenience method for getting the view model by name.
       * @public
       * @param {string} [sName] the model name
       * @returns {sap.ui.model.Model} the model instance
       */
      getModel: function (sName) {
        return this.getView().getModel(sName);
      },

      /**
       * Convenience method for setting the view model.
       * @public
       * @param {sap.ui.model.Model} oModel the model instance
       * @param {string} sName the model name
       * @returns {sap.ui.mvc.View} the view instance
       */
      setModel: function (oModel, sName) {
        return this.getView().setModel(oModel, sName);
      },

      /**
       * Getter for the resource bundle.
       * @public
       * @returns {sap.ui.model.resource.ResourceModel} the resourceModel of the component
       */
      getResourceBundle: function () {
        return this.getOwnerComponent().getModel('i18n').getResourceBundle();
      },

      navTo: function (sName, oParameters, bReplace) {
        this.getRouter().navTo(sName, oParameters, undefined, bReplace);
      },

      onNavBack: function () {
        const sPreviousHash = History.getInstance().getPreviousHash();
        if (sPreviousHash !== undefined) {
          window.history.go(-1);
        } else {
          this.getRouter().navTo('main', {}, undefined, true);
        }
      },

      onQuantityStepInputChange: function (oEvent) {
        const oStepInput = oEvent.getSource();

        const oBindingContext = oStepInput.getBindingContext('main');
        const oItemData = oBindingContext.getObject();

        this.oCart.replace(oItemData.ID, oStepInput.getValue(), oItemData.price);

        this._refreshCartModel();
        this._refreshLocalDataModel();
      },

      _refreshLocalDataModel() {
        const oLocalDataModel = this.getModel('localdata');
        oLocalDataModel.setProperty('/cart', this.oCart.get());
        localStorage.setItem(constants.localStorageDataID, oLocalDataModel.getJSON());
      },

      _refreshCartModel() {
        const oCartModel = this.getModel('cart');
        oCartModel.setProperty('/totalQuantity', this.oCart.getTotalQuantity());
        oCartModel.setProperty('/totalAmount', this.oCart.getTotalAmount());
      },
    });
  }
);
