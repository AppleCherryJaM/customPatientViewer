({
    onInit: function(cmp, event, helper) {
        var columns = [{
                label: 'First Name',
                fieldName: 'firstName',
                cellAttributes: {
                    class: 'slds-box slds-theme_shade',
                    alignment: 'center'
                }
            },
            {
                label: 'Last Name',
                fieldName: 'lastName',
                cellAttributes: {
                    class: 'slds-box slds-theme_shade',
                    alignment: 'center'
                }
            }
        ];
        cmp.set("v.columns", columns);
        helper.getFacilities(cmp);
    },

    patientListEditor: function(cmp, event, helper) {
        // var heresy = cmp.get("v.isComboboxSelected");
        var smth = cmp.get("v.patientList");
        if (smth) {
            helper.getPatients(cmp, heresy);
        }
        console.log("AAAAA!");
        console.log(cmp.get("v.patientList"));
    }
})