sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/brands/test/integration/FirstJourney',
		'ns/brands/test/integration/pages/BrandsList',
		'ns/brands/test/integration/pages/BrandsObjectPage'
    ],
    function(JourneyRunner, opaJourney, BrandsList, BrandsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/brands') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBrandsList: BrandsList,
					onTheBrandsObjectPage: BrandsObjectPage
                }
            },
            opaJourney.run
        );
    }
);