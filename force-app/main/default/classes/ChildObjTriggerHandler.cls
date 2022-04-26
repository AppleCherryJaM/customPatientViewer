public class ChildObjTriggerHandler {
    
    public static List<Parent_Obj__c> changeChildrenNumberForInsert(List<Child_Obj__c> children) {
        List<Parent_Obj__c> parentListForUpdate = new List<Parent_Obj__c>();

        for (Parent_Obj__c parent : [SELECT id, Child_number__c FROM Parent_Obj__c WHERE id IN (SELECT Parent__c FROM Child_Obj__c Where id IN :children)]) {
            parent.Child_number__c++;
            parentListForUpdate.add(parent);
        }
        return parentListForUpdate;
    }

    public static List<Parent_Obj__c> changeChildrenNumberForDelete(List<Child_Obj__c> children) {
        List<Parent_Obj__c> parentListForUpdate = new List<Parent_Obj__c>();

        for (Parent_Obj__c parent : 
            [SELECT id, Child_number__c FROM Parent_Obj__c WHERE id IN (SELECT Parent__c FROM Child_Obj__c WHERE isDeleted = true AND id IN :children) ALL ROWS]) {
                parent.Child_number__c--;
                parentListForUpdate.add(parent);
            }
            return parentListForUpdate;
    }

    public static List<Parent_Obj__c> updateParent (List<Child_Obj__c> oldList, List<Child_Obj__c> newList) {
        List<Parent_Obj__c> parentListForUpdate = new List<Parent_Obj__c>();
		Integer i = 0;
        
        while (i < newList.size()) {
            if (newList[i].Parent__c != null) {
                Parent_Obj__c newParent = getParentViaChild(newList[i]);
              
            	if (oldList[i].Parent__c == null) {
                	newParent.Child_number__c++;
            	}
            
            	if ((oldList[i].Parent__c != newList[i].Parent__c) && (oldList[i].Parent__c != null)) {
                	Parent_Obj__c oldParent = getParentViaChild(oldList[i]);
                	oldParent.Child_number__c--;
                	newParent.Child_number__c++;
                	parentListForUpdate.add(ChildObjTriggerHandler.changeParentTimeField(oldParent));
            	} 
            	parentListForUpdate.add(ChildObjTriggerHandler.changeParentTimeField(newParent));
            } else {
                Parent_Obj__c oldParent = getParentViaChild(oldList[i]);
                oldParent.Child_number__c--;
                parentListForUpdate.add(oldParent);
            }
            i++;
        }
        return parentListForUpdate;
    }

    private static Parent_Obj__c getParentViaChild(Child_Obj__c child) {
        return [SELECT id, Child_number__c, time_of_change__c FROM Parent_Obj__c WHERE id= :child.Parent__c];
    } 
    
    private static Parent_Obj__c changeParentTimeField(Parent_Obj__c parent) {
        parent.time_of_change__c = System.now();
        return parent;
    }
}