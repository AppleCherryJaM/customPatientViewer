public with sharing class LeadProcessor implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> fields = new List<String>(Lead.SObjectType.getDescribe().fields.getMap().keySet());
        String query = 'SELECT ' + String.join(fields, ',')
        + ' FROM Lead';
        return Database.getQueryLocator(query);
    }

    public void execute (Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadList = new List<Lead>();
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            leadList.add(l);
        }
        update(leadList);
    }

    public void finish(Database.BatchableContext bc) {}
}