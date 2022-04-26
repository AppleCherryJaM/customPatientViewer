@isTest
private class ChildObjTriggerHandlerTest {
    @testSetup static void setup() {
        List<Parent_Obj__c> testParentList = new List<Parent_Obj__c>();
        List<Child_Obj__c> testChildList = new List<Child_Obj__c>();
        for (Integer i = 0; i < 2; i++) {
            testParentList.add(new Parent_Obj__c (Name = 'Parent' + i));
        }
        for (Integer i = 0; i < 2; i++) {
            testChildList.add(new Child_Obj__c (Name = 'Child' + i));
        }
        insert testParentList;
        insert testChildList;
    }
    
    /* @isTest static void testMethod1() {
        Parent_Obj__c parent = [SELECT id FROM Parent_Obj__c Where Name ='Parent0' LIMIT 1];
        parent.Name = 'Babaji';
        update parent;
    }
   
    */
    @isTest static void parentUpdateTest() {
        Child_Obj__c testChild = [SELECT Id,Name, LastModifiedDate FROM Child_Obj__c WHERE Name = 'Parent0' LIMIT 1];
        testChild.Name = 'Child0';
        Datetime updatedTime = testChild.LastModifiedDate;
        update testChild;
        
        Parent_Obj__c testParent = [SELECT Id, Name, time_of_change__c FROM Parent_Obj__c WHERE Name = 'Parent0' LIMIT 1];
        System.equals(updatedTime, testParent.time_of_change__c);
    }
    
    //     @isTest static void parentUpdateTestNon() {
    //     Child_Obj__c testChild = [SELECT Id,Name, LastModifiedDate FROM Child_Obj__c WHERE Name = 'Parent0' LIMIT 1];
    //     testChild.Name = 'Child0';
    //     Datetime updatedTime = System.now();
    //     update testChild;
        
    //     Parent_Obj__c testParent = [SELECT Id, Name, time_of_change__c FROM Parent_Obj__c WHERE Name = 'Parent0' LIMIT 1];
    //     System.assertNotEquals(updatedTime, testParent.time_of_change__c);
    // }
    
    @isTest static void changeChildrenNumberForInsertTest () {
        Parent_Obj__c parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent1'];
        Child_Obj__c newChild = new Child_Obj__c (Name = 'Test_Child', Parent__c = parent.id);
        insert newChild;
        parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent1'];
        Integer childCap = 2;
        System.assertEquals(childCap, parent.Child_number__c);
    }

    @isTest static void changeChildrenNumberForDeleteTest() {
        Parent_Obj__c parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent0'];
        Child_Obj__c child = [SELECT Id From Child_Obj__c WHERE Name = 'Parent0'];
        System.assertEquals(1, parent.Child_number__c);
        delete child;
        parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent0'];
        System.assertEquals(0, parent.Child_number__c);
    }

    @isTest static void updateParentTest () {
        Parent_Obj__c parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent1'];
        Parent_Obj__c parent1 = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent0'];
        // Child_Obj__c child1 = [SELECT Id, Parent__c From Child_Obj__c WHERE Name = 'Parent1'];
        Child_Obj__c childWithoutParent = [SELECT id, Parent__c FROM Child_Obj__c Where Name = 'Child1'];

        childWithoutParent.Parent__c = parent.id;
        update(childWithoutParent);
        parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent1'];
        System.assertEquals(2, parent.Child_number__c);

        childWithoutParent.Parent__c = parent1.id;
        update(childWithoutParent);
        parent = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent1'];
        parent1 = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent0'];
        
        //checking for updates of  first parent
        System.assertEquals(1, parent.Child_number__c);
        //checking for updates of second parent
        System.assertEquals(2, parent1.Child_number__c);

        childWithoutParent.Parent__c = null;
        update(childWithoutParent);
        parent1 = [SELECT id, Child_number__c FROM Parent_Obj__c WHERE Name = 'Parent0'];
        System.assertEquals(1, parent1.Child_number__c);
    }

}