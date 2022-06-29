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

    handleComponentEvent: function(cmp, event, helper) {
        var value = event.getParam("message");
        console.log("VALUE: ", value);
        helper.getPatients(cmp, value);
        cmp.set("v.isComboboxSelected", true);
    }
})