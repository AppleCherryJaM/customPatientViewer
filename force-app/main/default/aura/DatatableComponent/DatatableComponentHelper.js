({
    getPatients: function(cmp) {
        var patientList = [];
        var facility = cmp.get("v.chosenValue");
        var action = cmp.get("c.getPatientList");
        action.setParams({ currentFacility: facility });
        action.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                if (res.getReturnValue().isSuccess) {
                    for (var patient of res.getReturnValue().data) {
                        patientList.push(patient);
                    }
                    cmp.set("v.patientList", patientList);
                }
            } else {
                console.log('Error msg');
            }
        });
        $A.enqueueAction(action);
    }
})