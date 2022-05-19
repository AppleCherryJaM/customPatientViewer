@istest
public with sharing class MaintenanceRequestHelperTest {
    
    private static final string STATUS_NEW = 'New';
    private static final string WORKING = 'Working';
    private static final string CLOSED = 'Closed';
    private static final string REPAIR = 'Repair';
    private static final string REQUEST_ORIGIN = 'Web';
    private static final string REQUEST_TYPE = 'Routine Maintenance';
    private static final string REQUEST_SUBJECT = 'Testing subject';
    
    @TestSetup
    static void setup() {
        Vehicle__c vehicle = new Vehicle__C(Name = 'SuperTruck');

        Product2 equipment = new Product2(Name = 'SuperEquipment',
                                         lifespan_months__C = 10,
                                         maintenance_cycle__C = 10,
                                         replacement_part__c = true);
		insert vehicle;
        insert equipment;
        
        Case caseObj = new Case(Type = REPAIR, Status = STATUS_NEW,
                          Origin = REQUEST_ORIGIN,
                          Subject = REQUEST_SUBJECT,
                          Equipment__c = equipment.Id,
                          Vehicle__c = vehicle.Id);
        insert caseObj;

        Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(Equipment__c = equipment.Id,
                                                                            Maintenance_Request__c = caseObj.Id);
        insert wp;
    }
    
    @isTest
    private static void testMaintenanceRequestPositive(){
        Vehicle__c vehicle = [SELECT Name, Id FROM Vehicle__c WHERE Name = 'SuperTruck'];
        Id vehicleId = vehicle.Id;
        
        Product2 equipment = [
            SELECT Id,
             Name, lifespan_months__c,
              maintenance_cycle__c,
               replacement_part__c
                FROM Product2 WHERE Name = 'SuperEquipment'];
        Id equipmentId = equipment.Id;
        
        Case somethingToUpdate = [SELECT Id, Type, Status, Origin, Subject, Equipment__c, Vehicle__c
             FROM Case WHERE Equipment__c = :equipmentId AND Vehicle__c = :vehicleId];
        
        Equipment_Maintenance_Item__c workP = [SELECT id, Equipment__c, Maintenance_Request__c 
            FROM Equipment_Maintenance_Item__c WHERE Equipment__c = :equipmentId AND Maintenance_Request__c = :somethingToUpdate.id];
            
        Test.startTest();
        somethingToUpdate.status = CLOSED;
        update somethingToUpdate;
        Test.stopTest();
        
        Case newReq = [Select id, subject, type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c
                      from case
                      where status =:STATUS_NEW];
        
        Equipment_Maintenance_Item__c workPart = [select id
                                                 from Equipment_Maintenance_Item__c
                                                 where Maintenance_Request__c =:newReq.Id];
        
        System.assert(workPart != null);
        System.assert(newReq.Subject != null);
        System.assertEquals(newReq.Type, REQUEST_TYPE);
        System.assertEquals(newReq.Equipment__c, equipmentId);
        System.assertEquals(newReq.Vehicle__c, vehicleId);
        System.assertEquals(newReq.Date_Reported__c, system.today());
    }
    
    @isTest
    private static void testMaintenanceRequestNegative(){
        Vehicle__C vehicle = [SELECT Name, Id FROM Vehicle__c WHERE Name = 'SuperTruck'];
        Id vehicleId = vehicle.Id;
        
        Product2 equipment = [
            SELECT Id,
             Name, lifespan_months__c,
              maintenance_cycle__c,
               replacement_part__c
                FROM Product2 WHERE Name = 'SuperEquipment'];
        Id equipmentId = equipment.Id;
        
        Case emptyReq = [SELECT Id, Type, Status, Origin, Subject, Equipment__c, Vehicle__c
             FROM Case WHERE Equipment__c = :equipmentId AND Vehicle__c = :vehicleId];
        
        Equipment_Maintenance_Item__c workP = [SELECT id, Equipment__c, Maintenance_Request__c 
            FROM Equipment_Maintenance_Item__c WHERE Equipment__c = :equipmentId AND Maintenance_Request__c = :emptyReq.id];
        
        Test.startTest();
        emptyReq.Status = WORKING;
        update emptyReq;
        Test.stopTest();
        
        List<Case> allRequest = [SELECT id 
                                 FROM Case];
        
        Equipment_Maintenance_Item__c workPart = [SELECT id 
                                                  FROM Equipment_Maintenance_Item__c 
                                                  WHERE Maintenance_Request__c = :emptyReq.Id];
        
        System.assert(workPart != null);
        System.assert(allRequest.size() == 1);
    }
    
    @isTest
    private static void testMaintenanceRequestBulk(){
        List<Vehicle__C> vehicleList = new List<Vehicle__C>();
        List<Product2> equipmentList = new List<Product2>();
        List<Equipment_Maintenance_Item__c> workPartList = new List<Equipment_Maintenance_Item__c>();
        List<case> requestList = new List<Case>();
        List<id> oldRequestIds = new List<Id>();
        
        for(integer i = 0; i < 5; i++){
           vehicleList.add(new Vehicle__C (Name = 'SuperTruck'));
            equipmentList.add(new Product2 (Name = 'SuperEquipment',
                                         lifespan_months__C = 10,
                                         maintenance_cycle__C = 10,
                                         replacement_part__c = true));
        }
        insert vehicleList;
        insert equipmentList;
        
        for(Integer i = 0; i < 5; i++){
            requestList.add(new Case(Type = REPAIR, Status = STATUS_NEW,
                          Origin = REQUEST_ORIGIN,
                          Subject = REQUEST_SUBJECT,
                          Equipment__c = equipmentList.get(i).Id,
                          Vehicle__c = vehicleList.get(i).Id));
        }
        insert requestList;
        
        for(Integer i = 0; i < 5; i++){
            workPartList.add(new Equipment_Maintenance_Item__c(Equipment__c = equipmentList.get(i).Id,
                                                                            Maintenance_Request__c = requestList.get(i).Id));
        }
        insert workPartList;
        
        Test.startTest();
        for(Case req : requestList){
            req.Status = CLOSED;
            oldRequestIds.add(req.Id);
        }
        update requestList;
        Test.stopTest();
        
        List<Case> allRequests = [SELECT id
                                 FROM case
                                 WHERE status =: STATUS_NEW];
        
        List<Equipment_Maintenance_Item__c> workParts = [SELECT id
                                                        FROM Equipment_Maintenance_Item__c
                                                        WHERE Maintenance_Request__c in: oldRequestIds];
        
        System.assert(allRequests.size() == 6);
    }
}