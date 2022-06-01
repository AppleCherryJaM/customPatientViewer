public with sharing class PatientComponentController {

    //Classes for parse from sObject to buffer Class
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
        System.debug('Facilities: ' + facilities);
        JSONGenerator gen = JSON.createGenerator(true);
        // gen.writeStartArray();
        // for (FacilityParser f : facilities) {
        //     gen.writeObject(f);
        // }
        // gen.writeEndArray();

        // return facilities;
        System.debug('Huita: ' + JSON.serialize(facilities));
        return JSON.serialize(facilities);
    }

    //Method for Map-object return
    // @AuraEnabled(cacheable=true)
    // public static Map<String, PatientParserSecond[]> getFacilityPatientData(){
    //     try {
    //         List<FacilityParser> facilities = getParsedFacilityList();
    //         List<PatientParserSecond> patients = getPatientsList();
    //         List<PatientParserSecond> patientsByFacility = new List<PatientParserSecond>();
    //         Map<String, PatientParserSecond[]> dataMap = new Map<String, PatientParserSecond[]>();
    //         for (FacilityParser f : facilities) {
    //             for (PatientParserSecond p : patients) {
    //                 System.debug('Patient fac: ' + (p.patientsFacility == f.facId));
    //                 if (p.patientsFacility == f.facId) {
    //                     patientsByFacility.add(p);
    //                 }
    //             }
    //             dataMap.put(f.facilityNumber, patientsByFacility);
    //             patientsByFacility.clear();
    //         }
    //         return dataMap;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

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
