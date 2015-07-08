using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Http;
using System.Text;
using System.Web.UI.WebControls;

using FCSAmerica.DifferenceMaker.Models;

partial class review : System.Web.UI.UserControl
{
    //**********************************************
    //*  Name: Page_Load
    //*  Description: Handles the logic for the logging user control
    //****VARIABLES****
    //*  lblPresenter    -variable for holding presenter's name
    //*  lblPresenterTeam-variable for holding presenter's team name
    //*  lblRecipient    -variable for holding recipient's name
    //*  lblRecipientTeam-variable for holding recipient's team name
    //*  lblDatePresented-variable for holding date presented
    //*  lblReason       -variable for holding the reason for the award
    //*********************************************
    override protected void OnInit(EventArgs e)
    {
        base.OnInit(e);

        btnReturn.Click += new System.EventHandler(btnReturn_Click);
        btnSubmit.Click += new System.EventHandler(btnSubmit_Click);
    }

    //ORIGINAL LINE: Protected Sub Page_PreRender(ByVal Sender As Object, ByVal e As System.EventArgs) Handles this.PreRender
    override protected void OnPreRender(System.EventArgs e)
    {
        base.OnPreRender(e);

        this.lblPresenter.Text = SessionHelper.GetValue<string>(Session["Presenter_Name"]);
        this.lblPresenterTeam.Text = SessionHelper.GetValue<string>(Session["Presenter_Team"]);
        this.lblRecipient.Text = SessionHelper.GetValue<string>(Session["Recipient_Name"]);
        this.lblRecipientTeam.Text = SessionHelper.GetValue<string>(Session["Recipient_Team"]);
        this.lblDatePresented.Text = Session["Date_Presented"].ToString();
        this.lblReason.Text = SessionHelper.GetValue<string>(Session["Reason"]);
        this.lblAwardAmount.Text = SessionHelper.GetValue<decimal>(Session["AwardAmount"]).ToString("c");

        if (SessionHelper.GetValue<bool>(Session["IsOtherAmount"]))
        {
            this.rowAwardDescription.Visible = true;
            this.lblAwardDescription.Text = SessionHelper.GetValue<string>(Session["AwardDescription"]);
        }
        else
        {
            this.lblAwardDescription.Text = string.Empty;
        }

    }

    //**********************************************
    //*  Name: btnReturn_Click
    //*  Description: Returns to logging page
    //****VARIABLES****
    //*  webTab          -local handle of UltraWebTab on main page
    //*  loggingTab      -local handle for current logging tab
    //*  newPage         -variable holding location to logging page
    //*********************************************
    protected void btnReturn_Click(object sender, System.EventArgs e)
    {

        MultiView mvLogging = null;
        View loggingActiveView;

        try
        {
            mvLogging = (MultiView)this.Parent.FindControl("mvGiveAnAward");
            loggingActiveView = (View)mvLogging.FindControl("logForm");
            mvLogging.SetActiveView(loggingActiveView);

        }
        catch (Exception)
        {
        }
    }
    //**********************************************
    //*  Name: btnSubmit_Click
    //*  Description: Handles the logic if the submit button is clicked
    //****VARIABLES****
    //*  webTab          -local handle of UltraWebTab on main page
    //*  loggingTab      -local handle for current logging tab
    //*********************************************
    protected void btnSubmit_Click(object sender, System.EventArgs e)
    {
        MultiView mvLogging = null;
        View loggingActiveView = new View();

        mvLogging = (MultiView)this.Parent.FindControl("mvGiveAnAward");
        string newPage = null;

        if (!SessionHelper.GetValue<bool>(Session["Record_Submitted"]))
        {
            try
            {
                // Insert record into database
                //sqlAYB_Insert.Insert();
                var responseMessage = InsertRecognitionDetail();

                //string seedValue = null;
                //SqlCommand command = null;
                //MultiView mvLogging = null;
                //View loggingActiveView = new View();

                if (responseMessage.IsSuccessStatusCode)
                {
                    // Send email to accounts payable if award is any award type other than $25.00
                    SendAccountsPayableEmail();

                   // seedValue = command.Parameters["@Award_ID"].Value.ToString();
                    var insertedRedemptionDetail = responseMessage.Content.ReadAsAsync<RecognitionInsertDto>().Result;
                    if (insertedRedemptionDetail != null)
                    {
                       Session["seedValue"]= insertedRedemptionDetail.Award_Id.ToString();
                    }
                    newPage = "success";
                }
                else
                {
                    //If there was a problem adding the record, go to fail page
                    Session["errorMsg"] = responseMessage.ReasonPhrase;
                    newPage = "fail";
                }

                loggingActiveView = (View)mvLogging.FindControl(newPage);
                mvLogging.SetActiveView(loggingActiveView);

            }
            catch (Exception ex)
            {

            }
        }
    }

