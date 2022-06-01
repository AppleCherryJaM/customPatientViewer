public with sharing class PatientComponentController {
    
    public class PatientParserSecond {
        String firstNmae;
        String lastName;
        String patientId;
        Id patientsFacility;

        public PatientParserSecond (String fname, String lname, String pId, Id pFacility) {
            this.firstNmae = fname;
            this.lastName = lname;
            this.patientId = pId;
            this.patientsFacility = pFacility;
        }
    }

    public class FacilityParser {
        String facilityNumber;
        String clinicName;

        public FacilityParser (String fnumber, String fname) {
            this.facilityNumber = fnumber;
            this.clinicName = fname;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getPatientList(String currentFacility) {
        List<PatientParserSecond> patients = getParsedPatientsList(currentFacility);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for (PatientParserSecond patientObj : patients) {
            gen.writeObject(patientObj);
        }
        gen.writeEndArray();

        return gen.getAsString();
    }

    private static List<PatientParserSecond> getParsedPatientsList(String currentFacility) {
        List<Patient__c> res = [
            SELECT Patient_Id__c, First_Name__c, Last_Name__c
            FROM Patient__c
            WHERE Facility__c = :currentFacility];
        List<PatientParserSecond> patients = new List<PatientParserSecond>();
        for (Patient__c p : res) {
            patients.add(new PatientParserSecond(p.Patient_Id__c, p.First_Name__c, p.Last_Name__c, p.Facility__c));
        }
        System.debug();
        return patients;
    }

    @AuraEnabled(cacheable=true)
    public static string getFacilities() {
        List<FacilityParser> facilities = getParsedFacilityList();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for (FacilityParser f : facilities) {
            gen.writeObject(f);
        }
        gen.writeEndArray();

        return gen.getAsString();
    }

    private static List<FacilityParser> getParsedFacilityList() {
        List<Facility__c> res = [
            SELECT Clinic_name__c, facilityNumber__c
            FROM Facility__c
        ];
        List<FacilityParser> facilities = new List<FacilityParser>();
        for (Facility__c f : res) {
            facilities.add(new FacilityParser (
                f.facilityNumber__c,
                f.Clinic_name__c
            ));
        }
        return facilities;
    }
    // @AuraEnabled
    // public static String checkForAnimal(String request) {
    //     Animal__c animalViaRequest = [SELECT id__c, Name, food__c, says__c FROM Animal__c WHERE id__c = :request];
    //     if (animalViaRequest != null) {
    //         return JSON.serialize(new AnimalParserSecond(animalViaRequest.id__c, animalViaRequest.name, animalViaRequest.food__c, animalViaRequest.says__c));
    //     } return null;
    // }
}
