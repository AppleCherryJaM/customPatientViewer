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

		private static Facility__c getFacilityById(String facilityId) {
		return [SELECT Clinic_Name__c, Name, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = :facilityId];
	}

	private static String stringGenerator() {
		Integer randomNumber = Integer.valueOf((Math.random() * 100));
		List<String> alphabet = new List<String>();
		alphabet.add('a');
		alphabet.add('b');
		alphabet.add('c');
		alphabet.add('d');
		alphabet.add('e').
		alphabet.add('f');
		alphabet.add('g');
		alphabet.add('h');
		//дальше мне лень
		String generatedFacilityNumber = '';

		for (Integer i = 0; i < alphabet.size(); i++) {
			generatedFacilityNumber += alphabet[Integer.valueOf((Math.random() * (alphabet.size() - 1)))];
		}
		return generatedFacilityNumber + ' ' + Integer.valueOf((Math.random() * 100));
	}

	@HttpPost
	global static void httpPost() {
		String restRequestBody;
		try {
			RestRequest restRequest = RestContext.request;
			restRequestBody = restRequest.requestBody.toString().trim();
			patientList = restRequestBody != null ? (List<Patient>) JSON.deserialize(restRequestBody, List<Patient>.class): new List<Patient>();
			System.debug(patientList);
			for (Patient p : patientList) {
				if (getFacilityById(p.facilityId) == null) {
					Facility__c newFacility = new Facility__c(
						Clinic_name__c = 'Some clinic name',
						FacilityNumber__c = stringGenerator()
					);
					insert newFacility;
				}
				Patient__c newPatient = new Patient__c(
					first_name__c = p.firstName,
					last_name__c = p.lastName,
					patient_id__c = stringGenerator(),
					facility__c = getFacilityById(p.facilityId)
				);
				insert newPatient;
			}
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}
}