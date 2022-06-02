public with sharing class PatientComponentController {

    public CustomResponse myResponse;
    //Classes for parse from sObject to buffer Class
    public class PatientParserSecond {
        String firstName;
        String lastName;
        String patientId;
        Id patientsFacility;

        public PatientParserSecond (String pId, String fname, String lname, Id pFacility) {
            this.firstName = fname;
            this.lastName = lname;
            this.patientId = pId;
            this.patientsFacility = pFacility;
        }
    }
    

    @AuraEnabled(cacheable=true)
    public static String getPatientList(String currentFacility) {
        try {
            List<Map<String, Object>> patientMapList = new List<Map<String,Object>>();
            List<Patient__c> res = [
                SELECT Patient_Id__c, First_Name__c, Last_Name__c, Facility__c
                FROM Patient__c
                WHERE Facility__c = :currentFacility];
            for (Patient__c patientObject : res) {
                patientMapList.add(
                    new Map<String, Object> {
                        'firstName' => patientObject.First_Name__c,
                        'lastName' => patientObject.Last_Name__c
                    }
                );
            }

            return JSON.serialize(patientMapList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getFacilities() {
        try {
            List<Map<String, Object>> facilityMapList = new List<Map<String,Object>>();
            List<Facility__c> res = [
                SELECT Clinic_name__c, facilityNumber__c, id
                FROM Facility__c
            ];
            for (Facility__c clinic : res) {
                facilityMapList.add(new Map<String, Object> {
                    'label' => clinic.Clinic_name__c,
                    'value' => clinic.id
                });
            }
            return JSON.serialize(facilityMapList);   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
