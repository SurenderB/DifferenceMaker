<%@ Control Language="C#" AutoEventWireup="false" Inherits="review" Codebehind="review.ascx.cs" %>
	<div>
		<table align="center" border="0" width="70%">
			<tr>
				<td align="left">
					<asp:Label ID="Label1" runat="server" Text="Presenter:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblPresenter" runat="server"></asp:Label>&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
					<asp:Label ID="Label2" runat="server" Text="Presenter Team:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblPresenterTeam" runat="server"></asp:Label>&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
					<asp:Label ID="Label3" runat="server" Text="Recipient:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblRecipient" runat="server"></asp:Label>&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
					<asp:Label ID="Label5" runat="server" Font-Bold="False" Font-Underline="False" Text="Recipient Team:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblRecipientTeam" runat="server"></asp:Label>&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
					<asp:Label ID="Label6" runat="server" Font-Bold="False" Font-Underline="False" Text="Recognition Amount:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblAwardAmount" runat="server"></asp:Label>
				</td>
			</tr>
			<tr id="rowAwardDescription" runat="server" visible="false">
				<td align="left">
					<asp:Label ID="Label7" runat="server" Font-Bold="False" Font-Underline="False" Text="Recognition Description:"></asp:Label>
				</td>
				<td align="left">
					<asp:Label ID="lblAwardDescription" runat="server"></asp:Label>
				</td>
			</tr>
			<tr>
				<td align="left" valign="middle">
					Date To Be Presented:
				</td>
				<td align="left" valign="middle">
					<asp:Label ID="lblDatePresented" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td align="left" colspan="100">
					<asp:Label ID="Label4" runat="server" Text="Reason:"></asp:Label>&nbsp;
					<br />
					<asp:Label ID="lblReason" runat="server" Height="64px" Width="100%"></asp:Label></td>
			</tr>
			<tr align="center">
				<td align="center" colspan="100">
					<asp:Button  class="btn btn-primary btn-sm" ID="btnReturn" runat="server" Text="Make Changes" />
                    <asp:Button class="btn btn-primary btn-sm" ID="btnSubmit" runat="server" Text="Submit Recognition" />
				</td>
			</tr>
		</table>
		&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
	</div>