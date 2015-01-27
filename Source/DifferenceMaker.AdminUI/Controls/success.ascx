<%@ Control Language="C#" AutoEventWireup="false" Inherits="Controls_success" Codebehind="~/Controls/success.ascx.cs" %>
<table style="text-align:left;">
	<tr>
		<td style="font-style:italic; font-size:x-large;">
			Success!
			<hr />            
		</td>
	</tr>   
	<tr>
		<td>
			<asp:Literal ID="litInstructions" runat="server"></asp:Literal>            
		</td>
	</tr>
	<tr id="rowPrintAward" runat="server" visible="false">
		<td>
			<br />
			<asp:LinkButton ID="LinkButton2" runat="server">Print The Recognition</asp:LinkButton>
		</td>
	</tr>
	<tr>
		<td>
		<br />
			<asp:LinkButton ID="LinkButton1" runat="server">Submit Another Recognition</asp:LinkButton>
		</td>
	</tr>

</table>
