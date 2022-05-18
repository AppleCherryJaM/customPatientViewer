@isTest
private class AccountManagerTest {
    @isTest
    static  void getAccountTest(){
        Account objAccount = new Account(Name = 'test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'test Contact',
                                         AccountId = objAccount.Id);
        insert objContact;
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://sandeepidentity-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
            + objAccount.Id +'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        String expected = objAccount.Name;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount!= null);
        System.assertEquals(expected, thisAccount.Name);
    }
}