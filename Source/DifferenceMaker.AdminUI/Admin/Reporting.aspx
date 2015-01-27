<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="false" Inherits="Admin_Reporting" Title="Reporting Page" CodeBehind="Reporting.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAdminContent" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("[jsid = 'webCalStartDate']").datepicker();
            $("[jsid = 'webCalEndDate']").datepicker();
        });

        var currentNodeValue = '<%= Session["CurrentNodeValue"] %>';
        var currentUser = '<%= Session["currentUser_EmpID"] == null ? "0" : Session["currentUser_EmpID"].ToString() %>';      
        

    </script>
    <script src="../app/differenceMakerApp.js"></script>
    <script src="../Scripts/ng-grid-csv-export.js"></script>
    <script src="../app/reporting/reportingController.js"></script>

    <table id="tblReportingPage" ng-controller="reportingController">
        <tr>
            <td align="center">
                <h2><strong>Recognition Reporting Page</strong><hr style="height: 1px; border: none; color: #333; background-color: #333;" />
                </h2>
            </td>
        </tr>
        <tr>
            <td class="tab">
                <asp:Panel jsid="pnlAdminData" ID="pnlAdmin" runat="server" Width="650px">
                    <asp:MultiView ID="mvAdmin" runat="server">
                        <asp:View ID="vEmployees" runat="server">
                            <div align="left">
                                <strong>Select the desired report for execution:</strong><br />
                                <br />
                                &nbsp;&nbsp;&nbsp;&nbsp;<asp:LinkButton ID="lnkAwardsByEmployee" runat="server" ToolTip="Select this report to view awards by employee">Recognitions by Employee</asp:LinkButton><br />
                                <br />
                                &nbsp;&nbsp;&nbsp;&nbsp;<asp:LinkButton ID="lnkAybForTax" runat="server" ToolTip="Select this report to export A+ Your Best awards ($25) for taxing purposes">Recognitions for Tax Purposes</asp:LinkButton><br />
                            </div>
                        </asp:View>
                        <asp:View ID="vReportOptions" runat="server">
                            <div style="text-align: center;">
                                <h4>Recognitions by Employee</h4>
                                <asp:Table ID="tblDates" runat="server" Width="100%" Style="text-align: center">
                                    <asp:TableRow ID="trDates" runat="server">
                                        <asp:TableCell ID="tcDates" runat="server">
                                            <table style="margin: auto; border-spacing: 5px; border-collapse: separate;">
                                                <tr>
                                                    <td align="right">Recognitions to View:</td>
                                                    <td align="left">
                                                        <asp:DropDownList jsid="ddlAwardsToView" ID="ddlAwardsToView" runat="server" AutoPostBack="False" Width="200">
                                                            <asp:ListItem Text="All Recognitions Received" Value="Received"></asp:ListItem>
                                                            <asp:ListItem Text="All Recognitions Presented" Value="Presented"></asp:ListItem>
                                                            <asp:ListItem Text="Unredeemed Recognitions" Value="Unredeemed"></asp:ListItem>
                                                            <asp:ListItem Text="Redeemed Recognitions" Value="Redeemed"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td align="right">Start Date:</td>
                                                    <td align="left">
                                                        <input type="text" id="webCalStartDate" jsid="webCalStartDate" name="txtWebCalStartDate" runat="server" value="1/1/2013" />
                                                    </td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="valStartDate" runat="server" ErrorMessage="A start date is required"
                                                            ValidationGroup="valUDates" ControlToValidate="webCalStartDate"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">End Date:</td>
                                                    <td align="left">
                                                        <input type="text" id="webCalEndDate" jsid="webCalEndDate" name="txtWebCalEndDate" runat="server" value="12/31/2014" />

                                                    </td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="valEndDate" runat="server" ErrorMessage="An end date is required"
                                                            ValidationGroup="valUDates" ControlToValidate="webCalEndDate"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <div>
                                                            <input id="Reset3" type="reset" value="Reset" class="btn btn-primary btn-sm" title="Reset form and select default values" onclick="location.reload()" />
                                                            <button class="btn btn-primary btn-sm" id="btnAybEmpReport" ng-click="loadEmployeeData()"
                                                                type="button" validationgroup="valUDates">
                                                                Generate Report</button>
                                                            <p></p>
                                                            <div id="reportingGrid" class="gridStyle" ng-show="showEmployeeGrid" ng-grid="employeeGridOptions">
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:TableCell>
                                    </asp:TableRow>
                                </asp:Table>
                            </div>
                        </asp:View>
                        <asp:View ID="vAybAwards" runat="server">
                            <div style="text-align: center;">
                                <h3>Recognitions for Tax Purposes</h3>
                                <table width="90%" style="margin: auto; border-spacing: 5px; border-collapse: separate;">
                                    <tr>
                                        <td align="right">Recognitions to View:
                                        </td>
                                        <td align="left">
                                            <asp:DropDownList jsid="ddlAybReportType" ID="ddlAybReportType" runat="server">
                                                <asp:ListItem Value="true">$25</asp:ListItem>
                                                <asp:ListItem Value="false">Other</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Year:</td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlYearAyb" runat="server" AutoPostBack="True" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Pay period:</td>
                                        <td align="left">
                                            <asp:DropDownList jsid="ddlPayPeriodAyb" ID="ddlPayPeriodAyb" runat="server" DataTextFormatString="{0:MM-dd-yyyy}">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <input id="Reset1" type="reset" value="Reset" class="btn btn-primary btn-sm" title="Reset form and select default values" onclick="location.reload()"/>
                                            <button class="btn btn-primary btn-sm" id="btnGenerateTaxReport" ng-click="loadTaxData()"
                                                type="button" validationgroup="valUDates">
                                                Generate Report</button>
                                            <div id="taxReportingGrid" class="gridStyle" ng-grid="taxGridOptions"  ng-show="showTaxGrid"></div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                </asp:Panel>
                <table>
                    <tr>
                        <td>
                            <asp:TreeView jsid="treeEmployees" ID="treeEmployees" Style="overflow-y:auto;"
                                runat="server" Height="300px" Width="485px" Visible="true" OnSelectedNodeChanged="treeEmployees_SelectedNodeChanged">
                            </asp:TreeView>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    &nbsp;
</asp:Content>
