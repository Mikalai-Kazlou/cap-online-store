sap.ui.define(['ns/shop/controller/BaseController'], function (BaseController) {
  'use strict';

  return BaseController.extend('ns.shop.controller.Main', {
    onOpenCart: function () {
      this.navTo('cart');
    },
  });
});
