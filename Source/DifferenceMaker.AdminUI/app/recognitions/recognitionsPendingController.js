differenceMakerApp.controller('recognitionsPendingController', function ($scope) {
    $scope.pendingGridData = [];
    $scope.selectedRecognitionsPendingItems = [];

    $scope.pendingGridOptions = {
        data: 'pendingGridData',
        showGroupPanel: true,
        enableColumnResize: true,
        columnDefs: [
            { field: 'Presenter', displayName: 'Presenter' },
            { field: 'PresentedOn', displayName: 'Date Presented' }
        ],
        selectedItems: $scope.selectedRecognitionsPendingItems,
        multiSelect: false
    };

    $scope.loadPendingData = function () {
        var sourceUrl = window.restUrl + "awards/pending/" + currentUser;

        $.getJSON(sourceUrl, function (data) {
            $scope.pendingGridData = data;
            $scope.$digest();
        });
    }
    $scope.loadPendingData();
});