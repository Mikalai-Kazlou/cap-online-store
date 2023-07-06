sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/salesorders/test/integration/FirstJourney',
		'ns/salesorders/test/integration/pages/SalesOrdersList',
		'ns/salesorders/test/integration/pages/SalesOrdersObjectPage',
		'ns/salesorders/test/integration/pages/SalesOrderItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, SalesOrdersList, SalesOrdersObjectPage, SalesOrderItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/salesorders') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSalesOrdersList: SalesOrdersList,
					onTheSalesOrdersObjectPage: SalesOrdersObjectPage,
					onTheSalesOrderItemsObjectPage: SalesOrderItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);