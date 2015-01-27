using System;
using System.Text;
using System.Web.UI.WebControls;

partial class Controls_success : System.Web.UI.UserControl
{

#region  Event Handlers... 
	//**********************************************
	//*  Name: Page_Load
	//*  Description: Handles the logic for the logging user control
	//****VARIABLES****
	//*  Label1              -variable for a label
	//**** Session Variables ****
	//*  seedValue           -variable for the record id
	//*********************************************    
    override protected void OnInit(EventArgs e)
	{
		base.OnInit(e);

		LinkButton1.Click += new System.EventHandler(LinkButton1_Click);
	}

//ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
	override protected void OnLoad(System.EventArgs e)
	{
		base.OnLoad(e);
		// Only display the print link if the user select a $25 "at your best" award
        if (SessionHelper.GetValue<bool>(Session["IsAtYourBest"]))
		{
			this.rowPrintAward.Visible = true;
		}
		else
		{
			this.rowPrintAward.Visible = false;
		}
	}
	//**********************************************
	//*  Name: Page_PreRender
	//*  Description: Handles the logic for rendering the page if the submission occured successfully
	//****VARIABLES****
	//*  lnkBtnPrint     -local handle for LinkButton2
	//*  Label1          -label on page for holding Redemption Code
	//***Session Variables ***
	//*  seedValue       -Holds the redemption code
	//*  Record_Submitted-Boolean to let application know that the record was submitted successfully
	//*********************************************
//ORIGINAL LINE: Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.PreRender
	override protected void OnPreRender(System.EventArgs e)
	{
		base.OnPreRender(e);
		LinkButton lnkBtnPrint = (LinkButton) this.FindControl("LinkButton2");

		StringBuilder strBuilder = new StringBuilder();




        if (SessionHelper.GetValue<string>(Session["seedValue"]) != default(string))
		{

			//Always say your award was submitted
			strBuilder.Append("Your recognition was submitted successfully. </br><br/>");


			Session["Record_Submitted"] = true;
			//Me.Label1.Text = Session("seedValue").ToString
            lnkBtnPrint.Attributes.Add("onClick", "showPrintView(" + SessionHelper.GetValue<string>(Session["seedValue"]) + ")");
			lnkBtnPrint.Attributes.Add("onmouseover", "mouseOver(this)");

			//If there was an an other amount instruct the user to fill out an expense report
            if (SessionHelper.GetValue<bool>(Session["IsOtherAmount"]))
			{


                //strBuilder.Append("<h3 style='color:Red'>Please fill out a Business Expense Report for the amount of " + SessionHelper.GetValue<decimal>(Session["AwardAmount"]).ToString("$##0.00") + " for the item: " + SessionHelper.GetValue<string>(Session["AwardDescription"]) + ". <br>In the BER system use the expense description \"Recognition Awards (Leader Use Only)\" </h3>");
                strBuilder.Append("<h3 style='color:Red'>If you need to be reimbursed for the purchase of the other recognition item, " +
                    "please fill out a Business Expense Report (BER) for the amount of " + SessionHelper.GetValue<decimal>(Session["AwardAmount"]).ToString("$##0.00") + 
                    " for the item: " + SessionHelper.GetValue<string>(Session["AwardDescription"]) + 
                    ". <br>In the BER system select Misc Account Type \"Recognition Awards (Leader Use Only)\" " +
                    "and enter the recipient or team name in the Expense Description.</h3>");
			}
			else
			{

				//Only amounts at your best should be instructed to print the award
                if (SessionHelper.GetValue<bool>(Session["IsAtYourBest"]))
				{
                    strBuilder.Append("The redemption code for this recognition is:<b>" + SessionHelper.GetValue<string>(Session["seedValue"]) + "</b> <br/><br/>Please print the certificate, place it inside of an recognition card, and present it to the recipient.");
				}
				else
				{
					strBuilder.Append("<h3 style='color:black'> An email has been sent to Accounts Payable. A check will be printed in the recipients name and mailed to you. </h3>");
				}

			}

		}
		else
		{
			//Me.Label1.Text = "Unknown"
		}

		litInstructions.Text = strBuilder.ToString();

	}

	//**********************************************
	//*  Name: LinkButton1_Click
	//*  Description: Handles the logic for LinkButton1 being clicked
	//****VARIABLES****
	//*  mvLogging               -local handle of the multiview on loggingform.ascx
	//*  vLogForm                -local handle for the view "LogForm"
	//*********************************************
	protected void LinkButton1_Click(object sender, System.EventArgs e)
	{
		MultiView mvLogging = (MultiView) this.Parent.FindControl("mvGiveAnAward");
		View vLogForm = (View) mvLogging.FindControl("logForm");

		mvLogging.SetActiveView(vLogForm);

	}
	//'**********************************************
	//'*  Name: LinkButton2_Click
	//'*  Description: Loads print view and resets page to submit an award view.
	//'*********************************************
	//Protected Sub LinkButton2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LinkButton2.Click
	//    LinkButton1_Click(sender, e)
	//End Sub
#endregion

}
