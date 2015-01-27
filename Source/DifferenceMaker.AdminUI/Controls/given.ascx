<%@ Control Language="C#" AutoEventWireup="false" Inherits="given" CodeBehind="given.ascx.cs" %>
<script>
    var currentUser = <%= Session["currentUser_EmpID"] == null ? "0" : Session["currentUser_EmpID"].ToString() %>;
</script>

<table align="center" style="border-spacing: 5px; border-collapse: separate;" >
    <tr>

        <td valign="top" width="390px">

            <table align="center" border="0" width="100%">
                <tr>
                    <th align="center" colspan="100%"> Recognitions You've Given</th>
                </tr>
                <tr>
                    <td valign="top">

                        <div ng-controller="recognitionsGivenController">
                            <div class="gridStyle" ng-grid="recognitionsGivenGridOptions"></div>
                            <br />
                            <br />
                            <div ng-hide="selectedRecognitionsGivenItems.length==0">
                                <a href="#" id="printDetailsLink" onclick='window.printTable("pendingDetailsTable")'>Print Details</a>
                                <table class="detailsTable" width="100%">
                                    <tr>
                                        <td>Redemption Code</td>
                                        <td>{{selectedRecognitionsGivenItems[0].Award_ID}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Name</td>
                                        <td>{{selectedRecognitionsGivenItems[0].Presenter}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Team</td>
                                        <td>{{selectedRecognitionsGivenItems[0].PresenterTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Location</td>
                                        <td>{{selectedRecognitionsGivenItems[0].PresenterLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Name</td>
                                        <td>{{selectedRecognitionsGivenItems[0].Recipient}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Team</td>
                                        <td>{{selectedRecognitionsGivenItems[0].RecipientTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Location</td>
                                        <td>{{selectedRecognitionsGivenItems[0].RecipientLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date To Be Presented</td>
                                        <td>{{selectedRecognitionsGivenItems[0].PresentedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Reason</td>
                                        <td>{{selectedRecognitionsGivenItems[0].Reason}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date Redeemed</td>
                                        <td>{{selectedRecognitionsGivenItems[0].RedeemedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Location</td>
                                        <td>{{selectedRecognitionsGivenItems[0].RedemptionLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Comments</td>
                                        <td>{{selectedRecognitionsGivenItems[0].RedemptionComment}}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>

        </td>
        <td width="22" background="/images/div1.gif"></td>

        <td valign="top" width="360px">
            <table width="100%">
                <tr>
                    <th align="center" colspan="100%">Recognitions You've Received</th>
                </tr>
                <tr valign="top">
                    <td>

                        <div ng-controller="recognitionsReceivedController">
                            <div class="gridStyle" ng-grid="recognitionsReceivedGridOptions"></div>
                            <br />
                            <br />
                            <div ng-hide="selectedRecognitionsReceivedItems.length==0">
                                <a href="#" id="printDetailsLink" onclick='window.printTable("pendingDetailsTable")'>Print Details</a>
                                <%--<recognitions-detail/>--%>
                                <table class="detailsTable" width="100%">
                                    <tr>
                                        <td>Redemption Code</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].Award_ID}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Name</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].Presenter}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Team</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].PresenterTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Location</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].PresenterLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Name</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].Recipient}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Team</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].RecipientTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Location</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].RecipientLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date To Be Presented</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].PresentedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Reason</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].Reason}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date Redeemed</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].RedeemedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Location</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].RedemptionLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Comments</td>
                                        <td>{{selectedRecognitionsReceivedItems[0].RedemptionComment}}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>

            <%-- <asp:MultiView ID="mvReceived" runat="server" ActiveViewIndex="0">
                    <asp:View ID="receivedForm" runat="server" EnableTheming="true">
                        <mvReceived:Received ID="awardsReceived" runat="server" />
                    </asp:View>
                    <asp:View ID="receivedDetail" runat="server" EnableTheming="true">
                        <mvReceived:ReceivedDetail ID="detailReceived" runat="server" />
                    </asp:View>
                </asp:MultiView>--%>
        </td>
    </tr>
</table>
