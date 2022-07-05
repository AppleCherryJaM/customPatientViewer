({
    loadMoreData: function(cmp, event, helper) {
        try {
            cmp.set('v.rowsToLoad', 3);

            event.getSource().set("v.isLoading", true);
            cmp.set('v.loadMoreStatus', 'Loading');

            // promiseData = helper.fetchData(cmp, fetchData, rowsToLoad);

            // promiseData.then($A.getCallback(function(data) {
            if (cmp.get('v.patientList').length >= cmp.get('v.totalNumberOfRows')) {
                cmp.set('v.enableInfiniteLoading', false);
                cmp.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = cmp.get('v.patientList');
                var newData = currentData.concat(data);
                cmp.set('v.patientList', newData);
                cmp.set('v.loadMoreStatus', '');
            }
            event.getSource().set("v.isLoading", false);
            // }));
        } catch (error) {
            console.log(error);
        }
    }
})