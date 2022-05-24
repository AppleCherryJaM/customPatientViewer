trigger FacilityTrigger on Facility__c (before delete) {
	if (Trigger.isBefore) {
		if (Trigger.isDelete) {
			List<Patient__c> patientList = [SELECT id FROM Patient__c WHERE Facility__c IN :Trigger.Old];
			Set<Id> patientIdSet = new Set<Id>();
			for (Patient__c p : patientList) {
				patientIdSet.add(p.id);
			}
			Database.executeBatch(new FacilityTriggerHandler(patientIdSet));
		}
	}
}