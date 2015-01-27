using System;

//***********************************************
//   Program Name:  AYB_Tracking
//   Page: logging.ascx.vb
//   Programmed By: Jameson Bridges
//   Date: 10-09-2006
//   Description: Displays the a+ your best logging screen.
//***********************************************

partial class logging : System.Web.UI.UserControl
{    override protected void OnInit(EventArgs e)
	{
		base.OnInit(e);

        //mvPending.ActiveViewChanged += new System.EventHandler(mvPending_ViewChanged);
	}

	protected void mvPending_ViewChanged(object sender, System.EventArgs e)
	{

	}



//ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
	override protected void OnLoad(System.EventArgs e)
	{
		base.OnLoad(e);

	}
}
