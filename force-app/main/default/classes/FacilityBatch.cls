public with sharing class FacilityBatch implements Database.Batchable<sObject>, Database.Stateful {
    public FacilityBatch() {

    }

    public class MyException extends Exception {}

    public Set<Id> patientList = new Set<Id>();
    public Id newFacilityId;
    public Boolean throwable = false;
    public String exceptionMsg;

    public FacilityBatch(Set<Id> pl) {
        patientList = pl;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            Facility__c facId = [SELECT id FROM Facility__c LIMIT 1];
            if (facId == null) {
                throw new MyException ('My Exception');
            }
            newFacilityId = facId.id;
        } catch (Exception e) {
            exceptionMsg = 'Exception: ' + e.getMessage();
            MyLog__c ml = new MyLog__c();
            ml.body__c = exceptionMsg;
            insert ml;
        }

        String query = 'SELECT id, first_name__c, last_name__c, Patient_id__c, facility__c FROM Patient__c WHERE id IN :patientList';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Patient__c> scope) {
        List<Id> idList = new List<Id>();
        for (Patient__c p : scope) {
            idList.add(p.id);
        }
        try {
            List<Patient__c> updatedPatientList = new List<Patient__c>();
            for (Patient__c p : scope) {
                p.facility__c = newFacilityId;
                updatedPatientList.add(p);
            }
        update updatedPatientList;   
        } catch (Exception e) {
            exceptionMsg = 'Scope id: ' + idList + '\n Exception: ' + e.getMessage() + '\n StackTrace: ' + e.getStackTraceString();
            System.debug(exceptionMsg);
        } 
    }

    public void finish (Database.BatchableContext bc) {
        System.debug('Batch is complete!');
    }
}