@isTest
public class AddPrimaryContactTest {

    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account( 
                name = 'acc' + i, 
                BillingState = 'UA'
                )); 
        }
        for (Integer i = 50; i < 100; i++) {
            accounts.add(new Account(
                name = 'acc' + i, 
                BillingState = 'CA'
                )); 
            }
        insert accounts;
    }


    @isTest static void testQueueable(){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 99; i++) {
            Account acc = [SELECT Name, BillingState, id FROM Account WHERE name = :String.valueOf('acc'+i)];
            accounts.add(acc);
        }
      	String state = 'CA';
        Contact cont = new Contact(LastName = 'demoTest');
        AddPrimaryContact addCont = new AddPrimaryContact(cont, state);

        Test.startTest();
        System.enqueueJob(addCont);
        Test.stopTest();

        System.assertEquals(50, [select count() from Contact where accountID IN (SELECT id FROM Account WHERE BillingState = :state)]);   

    }
}