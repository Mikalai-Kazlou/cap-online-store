sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ns.brands',
            componentId: 'BrandsList',
            entitySet: 'Brands'
        },
        CustomPageDefinitions
    );
});