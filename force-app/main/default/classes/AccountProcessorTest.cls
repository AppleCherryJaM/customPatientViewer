@isTest
public with sharing class AccountProcessorTest {
    @TestSetup
    static void setup(){
        Account acc = new Account();
        acc.name = 'Acc 1';
        insert acc;
        Contact con = new Contact();
        con.Lastname = 'Con 1';
        con.AccountId = acc.Id;
        insert con;
    } 
    @isTest public static void countContactsTest() {
        List<Id> testAccList = new List<Id>();
        Account acc = [SELECT Id, Number_Of_Contacts__c FROM Account WHERE Name = 'Acc 1'];
        Contact con = [Select id, LastName FROM Contact WHERE AccountId =: acc.id];
        Integer expectedResultNumber = 1;
        Test.startTest();
        testAccList.add(acc.id);
        AccountProcessor.countContacts(testAccList);
        Test.stopTest();
        acc = [SELECT Id, Number_Of_Contacts__c FROM Account WHERE Name = 'Acc 1'];
        System.assertEquals(expectedResultNumber, acc.Number_Of_Contacts__c); 
    }
}