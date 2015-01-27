
function GetCurrentPageName() { 
    //method to get Current page name from url. 
    var pageUrl = document.location.href; 
    var pageName = pageUrl.substring(pageUrl.lastIndexOf('/') + 1); 
 
return pageName.toLowerCase() ;
}
 
$(document).ready(function(){
var currPage = GetCurrentPageName();
 
switch(currPage){
case 'Redemption.aspx':
    $('#lnkRedemption').addClass('active') ;
 break;
case 'Reporting.aspx':
    $('#lnkReporting').addClass('active') ;
 break;
case 'admin.aspx':
    $('#lnkAdmin').addClass('active') ;
 break;
}
});
