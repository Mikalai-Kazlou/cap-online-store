sap.ui.define(['ns/shop/controller/BaseController'], function (BaseController) {
  'use strict';

  return BaseController.extend('ns.shop.controller.App', {
    onInit: function () {
      // apply content density mode to root view
      this.getView().addStyleClass(this.getOwnerComponent().getContentDensityClass());
    },
  });
});
