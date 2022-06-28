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
        //helper.getFacilities(cmp);
    },

    onComboboxChangeListener: function(cmp, event, helper) {
        helper.getPatients(cmp, event.getParam("value"));
        cmp.set("v.isComboboxSelected", true);
    }
})