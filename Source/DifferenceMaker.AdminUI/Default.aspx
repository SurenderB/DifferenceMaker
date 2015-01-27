<%@ Page EnableSessionState="true" EnableViewState="true" Language="C#" AutoEventWireup="false" Inherits="_Default" CodeBehind="Default.aspx.cs" %>

<%@ Reference Control="~/Controls/logging.ascx" %>
<%@ Reference Control="~/Controls/given.ascx" %>
<%@ Register TagPrefix="uctab1" TagName="tabLogging" Src="~/Controls/logging.ascx" %>
<%@ Register TagPrefix="uctab2" TagName="tabGiven" Src="~/Controls/given.ascx" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>

<html ng-app="differenceMakerApp">

<head runat="server">

    <title>FCSA :: Recognitions</title>
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />
    <link href="Scripts/jquery-ui-1.11.2.custom/jquery-ui.css" rel="stylesheet" />
    <link href="Content/ng-grid.css" rel="stylesheet" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE11"> <!-- Prevents 'Tools -> Compatibility Mode Settings -> Display Intranet sites in compatibility mode' from having negative impact. -->
    <script src="Scripts/jquery-ui-1.11.2.custom/external/jquery/jquery.js"></script>
    <script src="Scripts/jquery-ui-1.11.2.custom/jquery-ui.js"></script>
    <script type="text/javascript" src="Scripts/angular.js"></script>
    <script type="text/javascript" src="Scripts/ng-grid.js"></script>
    <script src="app/differenceMakerApp.js"></script>
    <script src="app/recognitions/recognitionsPendingController.js"></script>
    <script src="app/recognitions/recognitionsReceivedController.js"></script>
    <script src="app/recognitions/recognitionsGivenController.js"></script>
    <script src="Scripts/ReportingScripts/printTable.js"></script>
    <script src="Scripts/ReportingScripts/showPrintView.js"></script>
    <script type="text/javascript">
        var restUrl = '<%= ConfigurationManager.AppSettings["restUrl"] %>';

        function showHelp() {
            help_view = window.open('<%= ConfigurationManager.AppSettings["instructionsUrl"] %>', 'help_view', 'menubar=yes,resizable=yes,width=640,height=480');
            help_view.focus();
        }
        function mouseOver(id) {
            id.style.cursor = "pointer";
            window.status = "Print View";
        }
        $(function () {
            $("#tabAwards").tabs();

        });
    </script>
</head>
<body ng-cloak>
    <form id="form1" runat="server">
        <div align="center">
            <table width="1080" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="100%" style="padding-top: 10px;" align="right">
                        <h5>
                            <ul class="list-inline">
                                <li role="presentation" class="active"><a href="<%= ConfigurationManager.AppSettings["guidelinesUrl"] %>" class="Link">Recognition Guideline</a></li>
                                <li role="presentation"><a href="#" class="Link" onclick="showHelp()">Submission Help</a></li>
                                <li role="presentation"><a href="http://www.smartoneprepaid.com/manage-account" target="_blank" class="Link">Card Balance</a> </li>
                                <li role="presentation"><a href="Admin/Redemption.aspx" class="Link">Redeem Recognitions</a></li>
                            </ul>
                        </h5>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="images/top.png" width="1080" height="12" alt="" /></td>
                </tr>


                <tr>
                    <td style="width: 1080px">
                        <img src="images/header1080.png" width="1080" height="123" alt="" /></td>
                </tr>
                <tr>
                    <td id="tableAwards" colspan="3" style="background-image: url('images/mainbg.png');">
                        <div style="width: 100%; height: 650px;">
                            <div id="tabAwards" runat="server" style="width: 1048px;">
                                <ul class="nav nav-tabs">
                                    <li><a href="#tabGive">Give A Recognition</a></li>
                                    <li><a href="#tabPending">Recognitions History </a></li>
                                </ul>
                                <div id="tabGive" style=" height: 583px;">
                                    <uctab1:tabLogging ID="TabLogging1" runat="server" />
                                </div>
                                <div id="tabPending" style="height: 583px;">
                                    <uctab2:tabGiven ID="TabGiven1" runat="server" />
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="images/btm.png" width="1080" height="23" alt="" /></td>
                </tr>
            </table>
        </div>
    </form>
    <script src="bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
