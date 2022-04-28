trigger AnimalTriiger on Animal__c (after insert) {
	if (Trigger.isInsert) {
		AnimalTriggerHandler.animalIdListComparator(Trigger.new);
	}
}