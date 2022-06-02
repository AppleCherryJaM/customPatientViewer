@isTest
private with sharing class PatientComponentControllerTest {
    @TestSetup
    static void setup() {
        Facility__c facility = new Facility__c(
            Clinic_name__c = 'Test clinic',
            facilityNumber__c = '12'
        );
        insert facility;

        Facility__c patientsFacility = [SELECT Id FROM Facility__c WHERE facilityNumber__c = '12'];
        Patient__c patient = new Patient__c (
            First_Name__c = 'Test',
            Last_Name__c = 'Test',
            Facility__c = patientsFacility.id
        );
        insert patient;
    }

    @isTest
    static void getFacilitiesTestPositive() {
        List<Map<String, Object>> facilityMapList = new List<Map<String,Object>>();
        List<Facility__c> res = [
            SELECT Clinic_name__c, facilityNumber__c, id
            FROM Facility__c
        ];
        CustomResponse actual;
        for (Facility__c clinic : res) {
            facilityMapList.add(new Map<String, Object> {
                'label' => clinic.Clinic_name__c,
                'value' => clinic.id
            });
        }
        CustomResponse expected = new CustomResponse(facilityMapList, true);
        Test.startTest();
        actual = PatientComponentController.getFacilities();
        Test.stopTest();
        System.assertEquals(expected.myMessage, actual.myMessage);
    }

    @isTest
    static void getFacilitiesTestNegative() {
        CustomResponse actual;
        List<Facility__c> res = [
            SELECT Clinic_name__c, facilityNumber__c, id
            FROM Facility__c
        ];
        delete res;
        CustomResponse expected = new CustomResponse(false, 'My msg');
        Test.startTest();
        actual = PatientComponentController.getFacilities();
        Test.stopTest();
        System.assertEquals(expected.isSuccess, actual.isSuccess);
    }

    @isTest 
    static void getPatientListTestPositive() {
        CustomResponse actual;
        List<Map<String, Object>> patientMapList = new List<Map<String,Object>>();

        Facility__c fac = [
            SELECT Clinic_name__c, facilityNumber__c, id
            FROM Facility__c
            LIMIT 1
        ];
        List<Patient__c> res = [
                SELECT Patient_Id__c, First_Name__c, Last_Name__c, Facility__c
                FROM Patient__c
                WHERE Facility__c = :fac.id];
        for (Patient__c patientObject : res) {
            patientMapList.add(
                new Map<String, Object> {
                    'firstName' => patientObject.First_Name__c,
                    'lastName' => patientObject.Last_Name__c
                }
            );
        }
        CustomResponse expected = new CustomResponse(patientMapList, true);
        Test.startTest();
        actual = PatientComponentController.getPatientList(fac.id);
        Test.stopTest();
        System.assertEquals(expected.isSuccess, actual.isSuccess);
    }

    @isTest
    static void getPatientListTestNegative() {
        CustomResponse actual;
        Facility__c fac = [
            SELECT Clinic_name__c, facilityNumber__c, id
            FROM Facility__c
            LIMIT 1
        ];
        Id facId = fac.Id;
        delete fac;
        CustomResponse expected = new CustomResponse(false, 'My msg');
        Test.startTest();
        actual = PatientComponentController.getPatientList(facId);
        Test.stopTest();
        System.assertEquals(expected.isSuccess, actual.isSuccess);
    }
}
