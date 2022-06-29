({
    // onInit: function(component, event, helper) {
    //     helper.getFacilities(component);
    // },
    onComboboxChangeListener: function(cmp, event) {
        cmp.set("v.chosenValue", event.getParam("value"));
        cmp.set("v.isChosen", true);
    }
})