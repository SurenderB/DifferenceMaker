using System;
using System.Configuration;
using System.Web.UI.WebControls;

partial class Controls_fail : System.Web.UI.UserControl
{

	//**********************************************
	//*  Name: Page_PreRender
	//*  Description: Handles the logic for rendering the page if the submission had an error.
	//****VARIABLES****
	//*  errorMsg        -variable for holding the error message
	//*  Label1          -label on page for holding errorMsg
	//*  mailMsg         -object of custom class 'Mailer' for sending the error message.
	//***Session Variables ***
	//*  userLevelError  -An error to be displayed to the user
	//*  errorMsg        -An error with technical details to be sent in email
	//*********************************************    
    override protected void OnInit(EventArgs e)
	{
		base.OnInit(e);

		LinkButton1.Click += new System.EventHandler(LinkButton1_Click);
	}

//ORIGINAL LINE: Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.PreRender
	override protected void OnPreRender(System.EventArgs e)
	{
		base.OnPreRender(e);
		string errorMsg = null;

        if (SessionHelper.GetValue<string>(Session["userLevelError"]) == default(string))
		{
			errorMsg = "An error has occured.  Please contact technical support.";
		}
		else
		{
            errorMsg = SessionHelper.GetValue<string>(Session["userLevelError"]);
		}

		Label1.Text = errorMsg;

		Mailer mailMsg = new Mailer();

        mailMsg.Sender = ConfigurationManager.AppSettings["emailFromAddress"];

		mailMsg.Subject = "Recognition System Error";


		mailMsg.MessageBody = "An error has occured with the recognition system.  <br /><br />";
		mailMsg.MessageBody += "Time: " + System.DateTime.Now + "<br /><br />";
		mailMsg.MessageBody += "Details: <br /> --- <br />";



        if (SessionHelper.GetValue<string>(Session["errorMsg"]) != default(string))
		{
			//Me.Label1.Text = Session("errorMsg")

            mailMsg.MessageBody += SessionHelper.GetValue<string>(Session["errorMsg"]);

		}
		else
		{
			mailMsg.MessageBody += "There are no details available.";
		}



		string result = mailMsg.MailMessage();


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
		View vLogForm = (View) mvLogging.FindControl("LogForm");

		mvLogging.SetActiveView(vLogForm);
	}
}
