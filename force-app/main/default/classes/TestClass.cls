public class TestClass {
    
    public static void onInsert(Account acc) {
        System.debug('Insert operation');
        acc.Test_Data__c = System.now();
    } 
    
    public static void onUpdate(Account acc) {
        System.debug('Update operation');
        acc.Test_Data__c = System.now();
    }
}