public with sharing class AddPrimaryContact implements Queueable {
    List<Account> accounts;
    Contact contactObj;
    String state;

    public AddPrimaryContact(Contact obj, String state) {
        this.contactObj = obj;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        accounts = [SELECT id, Name, (SELECT id, firstName, lastName from contacts) FROM Account WHERE BillingState =:state LIMIT 200];
        List<Contact> contactList = new List<Contact>();
        for (Account acc: accounts) {
            Contact cont = contactObj.clone(false, false,false, false);
            cont.AccountId = acc.id;
            contactList.add(cont);
        }
        insert contactList;
    }
}