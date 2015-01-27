
differenceMakerApp.controller('reportingController', function ($scope, $compile) {
    $scope.showEmployeeGrid = false,
    $scope.employeeGridData = [],
    $scope.employeeGridOptions = {
        data: 'employeeGridData',
        showGroupPanel: true,
        enableColumnResize: true,
        multiSelect: false,
        plugins: [new ngGridCsvExportPlugin(null, $compile)],
        showFooter: true, // to show export CSV option
        columnDefs: [
            { field: 'Award_ID', displayName: "Redemption Code", width: 130 },
            { field: 'Presenter', displayName: "Presenter", width: 120 },
            { field: 'PresenterTeam', displayName: "Pesenter's Team", width: 190 },
            { field: 'PresenterLocation', displayName: "Presenter's Location", width: 135 },
            { field: 'Recipient', displayName: "Recipient", width: 120 },
            { field: 'RecipientTeam', displayName: "Recipient's Team", width: 190 },
            { field: 'RecipientLocation', displayName: "Recipient's Location", width: 135 },
            { field: 'PresentedOn', displayName: "Date Presented", width: 120 },
            { field: 'Reason', displayName: "Reason", width: 252 },
            { field: 'RedeemedOn', displayName: "Date Redeemed", width: 120 },
            { field: 'RedemptionLocation', displayName: "Redemption Location", width: 140 },
            { field: 'RedemptionComment', displayName: "Redemption Comments", width: 140 },
            { field: 'Amount', displayName: "Award Amount", width: 120 },
            { field: 'AwardDescription', displayName: "Description", width: 120 }
        ]
    };

    $scope.loadEmployeeData = function () {
        var userId = currentUser;
        if (currentNodeValue != "0")
            userId = currentNodeValue;
        var sourceUrl = window.restUrl + "awards/" +
            $("[jsid='ddlAwardsToView']")[0].value + '/' +
            userId +
            '?startDate=' + $("[jsid = 'webCalStartDate']")[0].value +
            '&endDate=' + $("[jsid = 'webCalEndDate']")[0].value;



        $.getJSON(sourceUrl, function (data) {
            $scope.employeeGridData = data;
            $scope.showEmployeeGrid = true;
            $scope.$digest();
        });
    }

    $scope.showTaxGrid = false,
    $scope.taxGridData = [],
     $scope.taxGridOptions = {
         data: 'taxGridData',
         showGroupPanel: true,
         enableColumnResize: true,
         multiSelect: false,
         plugins: [new ngGridCsvExportPlugin(null, $compile)],
         showFooter: true, // to show export CSV option
         columnDefs: [
            { field: 'Batch_Name', displayName: "Batch Name", width: 130 },
            { field: 'Employee_Name', displayName: "Employee Name", width: 130 },
            { field: 'Clock_No', displayName: "Clock No", width: 130 },
            { field: 'Gross_Amount', displayName: "Gross Amount", width: 130 },
            { field: 'Payroll_Code', displayName: "Payroll Code", width: 130 },
            { field: 'S1', displayName: "S1", width: 130 },
            { field: 'S2', displayName: "S2", width: 130 },
            { field: 'S3', displayName: "S3", width: 130 }
         ]
     };

    $scope.loadTaxData = function () {

        var sourceTaxUrl = window.restUrl + "report/payPeriodReward?payPeriodNumber=" +
            $("[jsid='ddlPayPeriodAyb']")[0].value +
            '&isAYB=' + $("[jsid = 'ddlAybReportType']")[0].value;

        $.getJSON(sourceTaxUrl, function (data) {
            $scope.taxGridData = data;
            $scope.showTaxGrid = true,
            $scope.$digest();
        });
    }

});

