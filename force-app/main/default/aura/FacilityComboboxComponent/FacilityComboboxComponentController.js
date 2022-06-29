({
    onComboboxChangeListener: function(cmp, event) {
        var value = event.getParam("value");
        cmp.set("v.chosenValue", value);
        var cmpEvent = cmp.get("cmpEvent");
        cmpEvent.setParams({ "message": value });
        cmpEvent.fire();
    }
})