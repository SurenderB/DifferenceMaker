<%@ Control Language="C#" AutoEventWireup="false" Inherits="logging" CodeBehind="logging.ascx.cs" %>

<%@ Reference Control="~/Controls/loggingForm.ascx" %>
<%@ Reference Control="~/Controls/review.ascx" %>
<%--<%@ Reference Control="~/Controls/pending.ascx" %>--%>
<%--<%@ Reference Control="~/Controls/detail.ascx" %>--%>
<%@ Reference Control="~/Controls/success.ascx" %>
<%@ Reference Control="~/Controls/fail.ascx" %>
<%@ Register TagPrefix="mvLogging" TagName="Give" Src="~/Controls/loggingForm.ascx" %>
<%@ Register TagPrefix="mvLogging" TagName="Review" Src="~/Controls/review.ascx" %>
<%--<%@ Register TagPrefix="mvPending" TagName="Pending" Src="~/Controls/pending.ascx" %>--%>
<%--<%@ Register TagPrefix="mvPending" TagName="PendingDetail" Src="~/Controls/detail.ascx" %>--%>
<%@ Register TagPrefix="mvMisc" TagName="giveSuccess" Src="~/Controls/success.ascx" %>
<%@ Register TagPrefix="mvMisc" TagName="giveFail" Src="~/Controls/fail.ascx" %>


<script language="javascript" id="OnKeyDownStuff">
    /*
        Script gotten from:
        http://www.codingforums.com/showpost.php?p=234072&postcount=4
        and modified on 11-21-2006
    */
</script>

<table align="center" width="100%">
    <tr>
        <td valign="top" width="383px">

            <asp:MultiView ID="mvGiveAnAward" runat="server" ActiveViewIndex="0">
                <asp:View ID="logForm" runat="server" EnableTheming="true">
                    <mvLogging:Give ID="giveAward" runat="server" />

                </asp:View>
                <asp:View ID="logReview" runat="server" EnableTheming="true">
                    <mvLogging:Review ID="reviewAward" runat="server" />
                </asp:View>

                <asp:View ID="success" runat="server" EnableTheming="true">
                    <mvMisc:giveSuccess ID="successful" runat="server" />
                </asp:View>

                <asp:View ID="fail" runat="server" EnableTheming="true">
                    <mvMisc:giveFail ID="failed" runat="server" />
                </asp:View>
            </asp:MultiView>

        </td>
        <td width="22" background="/images/div1.gif"></td>
        <td valign="top" width="360px">
            <table width="100%">
                <tr>
                    <th colspan="100%" align="center">Recognitions Pending
                    </th>
                </tr>
                <tr>
                    <td style="width: 3px;">
                        <div ng-controller="recognitionsPendingController">
                            <div class="gridStyle" ng-grid="pendingGridOptions"></div>
                            <br />
                            <br />
                            <div ng-hide="selectedRecognitionsPendingItems.length==0">
                                <a class="btn btn-default" href="#" id="printDetailsLink" onclick='window.printTable("pendingDetailsTable")'>Print Details</a>
                                <table id="pendingDetailsTable" class="detailsTable" width="100%">
                                    <tr>
                                        <td>Redemption Code</td>
                                        <td>{{selectedRecognitionsPendingItems[0].Award_ID}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Name</td>
                                        <td>{{selectedRecognitionsPendingItems[0].Presenter}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Team</td>
                                        <td>{{selectedRecognitionsPendingItems[0].PresenterTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Presenter's Location</td>
                                        <td>{{selectedRecognitionsPendingItems[0].PresenterLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Name</td>
                                        <td>{{selectedRecognitionsPendingItems[0].Recipient}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Team</td>
                                        <td>{{selectedRecognitionsPendingItems[0].RecipientTeam}}</td>
                                    </tr>
                                    <tr>
                                        <td>Recipient's Location</td>
                                        <td>{{selectedRecognitionsPendingItems[0].RecipientLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date To Be Presented</td>
                                        <td>{{selectedRecognitionsPendingItems[0].PresentedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Reason</td>
                                        <td>{{selectedRecognitionsPendingItems[0].Reason}}</td>
                                    </tr>
                                    <tr>
                                        <td>Date Redeemed</td>
                                        <td>{{selectedRecognitionsPendingItems[0].RedeemedOn}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Location</td>
                                        <td>{{selectedRecognitionsPendingItems[0].RedemptionLocation}}</td>
                                    </tr>
                                    <tr>
                                        <td>Redemption Comments</td>
                                        <td>{{selectedRecognitionsPendingItems[0].RedemptionComment}}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>


