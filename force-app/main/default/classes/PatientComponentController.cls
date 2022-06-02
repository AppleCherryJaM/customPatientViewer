public with sharing class PatientComponentController {

    public class MyException extends Exception {}

    @AuraEnabled(cacheable=true)
    public static CustomResponse getPatientList(String currentFacility) {
        CustomResponse response;
        try {
            List<Map<String, Object>> patientMapList = new List<Map<String,Object>>();
            List<Patient__c> res = [
                SELECT Patient_Id__c, First_Name__c, Last_Name__c, Facility__c
                FROM Patient__c
                WHERE Facility__c = :currentFacility];
            if (!res.isEmpty() && res != null) {
                for (Patient__c patientObject : res) {
                    patientMapList.add(
                        new Map<String, Object> {
                            'firstName' => patientObject.First_Name__c,
                            'lastName' => patientObject.Last_Name__c
                        }
                    );
                }
            } else {
                throw new MyException('My msg');
            }

            return response = new CustomResponse(patientMapList, true);
        } catch (Exception e) {
            return response = new CustomResponse(false, e.getMessage());
        }
    }

    @AuraEnabled
    public static CustomResponse getFacilities() {
        CustomResponse response;
        try {
            List<Map<String, Object>> facilityMapList = new List<Map<String,Object>>();
            List<Facility__c> res = [
                SELECT Clinic_name__c, facilityNumber__c, id
                FROM Facility__c
            ];
            if (!res.isEmpty() && res != null) {
                for (Facility__c clinic : res) {
                    facilityMapList.add(new Map<String, Object> {
                        'label' => clinic.Clinic_name__c,
                        'value' => clinic.id
                    });
                }
            } else {
                throw new MyException('My msg');
            }
            return response = new CustomResponse(facilityMapList, true);  
        } catch (Exception e) {
            return response = new CustomResponse(false, e.getMessage());
        }
    }
}
