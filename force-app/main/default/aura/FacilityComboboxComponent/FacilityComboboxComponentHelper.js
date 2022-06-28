({
    getFacilities: function(cmp) {
        var facilityList = [];
        var action = cmp.get("c.getFacilities");
        action.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                if (res.getReturnValue().isSuccess) {
                    for (var facility of res.getReturnValue().data) {
                        facilityList.push(facility);
                    }
                    cmp.set("v.options", facilityList);
                } else {
                    console.log("ERROR");
                }
            }
        });
        $A.enqueueAction(action);
    }
})