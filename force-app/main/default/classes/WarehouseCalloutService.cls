public with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    private static final String replacement = 'replacement';
    private static final String name = 'name';
    private static final String maintenanceperiod = 'maintenanceperiod';
	private static final String lifespan = 'lifespan';
    private static final String cost = 'cost';
	private static final String sku = 'sku';
    private static final String quantity = 'quantity';
    private static final String objId = '_id';
    
    
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
                myEq.Replacement_Part__c = (Boolean) mapJson.get(replacement);
                myEq.Name = (String) mapJson.get(name);
                myEq.Maintenance_Cycle__c = (Integer) mapJson.get(maintenanceperiod);
                myEq.Lifespan_Months__c = (Integer) mapJson.get(lifespan);
                myEq.Cost__c = (Integer) mapJson.get(cost);
                myEq.Warehouse_SKU__c = (String) mapJson.get(sku);
                myEq.Current_Inventory__c = (Double) mapJson.get(quantity);
                myEq.ProductCode = (String) mapJson.get(objId);
                warehouseEq.add(myEq);
            }
            
            if (warehouseEq.size() > 0){
                upsert warehouseEq;
                System.debug('Your equipment was synced with the warehouse one');
            }
        }
    }
    
    public static void execute(QueueableContext context) {
        runWarehouseEquipmentSync();
    }
}