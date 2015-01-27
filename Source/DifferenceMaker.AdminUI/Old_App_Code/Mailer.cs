using System;
using System.Configuration;

public class Mailer
{

	//**********************************************
	//*  Class Name:  Mailer
	//*  Description: Methods and properties used to send email to ConfigurationManager.AppSettings("MailBox")
	//****Private VARIABLES****
	//*  _RecipientMailAddress   -address to mail to
	//*  _SenderMailAddress      -address of the mailer
	//*  _subject                -subject of the mail message
	//*  _message                -message to be mailed
	//*********************************************
	private string _RecipientMailAddress = ConfigurationManager.AppSettings["MailBox"];
	private string _SenderMailAddress = "";
	private string _subject = "";
	private string _message;

	/// <summary>
	/// Sends an email.
	/// </summary>
	/// <param name="mailFrom">From address.</param>
	/// <param name="mailTo">Recipient address(es) - delimited by semicolons.</param>
	/// <param name="mailCC">CC address(es) - delimited by semicolons.</param>
	/// <param name="mailSubject">Email subject.</param>
	/// <param name="mailBody">Email body.</param>
	/// <param name="isBodyHTML">Set to True if body is HTML, False otherwise.</param>
	public static string SendEmail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, bool isBodyHTML)
	{
		System.Net.Mail.SmtpClient mailObj = new System.Net.Mail.SmtpClient();
		mailObj.Host = ConfigurationManager.AppSettings["SMTPServer"];

		System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();
		msg.From = new System.Net.Mail.MailAddress(mailFrom);

		string[] toPeops = mailTo.Split(";,".ToCharArray());
		string[] ccPeops = mailCC.Split(";,".ToCharArray());

		// Add recipients (TO)
		if (! (string.IsNullOrEmpty(mailTo)))
		{
			foreach (string mailAddr in toPeops)
			{
				msg.To.Add(new System.Net.Mail.MailAddress(mailAddr));
			}
		}

		// Add CC's
		if (! (string.IsNullOrEmpty(mailCC)))
		{
			foreach (string mailAddr in ccPeops)
			{
				msg.CC.Add(new System.Net.Mail.MailAddress(mailAddr));
			}
		}

		msg.Subject = mailSubject;
		msg.Body = mailBody;
		msg.Priority = System.Net.Mail.MailPriority.Normal;
		msg.IsBodyHtml = isBodyHTML;

		try
		{
			mailObj.Send(msg);

			return "Successful";
		}
		catch (Exception ex)
		{
			return ex.Message;
		}
	}

	//**********************************************
	//*  Property Name: MessageBody()
	//*  Description:            -gets or sets _message
	//**********************************************
	public string MessageBody
	{
		get
		{
			return _message;
		}
		set
		{
			_message = value;
		}
	}

	//**********************************************
	//*  Property Name: Sender()
	//*  Description:            -gets or sets _SenderMailAddress
	//*********************************************
	public string Sender
	{
		get
		{
			return _SenderMailAddress;
		}
		set
		{
			_SenderMailAddress = value;

		}
	}


	//*********************************************
	//*  Property Name: Subject()
	//*  Description:            -gets or sets _subject
	//*********************************************
	public string Subject
	{
		get
		{
			return _subject;
		}
		set
		{
			_subject = value;
		}
	}

	//********************************************
	//*  Property Name: Recipient()
	//*  description            -gets or sets _RecipientMailAddress
	//********************************************
	public string Recipient
	{
		get
		{
			return _RecipientMailAddress;
		}
		set
		{
			_RecipientMailAddress = value;

		}

	}

	//**********************************************
	//*  Name:   New (sender, recipient, subject, strMessage)
	//*  Description: Constructor that assigns all 4 private variables
	//****Private VARIABLES****
	//*  _RecipientMailAddress   -address to mail to
	//*  _SenderMailAddress      -address of the mailer
	//*  _subject                -subject of the mail message
	//*  _message                -message to be mailed
	//*********************************************
	public Mailer(string sender, string recipient, string subject, string strMessage)
	{
		_SenderMailAddress = (string)sender;
		_RecipientMailAddress = recipient;
		_subject = subject;
		_message = strMessage;

	}


	//**********************************************
	//*  Name:   New (sender, subject, strMessage)
	//*  Description: Constructor that assigns sender, subject, and mesage, leaving the default recipient
	//****Private VARIABLES****
	//*  _SenderMailAddress      -address of the mailer
	//*  _subject                -subject of the mail message
	//*  _message                -message to be mailed
	//*********************************************
	public Mailer(string sender, string subject, string message)
	{
		_SenderMailAddress = (string)sender;
		_subject = subject;
		_message = message;
	}
	//**********************************************
	//*  Name:   New ()
	//*  Description: Default Constructor
	//*********************************************
	public Mailer()
	{

	}

	//**********************************************
	//*  Name:   MailMessage()
	//*  Description: Function that sends the email
	//****VARIABLES****
	//*  mailObj                 -Mail object
	//*  MessageToMail           -Message to mail of type System.Net.Mail.MailMessage
	//*********************************************

	public string MailMessage()
	{
		Mailer.SendEmail(_SenderMailAddress, _RecipientMailAddress, string.Empty, _subject, _message, true);

		return "Successful";
	}

}
