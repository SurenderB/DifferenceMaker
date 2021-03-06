﻿
function ngGridCsvExportPlugin(opts, $compile) {
    var self = this;
    self.grid = null;
    self.scope = null;
    self.services = null;
    self.init = function (scope, grid, services) {
        self.grid = grid;
        self.scope = scope;
        self.services = services;
        function showDs() {
            var keys = [];
            for (var f in grid.config.columnDefs) {
                if (grid.config.columnDefs.hasOwnProperty(f)) {
                    keys.push(grid.config.columnDefs[f].field);
                }
            }
            var csvData = '';
            function csvStringify(str) {
                if (str == null) { // we want to catch anything null-ish, hence just == not ===
                    return '';
                }
                if (typeof (str) === 'number') {
                    return '' + str;
                }
                if (typeof (str) === 'boolean') {
                    return (str ? 'TRUE' : 'FALSE');
                }
                if (typeof (str) === 'string') {
                    return str.replace(/"/g, '""');
                }

                return JSON.stringify(str).replace(/"/g, '""');
            }
            function swapLastCommaForNewline(str) {
                var newStr = str.substr(0, str.length - 1);
                return newStr + "\n";
            }
            for (var k in keys) {
                csvData += '"' + csvStringify(keys[k]) + '",';
            }
            csvData = swapLastCommaForNewline(csvData);
            var gridData = grid.data;
            for (var gridRow in gridData) {
                for (k in keys) {
                    var curCellRaw;
                    if (opts != null && opts.columnOverrides != null && opts.columnOverrides[keys[k]] != null) {
                        curCellRaw = opts.columnOverrides[keys[k]](
                        self.services.UtilityService.evalProperty(gridData[gridRow], keys[k]));
                    } else {
                        curCellRaw = self.services.UtilityService.evalProperty(gridData[gridRow], keys[k]);



                    }
                    csvData += '"' + csvStringify(curCellRaw) + '",';
                }
                csvData = swapLastCommaForNewline(csvData);
            }
            var fp = grid.$root.find(".ngFooterPanel");
            var csvDataLinkPrevious = grid.$root.find('.ngFooterPanel .csv-data-link-span');
            if (csvDataLinkPrevious != null) { csvDataLinkPrevious.remove(); }


            if (window.navigator.msSaveOrOpenBlob) {
                var e = angular.element("<span class=\"csv-data-link-span\"><button ng-click='exportIE()'>CSV Export</button></span>");
                $compile(e)(scope);
                fp.append(e);
            } else {
                var blobdata = new Blob([csvData], { type: 'text/csv' });
                var csvDataLinkHtml = "<span class=\"csv-data-link-span\">";
                csvDataLinkHtml += "<br><a href=\"";
                csvDataLinkHtml += window.URL.createObjectURL(blobdata);
                csvDataLinkHtml += "\" download=\"Export.csv\">CSV Export</a></br></span>";
                fp.append(csvDataLinkHtml);
            }
            scope.exportIE = function () {
                window.navigator.msSaveOrOpenBlob(new Blob([csvData]), 'Export.csv');
            };
        }
        setTimeout(showDs, 0);



        scope.catHashKeys = function () {
            var hash = '';
            for (var idx in scope.renderedRows) {
                hash += scope.renderedRows[idx].$$hashKey;
            }
            return hash;
        };
        if (opts && opts.customDataWatcher) {
            scope.$watch(opts.customDataWatcher, showDs);
        } else {
            scope.$watch(scope.catHashKeys, showDs);
        }
    };
}
