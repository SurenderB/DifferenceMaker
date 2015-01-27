differenceMakerApp.controller('recognitionsGivenController', function ($scope) {
    $scope.recognitionsGivenGridData = [];
    $scope.selectedRecognitionsGivenItems = [];

    $scope.recognitionsGivenGridOptions = {
        data: 'recognitionsGivenGridData',
        showGroupPanel: true,
        enableColumnResize: true,
        columnDefs: [
        {
            field: 'Recipient',
            displayName: 'Recipient'
        },
        {
            field: 'PresentedOn',
            displayName: 'Date Presented'
        }
        ],
        selectedItems: $scope.selectedRecognitionsGivenItems,
        multiSelect: false
    };


    $scope.loadRecognitionsGivenData = function () {
        var sourceUrl = window.restUrl +  "awards/recognitionsGiven/" + currentUser;

        $.getJSON(sourceUrl, function (data) {
            $scope.recognitionsGivenGridData = data;
            $scope.$digest();
        });
    }
    $scope.loadRecognitionsGivenData();
});

