public with sharing class FacilityBatch implements Database.Batchable<sObject>, Database.Stateful {
    public FacilityBatch() {

    }
    public Set<Id> patientList = new Set<Id>();
    public Id newFacilityId;
    public Boolean throwable = false;

    public FacilityBatch(Set<Id> pl) {
        patientList = pl;
    }

    public FacilityBatch(Set<Id> pl, Boolean th) {
        patientList = pl;
        throwable = th;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Facility__c facId = [SELECT id FROM Facility__c LIMIT 1];
        newFacilityId = facId.id;
        String query = 'SELECT id, first_name__c, last_name__c, Patient_id__c, facility__c FROM Patient__c WHERE id IN :patientList';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Patient__c> scope) {
        List<Id> idList = new List<Id>();
        for (Patient__c p : scope) {
            idList.add(p.id);
        }
        try {
            if (throwable) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception!');
                throw e;
            }
            List<Patient__c> updatedPatientList = new List<Patient__c>();
            for (Patient__c p : scope) {
                p.facility__c = newFacilityId;
                updatedPatientList.add(p);
            }
        update updatedPatientList;   
        } catch (Exception e) {
            MyLog__c l = new MyLog__c(body__c = 'Scope id: ' + idList + '\n Exception: ' + e.getMessage() + '\n StackTrace: ' + e.getStackTraceString());
            insert l;
            System.debug(l);
        }
    }

    public void finish (Database.BatchableContext bc) {
        System.debug('Batch is complete!');
    }
}