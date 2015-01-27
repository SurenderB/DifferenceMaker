#region  Imports...

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Web;

using DataAccess;

using FCSAmerica.DifferenceMaker;

#endregion

partial class Admin_admin : System.Web.UI.Page
{

    #region  Event Handlers...
    //**********************************************
    //*  Name: btnLookUp_Click
    //*  Description: Handles the logic if the btnLookUp button is clicked
    //****VARIABLES****
    //*  sqlDetail       -local handle of sql_AYB_Detail
    //*********************************************    
    override protected void OnInit(EventArgs e)
    {
        base.OnInit(e);

        btnLookUp.Click += new System.EventHandler(btnLookUp_Click);
        btnDelete.Click += new System.EventHandler(btnDelete_Click);
        btnReset.Click += new System.EventHandler(btnReset_Click);
        CustomValidator1.ServerValidate += new System.Web.UI.WebControls.ServerValidateEventHandler(CustomValidator1_ServerValidate);
    }

    protected void btnLookUp_Click(object sender, System.EventArgs e)
    {
        using (var client = new HttpClient())
        {
            var requestUri = "admin/viewRecognition/";
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            HttpResponseMessage responseMessage = client.GetAsync(requestUri + txtRedemptionCode.Text).Result;
            if (responseMessage.IsSuccessStatusCode)
            {
                var awardRedemptionDetail = responseMessage.Content.ReadAsAsync<List<Award_S_Result>>().Result;
                if (awardRedemptionDetail != null)
                {
                    DetailsView1.DataSource = awardRedemptionDetail;
                    DetailsView1.DataBind();
                    //Otherwise, show admin panel
                    this.tblAdmin.Enabled = true;
                    this.tblAdmin.Visible = true;
                }
                else
                {
                    //If there is no redemption code, display error
                    Session["userMsg"] = "There is no recognition with that redemption code.";
                    Response.Redirect("AdminResult.aspx?result=fail");
                }
            }
            else
            {
                //If there was an error in the select() Method, display error
                Session["userMsg"] = "There was an error with your request.  Please contact technical support.";
                Session["errorMsg"] = responseMessage.StatusCode;
                Response.Redirect("AdminResult.aspx?result=fail");
            }
        }
    }

    //**********************************************
    //*  Name: btnDelete_Click
    //*  Description: Handles the logic if the btnDelete button is clicked
    //****VARIABLES****
    //*  sqlDetail       -local handle of sql_AYB_Detail
    //*  destination     -destination of page redirect, changes based on if the deletion occured successfully or with an error
    //***SESSION VARIABLES ***
    //*  userMsg         -Message to be displayed to the user
    //*  errorMsg        -Message with detailed exception information to be emailed in case of an error
    //*********************************************
    protected void btnDelete_Click(object sender, System.EventArgs e)
    {
        string destination = null;

        string blah = this.DetailsView1.Rows[8].Cells[1].Text;

        if ((this.DetailsView1.Rows[8].Cells[1] == null) || (this.DetailsView1.Rows[8].Cells[1].Text == "Not Yet Redeemed") || (UserUtil.IsCurrentUserAdmin() && this.DetailsView1.Rows[10].Cells[1].Text == "Auto Redeemed"))
        {
            try
            {
                var awardId = Convert.ToInt32(txtRedemptionCode.Text);
                var responseMessage = RemoveRecognition(awardId);

                if (responseMessage.IsSuccessStatusCode)
                {

                    Session["userMsg"] = "The recognition was removed successfully.";
                    destination = "success";
                }
            }
            catch (Exception ex)
            {
                Session["errorMsg"] = ex.Message;
                Session["userMsg"] = "There was an error with your request.  Please contact technical support.";
                destination = "fail";
            }
        }
        else
        {
            Session["userMsg"] = "<b><font size='3'><u>ERROR:</u></font></b>  A recognition that's been redeemed cannot be removed.";
            destination = "deny";
        }

        Response.Redirect("AdminResult.aspx?result=" + destination);
    }

    //**********************************************
    //*  Name: Page_Load
    //*  Description: Handles the logic if the Page was loaded
    //****SESSION VARIABLES****
    //*  Record_Deleted      -variable for determining if the record was deleted
    //*********************************************
    //ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
    override protected void OnLoad(System.EventArgs e)
    {
        base.OnLoad(e);

        if (!(Page.IsPostBack))
        {
            if (SessionHelper.GetValue<bool>(Session["Record_Deleted"]) == true)
            {
                //Clearing these ensures that the most current data is used for session and error checking.
                Session.Clear();
                ViewState.Clear();
            }
        }

        //Add confirmation messagebox to the delete button
        btnDelete.Attributes.Add("onclick", "if (confirm('Do you wish to remove this recognition?')){}else{return false;}");

        //add logic to txtRedemptionCode to fire the lookup button if the enter button is pushed
        //while focus is on txtRedemptionCode
        txtRedemptionCode.Attributes.Add("onkeypress", "return clickBtn(event, '" + btnLookUp.ClientID + "')");
    }

    private HttpResponseMessage RemoveRecognition(int awardId)
    {
        using (var client = new HttpClient())
        {
            var url = "admin/deactivateRecognition/" + awardId;
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            var redemptionDetail = new Award_S_Result
            {
                Award_ID = awardId
            };

            return client.PutAsJsonAsync(url, redemptionDetail).Result;
        }
    }

    //**********************************************
    //*  Name: btnReset_Click
    //*  Description: Resets the page if btnReset is clicked
    //*********************************************
    protected void btnReset_Click(object sender, System.EventArgs e)
    {
        txtRedemptionCode.Text = "";
        this.tblAdmin.Enabled = false;
        this.tblAdmin.Visible = false;

        txtRedemptionCode.Focus();
    }
    //**********************************************
    //*  Name: CustomValidator1_ServerValidate
    //****VARIABLES****
    //*  Description: Handles the logic if the serverside validation of txtRedemption was called
    //*  result                  -result of trying to parse txtRedemptionCode.Text into an integer
    //*********************************************
    protected void CustomValidator1_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
    {
        int result = 0;
        if ((int.TryParse(txtRedemptionCode.Text, out result) == false))
        {
            CustomValidator1.IsValid = false;
        }
    }
    #endregion

}
