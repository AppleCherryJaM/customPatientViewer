public with sharing class PatientComponentController {

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

    public class FacilityParser {
        Id value;
        String label;

        public FacilityParser (Id fId, String fname) {
            this.label = fname;
            this.value = fId;
        }
    }
    

    @AuraEnabled(cacheable=true)
    public static String getPatientList(String currentFacility) {
        List<PatientParserSecond> patients = getParsedPatientsList(currentFacility);
        System.debug('Patients: ' + patients);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for (PatientParserSecond patientObj : patients) {
            gen.writeObject(patientObj);
        }
        gen.writeEndArray();

        return gen.getAsString();
    }

    @AuraEnabled
    public static String getFacilities() {
        List<FacilityParser> facilities = getParsedFacilityList();
        JSONGenerator gen = JSON.createGenerator(true);
        return JSON.serialize(facilities);
    }

    private static List<PatientParserSecond> getParsedPatientsList(String currentFacility) {
            List<Patient__c> res = [
                SELECT Patient_Id__c, First_Name__c, Last_Name__c, Facility__c
                FROM Patient__c
                WHERE Facility__c = :currentFacility];
            List<PatientParserSecond> patients = new List<PatientParserSecond>();
            for (Patient__c p : res) {
                patients.add(new PatientParserSecond(p.Patient_Id__c, p.First_Name__c, p.Last_Name__c, p.Facility__c));
            }
            return patients;
    }

    private static List<PatientParserSecond> getPatientsList() {
            List<Patient__c> res = [
                SELECT Patient_Id__c, First_Name__c, Last_Name__c, Facility__c
                FROM Patient__c
            ];
            List<PatientParserSecond> patients = new List<PatientParserSecond>();
            for (Patient__c p : res) {
                patients.add(new PatientParserSecond(p.Patient_Id__c, p.First_Name__c, p.Last_Name__c, p.Facility__c));
            }
            return patients;
    }

    private static List<FacilityParser> getParsedFacilityList() {
        List<Facility__c> res = [
            SELECT Clinic_name__c, facilityNumber__c, id
            FROM Facility__c
        ];
        List<FacilityParser> facilities = new List<FacilityParser>();
        for (Facility__c f : res) {
            facilities.add(new FacilityParser (
                f.id,
                f.Clinic_name__c
            ));
        }
        return facilities;
    }
}
