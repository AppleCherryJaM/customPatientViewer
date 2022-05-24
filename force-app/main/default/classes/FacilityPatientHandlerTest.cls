@isTest
private class FacilityPatientHandlerTest {
    @TestSetup
    static void setup(){
        List<Facility__c> facilityList = new List<Facility__c>();
        List<Patient__c> patientList = new List<Patient__c>();

        facilityList.add(new Facility__c (
            Clinic_name__c = 'Test clinic name',
			FacilityNumber__c = '4'
        ));
        insert facilityList;

        patientList.add(
            new Patient__c (
			 			first_name__c = 'Lex',
			 			last_name__c = 'Luthor',
			 			patient_id__c = '1',
			 			facility__c = facilityList[0].id
			 		)
        );
        insert patientList;
    }

    @isTest
    static void httpPostTestSuccess() {
        List<Facility__c> facilityList = [SELECT id, Clinic_name__c, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = '4'];
        List<Patient__c> patientList = [SELECT id, first_name__c, last_name__c, patient_id__c, facility__c FROM Patient__c WHERE patient_id__c = '1'];
        
        String myRequestBodyJson = '[{"firstName" : "Jack","lastName" : "Jackson","facilityId" : "11"}]';
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(myRequestBodyJson);
        RestContext.request = request;
        Test.startTest();
        String actualResponse = FacilityPatientHandler.httpPost();
        Test.stopTest();
        System.assertEquals('Success: (Jackson)', actualResponse);
    }

    @isTest
    static void httpPostTestException() {
        List<Facility__c> facilityList = [SELECT id, Clinic_name__c, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = '4'];
        List<Patient__c> patientList = [SELECT id, first_name__c, last_name__c, patient_id__c, facility__c FROM Patient__c WHERE patient_id__c = '1'];
        
        String myRequestBodyJson = '[{"firstName" : "Jack","lastName" : "Jackson","facilityId" : ""}]';
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(myRequestBodyJson);
        RestContext.request = request;
        Test.startTest();
        String actualResponse = FacilityPatientHandler.httpPost();
        Test.stopTest();
        System.assertEquals(
            'Error: Attempt to de-reference a null object',
             actualResponse);
    }
}
