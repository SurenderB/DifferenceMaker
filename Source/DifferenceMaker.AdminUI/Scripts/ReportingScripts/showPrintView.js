function showPrintView(code) {

    var print_view;

    print_view = window.open('printView.aspx?detailCode=' + code, 'print_view', 'menubar=yes,resizable=no,width=640,height=480');
    //print_view = window.open('printView.aspx','print_view', 'width=640,height=480');
    print_view.focus();


}