    private HttpResponseMessage InsertRecognitionDetail()
    {
        var response = new HttpResponseMessage();
        try
        {
            using (var client = new HttpClient())
            {
                var url = "redemption/insertRedemption/";
                client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
                var recognitionDetail = GetToBeInsertedRecognitionDetail();
                //return client.PostAsJsonAsync(url, recognitionDetail).Result;
                try
                {
                    response = client.PostAsJsonAsync(url, recognitionDetail).Result;
                }
                catch (HttpRequestException httpEx)
                {
                    response.ReasonPhrase = httpEx.Message;
                }
            }
        }
        catch (Exception ex)
        {
            //var badResponse = request.CreateResponse(HttpStatusCode.BadRequest);
            //badResponse.ReasonPhrase = "include ex.StackTrace here just for debugging";
        }
        return response;
    }

    private RecognitionInsertDto GetToBeInsertedRecognitionDetail()
    {
        var awardAmt = SessionHelper.GetValue<decimal>(Session["AwardAmount"]);
        var date = SessionHelper.GetValue<string>(Session["Date_Presented"]);
        DateTime datePresented = Convert.ToDateTime(date);
        var currentUser = Session["currentUser_EmpID"];
        //var recipientId = this.GetEmployeeId(SessionHelper.GetValue<string>(Session["Recipient_Name"]));
        var recipientId = SessionHelper.GetValue<string>(Session["Recipient_SV"]);
        var isAyb = SessionHelper.GetValue<bool>(Session["IsAtYourBest"]);

        var reason = Session["Reason"];
        var recognitionDetail = new RecognitionInsertDto()
            {
                Presenter_Emp_SV = SessionHelper.GetValue<int>(currentUser),
                Recipient_Emp_SV = Convert.ToInt32(recipientId),
                DatePresented_DT = datePresented,
                Reason_TX = SessionHelper.GetValue<string>(reason),
                IsAYB_yn = isAyb,
                AwardAmt_cur = awardAmt,
                Description_tx = lblAwardDescription.Text
            };
        return recognitionDetail;
    }

    /// <summary>
    /// Sends an email to accounts payable.
    /// </summary>
    private void SendAccountsPayableEmail()
    {
        string mailFrom = ConfigurationManager.AppSettings["APMailFrom"].ToString();
        string mailTo = ConfigurationManager.AppSettings["APMailTo"].ToString();
        string mailCC = string.Empty;
        string mailSubject = null;
        StringBuilder mailBody = new StringBuilder();

        if (SessionHelper.GetValue<bool>(Session["IsOtherAmount"]) || SessionHelper.GetValue<decimal>(Session["AwardAmount"]) != 25M)
        {
            // Get the presenters leader
            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entities"].ToString());
            cn.Open();

            SqlCommand cmd = new SqlCommand("Leader_OfEmployee", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("Employee_ID", SqlDbType.Int).Value = SessionHelper.GetValue<int>(Session["currentUser_EmpID"]);

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            DataSet dsSupervisor = new DataSet();
            da.Fill(dsSupervisor);

            cn.Close();

            // Set CC to supervisor's email
            if (dsSupervisor.Tables.Count > 0)
            {
                if (dsSupervisor.Tables[0].Rows.Count > 0)
                {
                    mailCC = (string)dsSupervisor.Tables[0].Rows[0]["LeaderEmail"];
                }
            }

            if (SessionHelper.GetValue<bool>(Session["IsOtherAmount"]))
            {
                // Award is an "other" award
                mailSubject = "Other Recognition Award - " + SessionHelper.GetValue<string>(Session["Recipient_Name"]);
            }
            else
            {
                // Award is $100, $175 or $250
                mailSubject = "Recognition - " + SessionHelper.GetValue<string>(Session["Recipient_Name"]);
            }

            mailBody.Append("<table border=\"0\">");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Recipient Name:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(SessionHelper.GetValue<string>(Session["Recipient_Name"]));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Recognition Description:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(SessionHelper.GetValue<string>(Session["AwardDescription"]));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Recognition Cost:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(SessionHelper.GetValue<decimal>(Session["AwardAmount"]).ToString("c"));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Description:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(System.DateTime.Now.ToString("MM/dd/yyyy"));
            mailBody.Append(" ");
            mailBody.Append(SessionHelper.GetValue<string>(Session["Recipient_Name"]));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Reason:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(SessionHelper.GetValue<string>(Session["Reason"]));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("<tr>");
            mailBody.Append("<td>");
            mailBody.Append("<strong>Recognition Purchaser:</strong> ");
            mailBody.Append("</td>");
            mailBody.Append("<td>");
            mailBody.Append(SessionHelper.GetValue<string>(Session["Presenter_Name"]));
            mailBody.Append("</td>");
            mailBody.Append("</tr>");
            mailBody.Append("</table>");

            // Send the email
            Mailer.SendEmail(mailFrom, mailTo, mailCC, mailSubject, mailBody.ToString(), true);
        }
    }
    }
