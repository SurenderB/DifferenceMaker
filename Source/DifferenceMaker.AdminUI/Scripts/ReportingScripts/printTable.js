function printTable(tableId) {
    var divToPrint = document.getElementById(tableId);
    $.get(dmBaseUrl + 'Content/PrintTable.mst', function(template) {
        var rendered = Mustache.render(template, { tableHTML: divToPrint.outerHTML });
        newWin = window.open("");
        newWin.document.write(rendered);
        newWin.document.close();
        newWin.focus();
        newWin.print();
        newWin.close();
    });
}
