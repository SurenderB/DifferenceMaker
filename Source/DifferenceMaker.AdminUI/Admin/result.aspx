<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="false" Inherits="updateSuccessful" CodeBehind="result.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAdminContent" runat="server">
    <script language="javascript" id="help">
        function showHelp() {
            help_view = window.open('<%= ConfigurationManager.AppSettings["instructionsUrl"] %>', 'help_view', 'menubar=yes,resizable=yes,width=640,height=480');
            help_view.focus();
        }
    </script>

    <div align="center" width="650px">
        <table  style="text-align:center;" width="100%">
            <tr>
                <th  style="text-align:center;" colspan="100%">
                    <h2><strong>Redemption Results</strong><hr style="height: 1px; border: none; color: #333; background-color: #333;" />
                    </h2>
                </th>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HyperLink ID="hlRedeem" runat="server" NavigateUrl="~/Admin/Redemption.aspx">Redeem another award</asp:HyperLink>
                </td>
            </tr>
        </table>
    </div>

</asp:Content>
