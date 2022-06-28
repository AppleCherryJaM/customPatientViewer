({
    onInit: function(component, event, helper) {
        console.log(component.get("v.chosenValue"));
        helper.getPatients(component);
    }
})