sap.ui.define(['./BaseController'], function (BaseController) {
  'use strict';

  return BaseController.extend('ns.shop.controller.Main', {
    onOpenCart: function () {
      this.navTo('cart');
    },
  });
});
