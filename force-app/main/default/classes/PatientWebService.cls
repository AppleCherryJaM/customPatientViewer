@RestResource(urlMapping='/patients/*')
global with sharing class PatientWebService {
	
	public static List<Patient> patientList;

  global class Patient {
      public String firstName;
      public String lastName;
      public String patientId;
			public String facilityId; 
  }

	@HttpPost
	global static String httpPost() {
		String restRequestBody;
		try {
			RestRequest restRequest = RestContext.request;
			restRequestBody = restRequest.requestBody.toString().trim();
			patientList = restRequestBody != null ? (List<Patient>) JSON.deserialize(restRequestBody, List<Patient>.class): new List<Patient>();
			List<String> patientsId = new List<String>();
			for (Patient p : patientList) {
				patientsId.add(p.patientId);
			}
			List<Patient__c> currentPatientList = [SELECT first_name__c, last_name__c, patient_id__c, facility__c FROM Patient__c WHERE patient_id__c IN :patientsId];
			Map<String, Patient__c> currentPatientMap = new Map<String, Patient__c>();
			for (Patient__c p : currentPatientList) {
				currentPatientMap.put(p.patient_id__c, p);
			}

			List<Patient__c> insertedPatientList = new List<Patient__c>();
			Map<String, Facility__c> facilityMap = new Map<String, Facility__c>();

			//create and add into idList values
			List<String> idList = new List<String>();
			for (Patient p : patientList) {
				idList.add(p.facilityId);
			}

			List<Facility__c> facilityListById = [SELECT id, name, Clinic_name__c, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = :idList];

			for (Facility__c f: facilityListById) {
				facilityMap.put(f.FacilityNumber__c, f);
			}

			//update section
			if (!currentPatientList.isEmpty()) {
				updatePatient(patientList, currentPatientMap, facilityMap);
			}

			for (Integer i = 0; i < patientList.size(); i++) {
				if (currentPatientMap.containsKey(patientList[i].patientId)) {
					patientList.remove(i);
				}
			}
			
			insertFacility(patientList, facilityListById);
			
			facilityListById = [SELECT id, name, Clinic_name__c, FacilityNumber__c FROM Facility__c WHERE FacilityNumber__c = :idList];
			Map<String, Facility__c> newFacilityMap = new Map<String, Facility__c>();
			for (Facility__c f: facilityListById) {
				newFacilityMap.put(f.FacilityNumber__c, f);
			}

			for (Patient p : patientList) {
				insertedPatientList.add(
					new Patient__c (
			 			first_name__c = p.firstName,
			 			last_name__c = p.lastName,
			 			patient_id__c = stringGenerator(),
			 			facility__c = newFacilityMap.get(p.facilityId).id
			 		)
				);
			}
			insert insertedPatientList;

			List<String> responseList = new List<String>();
			for (Patient__c p : insertedPatientList) {
				//responseList.add(p.patient_id__c);
				responseList.add(p.last_Name__c);
			}

			return 'Success: ' + responseList;
		} catch (Exception e) {
			return 'Error: ' + e.getMessage();
		}
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
			if (!facilityMap.containsKey(p.facilityId)) {
				Facility__c f = new Facility__c (
		 			Clinic_name__c = 'Some clinic name',
					FacilityNumber__c = p.facilityId
				);
				insertedFacilityList.add(f);
			}
		}
		insert insertedFacilityList;
	}

	private static void updatePatient(List<Patient> patientList, Map<String, Patient__c> currentPatientList, Map<String, Facility__c> facilityMap) {
		List<Patient__c> customPatientList = new List<Patient__c>();
		for (Patient p : patientList) {
			if (currentPatientList.containsKey(p.patientId)) {
				Patient__c bufferObj = currentPatientList.get(p.patientId);
				
				if (facilityMap.get(p.facilityId).id != bufferObj.facility__c) {
					bufferObj.facility__c = facilityMap.get(p.facilityId).id;
				}

				if (p.firstName != bufferObj.first_Name__c) {
					bufferObj.first_Name__c = p.firstName;
				}
				
				if (p.lastName != bufferObj.last_Name__c) {
					bufferObj.last_Name__c = p.lastName;
				}
				customPatientList.add(bufferObj);
			}
		}
		update customPatientList;
	}
}