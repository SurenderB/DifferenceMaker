<%@ Page Language="C#" AutoEventWireup="false" Inherits="printView" Codebehind="printView.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title>Print Preview</title>
	<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<form id="form1" runat="server">

<div align="center">          
  <table align=center width="584px" border="0" cellspacing="0" cellpadding="0">
	<tr>


	</tr>
	<tr>
	  <td colspan="3" width="584"><div align="center">
	  <table width="584" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td bgcolor="#DCDAD3"><table width="584" border="0" cellspacing="6" cellpadding="1">
	  <tr>
		<td bgcolor="#FFFFFF">
		<table width="582" align=center border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td width="140"><img src="images/pv/logo.gif" width="140" height="120"></td>
			  <td width="180"><img src="images/pv/headbg.gif" width="180" height="120"></td>
			  <td width="264"><img src="images/pv/fcsa.gif" width="264" height="120"></td>
			</tr>
		</table>
					<table align=center height="100%" width="65%">
					<tr>
					<td align=center valign=top>
						<asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" BackColor="White"
							BorderColor="#3366CC" BorderStyle="None" BorderWidth="0px" CellPadding="4" DataKeyNames="Award_ID"
							DataSourceID="sql_AYB_PendingDetail" Width="85%" CaptionAlign="Left">
							<FooterStyle BackColor="#99CCCC" ForeColor="#003399" />
							<EditRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
							<RowStyle BackColor="White" ForeColor="#979590" />
							<PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
							<Fields>
								<asp:BoundField DataField="Award_ID" HeaderText="Redemption Code" InsertVisible="False"
									ReadOnly="True" SortExpression="Award_ID" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="Presenter" HeaderText="Presenter's Name" SortExpression="Presenter" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="PresenterTeam" HeaderText="Presenter's Team" SortExpression="PresenterTeam" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="Recipient" HeaderText="Recipient's Name" SortExpression="Recipient" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="RecipientTeam" HeaderText="Recipient's Team" SortExpression="RecipientTeam" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="RecipientLocation" HeaderText="Recipient's Location"
									SortExpression="RecipientLocation" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="PresentedOn" HeaderText="Date To Be Presented" SortExpression="PresentedOn" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="Reason" HeaderText="Reason" SortExpression="Reason_TX" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="RedeemedOn" HeaderText="Date Redeemed" NullDisplayText="Not Yet Redeemed"
									SortExpression="RedeemedOn" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="RedemptionLocation" HeaderText="Redemption Location"
									SortExpression="RedemptionLocation" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle HorizontalAlign="Left" />
								</asp:BoundField>
								<asp:BoundField DataField="RedemptionComment" HeaderText="Redemption Comments"
									SortExpression="RedemptionComment" >
									<ItemStyle HorizontalAlign="Left" />
									<HeaderStyle BackColor="#979590" ForeColor="White" HorizontalAlign="Left" />
								</asp:BoundField>
							</Fields>
							<HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="#CCCCFF" />
						</asp:DetailsView>
						<asp:SqlDataSource ID="sql_AYB_PendingDetail" runat="server" ConnectionString="<%$ ConnectionStrings:Entities %>"
							SelectCommand="Award_S" SelectCommandType="StoredProcedure">
							<SelectParameters>
								<asp:QueryStringParameter Name="Award_ID" QueryStringField="detailCode" Type="Int32" />
							</SelectParameters>
						</asp:SqlDataSource>
				</td>
				</tr>
				</table>
			  </td>
		   </tr>
		   </table>
		   </td>
		   </table>
		   </div>
		   </td>
		 </tr>
		 </table>
	  </div>

	</form>
</body>
</html>
