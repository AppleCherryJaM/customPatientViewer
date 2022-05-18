@isTest
private class AccountManagerTest {
    // @TestSetup
    // static void setup() {
    //     Account acc = new Account(Name = 'demoRestTest');
    //     insert acc;
    //     Contact cont = new Contact(
    //         LastName = 'demoRestTest', 
    //         AccountId = acc.Id
    //     );
    //     insert cont;
    // }

    // @isTest
    // static void getAccountTest(){
    //     Account acc = [SELECT id, Name, (SELECT id, Name FROM Contacts) FROM Account WHERE Name = 'demoRestTest'];
    //     Contact con = acc.Contacts[0];
    //     Id recordId = con.id;
    //     RestRequest request = new RestRequest();
    //     request.requestURI = 'https://varenyo-developer-edition.eu44.force.com/services/apexrest/Accounts/' + recordId + '/contacts';
    //     request.httpMethod = 'GET';
    //     RestContext.request = request;
    //     System.assert(acc!=null);
    //     Account result = AccountManager.getAccount();
    //     System.assertEquals('demoRestTest', result.Name);
    // }
    @isTest
    static  void getAccountTest(){
        Account objAccount = new Account(Name = 'test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'test Contact',
                                         AccountId = objAccount.Id);
        insert objContact;
        Id recordId = objAccount.Id;
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://sandeepidentity-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
            + recordId +'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount!= null);
        System.assertEquals('test Account', thisAccount.Name);
    }
}