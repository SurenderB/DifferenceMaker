using System.Web.UI.WebControls;

partial class Admin_Admin_Master : System.Web.UI.MasterPage
{

//ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
	override protected void OnLoad(System.EventArgs e)
	{
		base.OnLoad(e);
		HyperLink hlHelp = this.hlHelp;
		hlHelp.Attributes.Add("onclick", "showRedemptionHelp()");
		if ((Page.ToString() == "ASP.admin_redemption_aspx") || (Page.ToString() == "ASP.admin_result_aspx"))
		{
			hlHelp.Text = "Redemption Help";
		}
		else if (Page.ToString() == "ASP.admin_reporting_aspx")
		{
			hlHelp.Text = "Reporting Help";
		}
		else if ((Page.ToString() == "ASP.admin_admin_aspx") || (Page.ToString() == "ASP.admin_adminresult_aspx"))
		{
			hlHelp.Text = "Administrative Help";
		}
	}
}

