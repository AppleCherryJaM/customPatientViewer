({
    onInit: function(cmp, event, helper) {
        var columns = [{
                label: 'First Name',
                fieldName: 'linkName',
                type: 'url',
                typeAttributes: {
                    label: { fieldName: 'firstName' },
                    target: '_blank'
                },
                cellAttributes: {
                    class: 'slds-box',
                    alignment: 'center'
                }
            },
            {
                label: 'Last Name',
                fieldName: 'lastName',
                typeAttributes: {
                    label: { fieldName: 'lastName' },
                    target: '_blank'
                },
                cellAttributes: {
                    class: 'slds-box',
                    alignment: 'center'
                }
            }
        ];
        cmp.set("v.columns", columns);
        helper.getFacilities(cmp);
    },

    handleComponentEvent: function(cmp, event, helper) {
        var value = event.getParam("message");
        helper.getPatients(cmp, value);
        cmp.set("v.isComboboxSelected", true);
    }
})