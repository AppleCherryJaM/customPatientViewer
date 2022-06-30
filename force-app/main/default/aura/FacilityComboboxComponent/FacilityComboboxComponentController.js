({
    onComboboxChangeListener: function(cmp, event) {
        try {
            var value = event.getParam("value");
            cmp.set("v.isChosen", true);
            var cmpEvent = $A.get("e.c:AppEvent");
            cmpEvent.setParams({ "message": value });
            cmpEvent.fire();
        } catch (error) {
            console.log("ERROR: ", error);
        }
    }
})