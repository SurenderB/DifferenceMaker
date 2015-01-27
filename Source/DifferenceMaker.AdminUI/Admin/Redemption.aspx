<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="false" Inherits="Redemption" CodeBehind="Redemption.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAdminContent" runat="server">
    <script language="javascript" id="ButtonHandlers">
        function clickBtn(e, buttonid) {
            var btn = document.getElementById(buttonid)
            if (typeof btn == 'object') {
                if (e.keyCode == 13) {
                    btn.click();
                    return false;
                }
            }
        }

        function isCodeNumeric(source, args) {
            var txtRedemptionCode = document.getElementById(source.controltovalidate);
            var code = txtRedemptionCode.value;

            //isNaN returns true if the argument is not a number, and false if the argument is a number            
            if (isNaN(code) == false) {
                //if appNum is a number
                args.IsValid = true;
            }
            else {
                //if appNum is not a number
                args.IsValid = false;
            }
        }//end isAppNumNumeric
    </script>
    <div align="center">
        <table align="center" border="0" cellpadding="0" cellspacing="0" width="650px">
            <tr>
                <td colspan="100%" align="center">
                    <h2><strong>Recognition Redemption Page</strong><hr style="height: 1px; border: none; color: #333; background-color: #333;" />
                    </h2>
                </td>
            </tr>
            <tr>
                <td colspan="100%" align="left" style="color: red">
                    <h4><u>Note:</u></h4>
                    <h5>
                        <strong>
                            <ul>
                                <li>You cannot redeem your own recognition
                                </li>
                                <li>You must be in the mailroon or in the presence of a redemption coordinator
                                </li>
                                <li>You must actually have your Visa gift card in hand
                                </li>
                                <li>Once redeemed, an recognition cannot be redeemed again
                                </li>
                            </ul>
                        </strong>
                    </h5>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="100%" style="height: 44px">
                    <p></p>
                    <div>
                        <label>Redemption Code:</label>
                        <asp:TextBox ID="txtRedemptionCode" runat="server" Text="" Width="200px"></asp:TextBox>
                        <asp:Button ID="btnLookUp" runat="server" Text="Look Up Recognition" ValidationGroup="valRedemptionCode" class="btn btn-primary btn-sm btn-sm" />
                    </div>

                    <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="The redemption code must be a numeric value." ClientValidationFunction="isCodeNumeric" ControlToValidate="txtRedemptionCode" ValidationGroup="valRedemptionCode"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Table ID="tblInfo" runat="server" Visible="false" Style="width: 502px; height: 488px; margin: auto" CssClass="Redeem" >
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ID="tCawardInfo">
                                <table style="border-spacing: 5px; border-collapse: separate; width: 100%">
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="Label1" runat="server" Text="Presenter:"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:TextBox ID="txtPresenter" runat="server" Width="200px" ReadOnly="True" CausesValidation="True"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="Label2" runat="server" Text="Presenter Team:"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:TextBox ID="txtPresenterTeam" runat="server" Width="200px" ReadOnly="True"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="height: 24px">
                                            <asp:Label ID="Label3" runat="server" Text="Recipient:"></asp:Label>
                                        </td>
                                        <td align="right" style="height: 24px">
                                            <asp:TextBox ID="txtRecipient" runat="server" ReadOnly="True" Width="200px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="Label5" runat="server" Font-Bold="False" Font-Underline="False" Text="Recipient Team:"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:TextBox ID="txtRecipientTeam" runat="server" Width="200px" ReadOnly="True"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle">Date Presented:
                                        </td>
                                        <td align="right" valign="middle">
                                            <asp:TextBox ID="txtDatePresented" runat="server" ReadOnly="True" Width="200px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="100%">
                                            <asp:Label ID="Label4" runat="server" Text="Reason:"></asp:Label>
                                            <br />
                                            <asp:TextBox ID="txtReason" TextMode="MultiLine" runat="server" Height="64px" MaxLength="3000" ReadOnly="True" Width="98.5%"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ID="tCRedemptionControl">
                                <table  Style="border-spacing: 5px; border-collapse: separate; width: 100%;">
                                    <tr>
                                        <th align="center" colspan="100%">Redemption</th>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="label7" runat="server" Text="Date Redeemed:"></asp:Label></td>
                                        <td align="right">
                                            <asp:TextBox ID="txtDateRedeemed" runat="server" ReadOnly="True"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="label8" runat="server" Text="Redemption Location:"></asp:Label></td>
                                        <td align="right">
                                            <asp:TextBox ID="txtRedemptionLocation" runat="server" ReadOnly="True"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="label9" runat="server" Text="Redeemer's Initials and Comments:"></asp:Label></td>
                                        <td align="right">
                                            <asp:TextBox ID="txtRedemptionComments" runat="server"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Button class="btn btn-primary btn-sm btn-sm" Width="150px" ID="btnRedeem" Text="Redeem Award" ToolTip="Click here to redeem award" runat="server" ValidationGroup="grpRedeem" /></td>
                                        <td align="right">
                                            <asp:Button class="btn btn-primary btn-sm btn-sm" Width="150px" ID="btnReset" Text="Reset" ToolTip="Click here to reset the page" runat="server" /></td>
                                    </tr>
                                </table>

                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="txtRecipient"
                        ErrorMessage="You cannot redeem your own award."></asp:CustomValidator><br />
                    <asp:RequiredFieldValidator ID="valRedeemInitialsRequired" runat="server" ControlToValidate="txtRedemptionComments"
                        ErrorMessage="Redeemer's initials required." ValidationGroup="grpRedeem"></asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
