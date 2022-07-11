({
    onInit: function(cmp) {},

    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    loadMoreData: function(cmp, event, helper) {
        //     try {
        //         // cmp.set('v.rowsToLoad', 3);

        //         event.getSource().set("v.isLoading", true);
        //         // cmp.set('v.loadMoreStatus', 'Loading');

        //         // promiseData = helper.fetchData(cmp, fetchData, rowsToLoad);
        //         var data = cmp.get("v.data");
        //         // promiseData.then($A.getCallback(function(data) {
        //         if (cmp.get('v.patientList').length === cmp.get('v.data').length) {
        //             cmp.set('v.enableInfiniteLoading', false);
        //             cmp.set('v.loadMoreStatus', 'No more data to load');
        //             // console.log('ZALUPA!', JSON.parse(JSON.stringify(cmp.get("v.data"))));
        //         } else {
        //             var currentData = cmp.get('v.data2');
        //             var newData = currentData.concat(data);
        //             cmp.set('v.data', newData);
        //             cmp.set('v.loadMoreStatus', '');
        //             // }
        //             event.getSource().set("v.isLoading", false);
        //             // }));
        //             console.log('SEMEN!', JSON.parse(JSON.stringify(cmp.get("v.data"))));
        //         }
        //     } catch (err) {
        //         console.log(err);
        //     }
        console.log('TARGET!');
        try {
            var cmpEvent = $A.get("e.c:PatientDatatableLoadEvent");
            cmpEvent.setParams({ "isLoad": true });
            cmpEvent.fire();
        } catch (error) {
            console.log("ERROR: ", error.message);
        }
    },

    testClick: function(cmp) {
        console.log("START!");

    }
});