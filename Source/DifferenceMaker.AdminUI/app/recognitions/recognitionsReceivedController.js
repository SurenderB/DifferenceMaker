differenceMakerApp.controller('recognitionsReceivedController', function ($scope, $http) {
    $scope.recognitionsReceivedGridData = [];
    $scope.selectedRecognitionsReceivedItems = [];
    $scope.recognitions = $scope.selectedRecognitionsReceivedItems[0];

    $scope.recognitionsReceivedGridOptions = {
        data: 'recognitionsReceivedGridData',
        showGroupPanel: true,
        enableColumnResize: true,
        columnDefs: [
            { field: 'Presenter', displayName: 'Presenter' },
            { field: 'PresentedOn', displayName: 'Date Presented' }
        ],
        selectedItems: $scope.selectedRecognitionsReceivedItems,
        multiSelect: false
        //showFilter: true
    };

    $scope.loadRecognitionsReceivedData = function () {
        var sourceUrl =  window.restUrl + "awards/recognitionsReceived/" + currentUser;
        
        $.getJSON(sourceUrl, function (data) {
            $scope.recognitionsReceivedGridData = data;
            $scope.$digest();
        });
    }
    $scope.loadRecognitionsReceivedData();
});

