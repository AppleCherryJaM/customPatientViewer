trigger ChildLookup on Parent_Obj__c (after insert) {
	List<Child_Obj__c> childList = new List<Child_Obj__c>();
    for(Parent_Obj__c parent : Trigger.new) {
        childList.add(new Child_Obj__c (
        	Name = parent.Name,
        	Parent__c = parent.Id)
			);
    }
    insert childList;
}