<%@ Control Language="C#" AutoEventWireup="false"
    Inherits="Controls_loggingForm" CodeBehind="loggingForm.ascx.cs" %>

<script>
    $(function () {
        $("[jsid='webCalendarPresented']").datepicker();
    });
</script>
<script language="javascript" id="scriptsJS">
    function NamesValidator(source, args) {
        var txtPresenter = document.getElementById("TabLogging1_giveAward_txtRecipientTeam");
        var ddlRecipient = document.getElementById(source.controltovalidate);

        var ddlRecip_txt = ddlRecipient.options[ddlRecipient.selectedIndex].text;
        var txtPresenter_txt = txtPresenter.value;

        if (ddlRecip_txt == txtPresenter_txt) {
            args.IsValid = false;
        }
        else {
            args.IsValid = true;
        }
    }
</script>

<table align="center" border="0" width="85%" style="border-spacing: 5px; border-collapse: separate;">
    <tr>
        <th align="center" colspan="100%" style="height: 21px">Give A Recognition
        </th>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="Label1" runat="server" Text="Presenter:"></asp:Label>
        </td>
        <td align="left">
            <asp:TextBox ID="txtPresenter" runat="server" Width="200px" ReadOnly="True" CausesValidation="True"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valPresenter" runat="server" ControlToValidate="txtPresenter"
                ErrorMessage="A presenter is required." Display="Dynamic" EnableClientScript="False">*</asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="Label2" runat="server" Text="Presenter Team:"></asp:Label>
        </td>
        <td align="left">
            <asp:TextBox ID="txtPresenterTeam" runat="server" Width="200px" ReadOnly="True"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td align="left" style="height: 24px">
            <asp:Label ID="Label3" runat="server" Text="Recipient:"></asp:Label>
        </td>
        <td align="left" style="height: 24px">
            <asp:DropDownList ID="ddlRecipient" runat="server" AutoPostBack="True"
                CausesValidation="True" AppendDataBoundItems="True">
            </asp:DropDownList>
            <asp:CustomValidator ID="valRecipient" runat="server" ClientValidationFunction="NamesValidator"
                ErrorMessage="The Presenter and Recipient cannot be the same person." ControlToValidate="ddlRecipient"
                Display="Dynamic" EnableClientScript="True">*</asp:CustomValidator>
            <asp:RequiredFieldValidator ID="valRequired" runat="server" ControlToValidate="ddlRecipient"
                ErrorMessage="A Recipient is required." InitialValue="-1" Display="Dynamic" EnableClientScript="False">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="Label5" runat="server" Font-Bold="False" Font-Underline="False" Text="Recipient Team:"></asp:Label>
        </td>
        <td align="left">
            <asp:TextBox ID="txtRecipientTeam" runat="server" Width="200px" ReadOnly="True"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td align="left">
            <asp:Label ID="lblAward" runat="server" Font-Bold="False" Font-Underline="False"
                Text="Amount:"></asp:Label>
        </td>
        <td align="left">
            <asp:DropDownList ID="cmbAward" runat="server" AutoPostBack="True">
            </asp:DropDownList>
        </td>
    </tr>
    <tr id="rowOtherAwardAmount" runat="server" visible="false">
        <td align="left">
            <asp:Label ID="lblOtherAmount" runat="server" Text="Other Amount:"></asp:Label>
        </td>
        <td align="left">
            <asp:TextBox ID="txtOtherAmount" runat="server" Width="80px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="OtherAmountRequiredFieldValidator" runat="server"
                ControlToValidate="txtOtherAmount" Display="Dynamic" ErrorMessage='Enter an "other" amount.'
                EnableClientScript="False">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ID="OtherAmountRangeValidator" runat="server" ControlToValidate="txtOtherAmount"
                Display="Dynamic" ErrorMessage='"Other" amount must be between 1 and 5,000 - no dollar sign ($).'
                MaximumValue="5000" MinimumValue="1" Type="Currency" EnableClientScript="False">*</asp:RangeValidator>
        </td>
    </tr>
    <tr id="rowAwardDescription" runat="server" visible="false">
        <td align="left">
            <asp:Label ID="lblAwardDescription" runat="server" Text="Recognition Description:"></asp:Label>
        </td>
        <td align="left">
            <asp:TextBox ID="txtAwardDescription" runat="server" Width="200px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AwardDescRequiredFieldValidator" runat="server" ControlToValidate="txtAwardDescription"
                Display="Dynamic" ErrorMessage="Enter a recognition description." EnableClientScript="False">*</asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <td align="left" valign="middle">Date To Be Presented:<b style="color: Red; float: right;">***</b>
        </td>
        <td align="left" valign="middle">
            <input type="text" id="webCalendarPresented" jsid="webCalendarPresented" runat="server" />
        </td>
    </tr>
    <tr>
        <td align="left" colspan="100">
            <asp:Label ID="Label4" runat="server" Text="Reason:"></asp:Label>&nbsp;<br />
            <asp:DropDownList ID="ddlReason" runat="server" Width="335px" AutoPostBack="True">
            </asp:DropDownList>
            <asp:Label ID="lblAwardReasonDescription" runat="server" Text="" Visible="false" Width="335px"></asp:Label>&nbsp;<br />
        </td>
    </tr>
    <tr>
        <td align="left" colspan="100%">
            <asp:Label ID="Label6" runat="server" Text="Please Specify:" Visible="false"></asp:Label>&nbsp;<br />
            <asp:TextBox ID="txtOther" runat="server" Width="312px" Visible="False"></asp:TextBox><br />

        </td>



    </tr>
    <tr align="center">
        <td align="center" colspan="100" style="height: 83px">
            <asp:Button class="btn btn-primary btn-sm" ID="btnSubmit" runat="server" Text="Submit" />
            <asp:Button class="btn btn-primary btn-sm" ID="btnReset" runat="server" Text="Reset" ValidationGroup="grpReset" /><br />
            &nbsp;
			<br />
            <asp:ValidationSummary ID="AwardValidationSummary" runat="server" DisplayMode="List" />
            <br />
            <br />
            <b style="color: Red">*** Date To Be Presented is the date the employee will be able to see the recognition in the system.</b>
            <br />
            <br />
        </td>
    </tr>
</table>
