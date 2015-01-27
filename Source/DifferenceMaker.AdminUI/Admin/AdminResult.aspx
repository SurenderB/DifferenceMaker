<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="false" Inherits="_Admin_AdminResult" CodeBehind="AdminResult.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAdminContent" runat="server">
    <script language="javascript" id="help">
        function showHelp() {
            help_view = window.open('<%= ConfigurationManager.AppSettings["instructionsUrl"] %>', 'help_view', 'menubar=yes,resizable=yes,width=640,height=480');
            help_view.focus();
        }
    </script>

    <div align="center">
        <table style="text-align:center;" width="100%">
            <tr>
                <th style="text-align:center;" colspan="100%">
                    <h2><strong>Administrative Results</strong><hr style="height: 1px; border: none; color: #333; background-color: #333;" />
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
                    <asp:HyperLink ID="hlAdmin" runat="server" NavigateUrl="~/Admin/Admin.aspx">Review another recognition</asp:HyperLink>
                </td>
            </tr>
        </table>
    </div>

</asp:Content>
