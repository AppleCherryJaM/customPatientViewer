@RestResource(urlMapping='/Accounts/*/contacts/')
global without sharing class AccountManager {
    
    @HttpGet
    global static Account getAccount() {
        RestRequest req = RestContext.request;
        String accId = req.requestURI.substringBetween('Accounts/','/contacts');
        Account acc = [SELECT Id, Name, (SELECT Id, NAME FROM Contacts) FROM Account WHERE Id = :accId LIMIT 1];
        return acc;
    }
}
