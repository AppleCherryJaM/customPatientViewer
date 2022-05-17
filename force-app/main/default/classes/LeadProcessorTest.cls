@isTest
public with sharing class LeadProcessorTest {
    @TestSetup
    static void setup(){
        List<Lead> leadList = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leadList.add(new Lead(LastName = 'Name' + i,
            Company = 'Company: ' + i,
            LeadSource = String.valueOf(i)));
        }
        insert leadList;
    }

    @isTest
    static void executeTest() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }

    
}