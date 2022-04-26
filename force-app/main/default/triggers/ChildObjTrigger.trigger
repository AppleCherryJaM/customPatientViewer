trigger ChildObjTrigger on Child_Obj__c (after insert, after update, after delete) {
	if (Trigger.isUpdate) {
		update ChildObjTriggerHandler.updateParent(Trigger.old, Trigger.new);	
	}
	if (Trigger.isInsert) {
		update ChildObjTriggerHandler.changeChildrenNumberForInsert(Trigger.new);
	}
	if (Trigger.isDelete) {
		update ChildObjTriggerHandler.changeChildrenNumberForDelete(Trigger.old);
	}
}