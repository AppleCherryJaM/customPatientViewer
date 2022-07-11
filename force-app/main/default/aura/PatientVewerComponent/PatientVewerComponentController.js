({
    onInit: function(cmp, event, helper) {
        helper.getColumns(cmp);
        helper.getFacilities(cmp);

    },

    handleComponentEvent: function(cmp, event, helper) {
        var value = event.getParam("message");
        helper.getPatients(cmp, value);
        cmp.set("v.isComboboxSelected", true);
    },
    addNewInfo: function(cmp, event, helper) {
        var value = event.getParam("isLoad");
        console.log("addNewInfo is entered!");

        var storage = cmp.get("v.storage");
        var data = cmp.get("v.data");

        if (storage.length === 0) {
            cmp.set("v.isLoad", false);
        } else {
            data.push(storage[0]);
            cmp.set("v.data", data);
            storage.shift();
            cmp.set("v.storage", storage);
        }
    }
})