({
    onInit: function(cmp) {},

    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    loadMoreData: function(cmp, event, helper) {
        try {
            var cmpEvent = $A.get("e.c:PatientDatatableLoadEvent");
            cmpEvent.setParams({ "isLoad": true });
            cmpEvent.fire();
        } catch (error) {
            console.log("ERROR: ", error.message);
        }
    }
});