@RestResource(urlMapping='/patients/*')
global with sharing class FacilityPatientHandler {
	private final static String ENDPOINT = '';
	
	public static List<Patient> patientList;

  global class Patient {
      public String firstName;
      public String lastName;
      public String patientId;
			public String facilityId; 
  }

	private static String stringGenerator() {
		Integer randomNumber = Integer.valueOf((Math.random() * 100));
		List<String> alphabet = new List<String>{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
		String generatedFacilityNumber;

		for (Integer i = 0; i < alphabet.size(); i++) {
			generatedFacilityNumber += alphabet[Integer.valueOf((Math.random() * (alphabet.size() - 1)))];
		}
		return generatedFacilityNumber + ' ' + Integer.valueOf((Math.random() * 100));
	}

	private static void insertFacility(List<Patient> patientList, List<Facility__c> facilityList) {
		Map<String, Facility__c> facilityMap = new Map<String, Facility__c>();
		List<Facility__c> insertedFacilityList = new List<Facility__c>(); 

		for (Facility__c f : facilityList) {
				facilityMap.put(f.FacilityNumber__c, f);
		}

		for (Patient p : patientList) {
			if (facilityMap.isEmpty() || !facilityMap.containsKey(p.facilityId)) {
				Facility__c f = new Facility__c (
		 			Clinic_name__c = 'Some clinic name',
					FacilityNumber__c = p.facilityId
				);
				insertedFacilityList.add(f);
			}

		}
		insert insertedFacilityList;
	}

	@HttpPost
	global static void httpPost() {
		String restRequestBody;
		try {
			RestRequest restRequest = RestContext.request;
			restRequestBody = restRequest.requestBody.toString().trim();
			patientList = restRequestBody != null ? (List<Patient>) JSON.deserialize(restRequestBody, List<Patient>.class): new List<Patient>();

			List<Patient__c> insertedPatientList = new List<Patient__c>();
			Map<String, Facility__c> facilityMap = new Map<String, Facility__c>();

			//create and add into idList values
			List<String> idList = new List<String>();
			for (Patient p : patientList) {
				idList.add(p.facilityId);
			}

			insertFacility(patientList, [SELECT id, name, Clinic_name__c, FacilityNumber__c FROM Facility__c]);
			List<Facility__c> facilityListById = [SELECT id, name, Clinic_name__c, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = :idList];
			for (Facility__c f: facilityListById) {
				facilityMap.put(f.FacilityNumber__c, f);
			}

			for (Patient p : patientList) {
				insertedPatientList.add(
					new Patient__c (
			 			first_name__c = p.firstName,
			 			last_name__c = p.lastName,
			 			patient_id__c = stringGenerator(),
			 			facility__c = facilityMap.get(p.facilityId).id
			 		)
				);
			}
			insert insertedPatientList;
		} catch (Exception e) {
			System.debug('Exception: ' + e.getMessage());
		}
	}
}