({
    getFacilities: function(cmp) {
        var facilityList = [];
        var action = cmp.get("c.getFacilities");
        action.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                if (res.getReturnValue().isSuccess) {
                    for (var facility of res.getReturnValue().data) {
                        facilityList.push(facility);
                    }
                    cmp.set("v.options", facilityList);
                } else {
                    console.log("ERROR");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getPatients: function(cmp, facility) {
        var patientList = [];
        var action = cmp.get("c.getPatientList");

        function SortArray(x, y) {
            if (x.lastName < y.lastName) { return -1; }
            if (x.lastName > y.lastName) { return 1; }
            return 0;
        }

        action.setParams({ currentFacility: facility });
        action.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                if (res.getReturnValue().isSuccess) {
                    for (var patient of res.getReturnValue().data) {
                        patientList.push(patient);
                    }
                    var editedPatients = patientList.sort(SortArray);
                    editedPatients.forEach((record) => {
                        record.linkName = 'https://datatest3-dev-ed.lightning.force.com/lightning/r/Patient__c/' + record.id + '/view';
                    });
                    cmp.set("v.patientList", editedPatients);
                }
            } else {
                console.log('Error msg');
            }
        });
        $A.enqueueAction(action);
    }
});