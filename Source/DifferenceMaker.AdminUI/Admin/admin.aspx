<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="false" Inherits="Admin_admin" Title="Administrative Page" CodeBehind="admin.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAdminContent" runat="Server">
    <script language="javascript" id="buttonJS">
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
                <td align="center">
                    <h2><strong>Administrative Page</strong><hr style="height:1px;border:none;color:#333;background-color:#333;"/>
                    </h2>
                </td>
            </tr>
            <tr>
                <td colspan="100" align="center">
                    <b>
                        <font size="2">Please enter a redemption code to view a recognition.</font>
                        <p></p>
                    </b>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="100%" style="height: 44px">
                    <div class="form-inline form-group">
                        <asp:Label ID="Label6" runat="server" Text="Redemption Code:"></asp:Label>
                        <asp:TextBox ID="txtRedemptionCode" runat="server" Text="" ValidationGroup="valAdminCode" Width="200px"></asp:TextBox>
                        <asp:Button ID="btnLookUp" runat="server" Text="Look Up Recognition" ValidationGroup="valAdminCode" class="btn btn-primary btn-sm btn-sm" />
                    </div>
                    
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter a redemption code." ControlToValidate="txtRedemptionCode"></asp:RequiredFieldValidator><br />

    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="The redemption code must be a numeric value." ClientValidationFunction="isCodeNumeric" ControlToValidate="txtRedemptionCode" ValidationGroup="valAdminCode"></asp:CustomValidator></td>
            </tr>
            <p></p>
    <tr>
        <td align="center" colspan="100%" width="100%">  
            <asp:Table ID="tblAdmin" runat="server" Visible="false" Enabled="false" Style="width:100%; margin: auto">
                <asp:TableRow ID="trDetail" runat="server">
                    <asp:TableCell ID="tcDetail" runat="server">
                    <%--    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" BackColor="White"
                            BorderColor="#3366CC" BorderStyle="None" BorderWidth="0px" CellPadding="4" DataKeyNames="ayb_AtYourBest_SV"
                            DataSourceID="sql_AYB_Detail" Width="85%" CaptionAlign="Left"  Style=" margin: auto">--%>
                            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" BackColor="White"
                            BorderColor="#3366CC" BorderStyle="None" BorderWidth="0px" CellPadding="4" DataKeyNames="Award_ID"
                            Width="85%" CaptionAlign="Left"  Style=" margin: auto">
                            <FooterStyle BackColor="#99CCCC" ForeColor="#003399" />
                            <EditRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
                            <RowStyle BackColor="White" ForeColor="#979590" />
                            <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
                            <Fields>
                                <asp:BoundField DataField="Award_ID" HeaderText="Redemption Code" InsertVisible="False"
                                    ReadOnly="True" SortExpression="Award_ID">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Presenter" HeaderText="Presenter's Name" SortExpression="Presenter">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PresenterTeam" HeaderText="Presenter's Team" SortExpression="PresenterTeam">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Recipient" HeaderText="Recipient's Name" SortExpression="Recipient">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RecipientTeam" HeaderText="Recipient's Team" SortExpression="RecipientTeam">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RecipientLocation" HeaderText="Recipient's Location"
                                    SortExpression="RecipientLocation">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PresentedOn" HeaderText="Date To Be Presented" SortExpression="PresentedOn">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Reason" HeaderText="Reason" SortExpression="Reason">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RedeemedOn" HeaderText="Date Redeemed" NullDisplayText="Not Yet Redeemed"
                                    SortExpression="RedeemedOn">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RedemptionLocation" HeaderText="Redemption Location"
                                    SortExpression="RedemptionLocation">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RedemptionComment" HeaderText="Redemption Comments"
                                    SortExpression="RedemptionComment">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
                                </asp:BoundField>
                            </Fields>
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="#CCCCFF" />
                        </asp:DetailsView>
      
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="trButtons" runat="server">
                    <asp:TableCell ID="tcButtons" runat="server">
                                <table  Style="border-spacing: 5px; border-collapse: separate; width: 100%">
                            <tr>
                                <td align="right">
                                    <asp:Button ID="btnDelete" runat="server" Text="Remove Recognition" class="btn btn-primary btn-sm btn-sm" />
                                </td>
                                <td align="left">

                                    <asp:Button ID="btnReset" runat="server" Text="Reset" class="btn btn-primary btn-sm btn-sm" />
                                </td>
                            </tr>
                        </table>
                    </asp:TableCell>
                </asp:TableRow>

            </asp:Table>

        </td>
    </tr>
    </table>
    </div>

</asp:Content>

