using System;
using System.Configuration;

partial class updateSuccessful : System.Web.UI.Page
{

	//**********************************************
	//*  Name:   Page_Load
	//*  Description: If there's an error, send an email and display a message to the user.  Otherwise, show success message
	//***SESSION VARIABLES***
	//*  userMsg                     -Message to be displayed to the user if there's an error
	//*  errorMsg                    -Error Message with detailed information about the exception to be sent in email
	//*  Award_Redeemed              -Boolean that lets the application know that the process is complete.
	//*********************************************

//ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
	override protected void OnLoad(System.EventArgs e)
	{
		base.OnLoad(e);
		if (Request.QueryString["result"] != null)
		{
			if (Request.QueryString["result"] == "success")
			{
				this.Label1.Text = "The award was redeemed successfully.";
			}
			else if (Request.QueryString["result"] == "fail")
			{
				//Me.Label1.Text = "There was an error in the redemption process.  Please contact the local administrator."
				try
				{
                    if (SessionHelper.GetValue<string>(Session["userMsg"]) != default(string))
					{
                        this.Label1.Text = SessionHelper.GetValue<string>(Session["userMsg"]);
					}
					else
					{
						this.Label1.Text = "There was an error with your request.  Please contact technical support.";
					}


					//mail a detailed message to the admin in charge.
                    if (SessionHelper.GetValue<string>(Session["errorMsg"]) != default(string))
					{
						MailMessage();
					}
				}
				catch (Exception)
				{


				}

			}
			else
			{
				this.Label1.Text = "There is no result information to review.";

			}
		}
		else
		{
			this.Label1.Text = "There is no result information to review.";
		}

		Session["Award_Redeemed"] = true;

	}

	//**********************************************
	//*  Name:   MailMessage()
	//*  Description: Mails an error message to user in 'MailBox,' defined in web.config
	//***VARIABLES***
	//*  mailMsg                     -Object of custom type Mailer used to send message
	//*  result                      -result of the mail being sent
	//*********************************************
	protected void MailMessage()
	{

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
}
