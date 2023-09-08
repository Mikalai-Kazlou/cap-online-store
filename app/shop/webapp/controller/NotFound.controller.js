sap.ui.define(['ns/shop/controller/BaseController'], function (BaseController) {
  'use strict';

  return BaseController.extend('ns.shop.controller.NotFound', {
    /**
     * Navigates to the worklist when the link is pressed
     * @public
     */
    onLinkPressed: function () {
      this.getRouter().navTo('main');
    },
  });
});
