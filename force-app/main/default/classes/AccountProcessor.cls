public class AccountProcessor {
    @future(callout=true)
    public static void countContacts(List<Id> accountsIdList) {
        List<Account> accList = [SELECT Name, Number_Of_Contacts__c, id, (SELECT AccountId FROM Contacts) FROM Account WHERE id IN :accountsIdList];
        System.debug(accList[0].Contacts);
        List<Account> updateAccList = new List<Account>();
        //Integer numberOfRecords = 0; 

        if (!accList.isEmpty()) {
            for (Account acc : accList) {
                Integer numberOfRecords = 0;
                for (Contact con : acc.Contacts) {
                    acc.Number_Of_Contacts__c++;
                    System.debug('Number: ' + acc.Number_Of_Contacts__c);
                }
                updateAccList.add(acc);
            }
            System.debug('List: ' + updateAccList);
            update updateAccList;
        }
    }
    //     for (Id accId : accountsIdList) {
    //         for (Contact cont : contactList) {
    //             if (cont.AccountId == accId)  {
    //                 numberOfRecords++;
    //             }
    //         }
    //         Account acc = [SELECT Name, Number_Of_Contacts__c, id FROM Account WHERE id = :accId LIMIT 1];
    //         acc.Number_Of_Contacts__c = numberOfRecords;
    //         updateAccList.add(acc);
    //     }
    //     update(updateAccList);
    // }
}