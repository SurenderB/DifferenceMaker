function printTable(tableId) {
    var divToPrint = document.getElementById(tableId);
    newWin = window.open("");
    newWin.document.write(divToPrint.outerHTML);
    newWin.document.close();
    newWin.focus();
    newWin.print();
    newWin.close();
}

