sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/products/test/integration/FirstJourney',
		'ns/products/test/integration/pages/ProductsList',
		'ns/products/test/integration/pages/ProductsObjectPage',
		'ns/products/test/integration/pages/ProductImagesObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ProductImagesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/products') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheProductImagesObjectPage: ProductImagesObjectPage
                }
            },
            opaJourney.run
        );
    }
);