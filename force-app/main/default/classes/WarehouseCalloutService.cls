public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    private static final String REPLACEMENT = 'replacement';
    private static final String NAME = 'name';
    private static final String MAINTENANCEPERIOD = 'maintenanceperiod';
	private static final String LIFESPAN = 'lifespan';
    private static final String COST = 'cost';
	private static final String SKU = 'sku';
    private static final String QUANTITY = 'quantity';
    private static final String OBJID = '_id';
    
    
	@future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        List<Product2> warehouseEq = new List<Product2>();
        
        if (response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(response.getBody());
            
            //class maps the following fields: replacement part (always true), cost, current inventory, lifespan, maintenance cycle, and warehouse SKU
            //warehouse SKU will be external ID for identifying which equipment records to update within Salesforce
            for (Object jsonObj : jsonResponse){
                Map<String,Object> mapJson = (Map<String,Object>)jsonObj;
                Product2 myEq = new Product2();
                myEq.Replacement_Part__c = (Boolean) mapJson.get(REPLACEMENT);
                myEq.Name = (String) mapJson.get(NAME);
                myEq.Maintenance_Cycle__c = (Integer) mapJson.get(MAINTENANCEPERIOD);
                myEq.Lifespan_Months__c = (Integer) mapJson.get(LIFESPAN);
                myEq.Cost__c = (Integer) mapJson.get(COST);
                myEq.Warehouse_SKU__c = (String) mapJson.get(SKU);
                myEq.Current_Inventory__c = (Double) mapJson.get(QUANTITY);
                myEq.ProductCode = (String) mapJson.get(OBJID);
                warehouseEq.add(myEq);
            }
            
            if (warehouseEq.size() > 0){
                upsert warehouseEq;
                System.debug('Your equipment was synced with the warehouse one');
            }
        }
    }
}