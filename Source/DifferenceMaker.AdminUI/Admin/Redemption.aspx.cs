using System;
using System.Configuration;
using System.Net.Http;
using System.Web.UI.WebControls;

using DataAccess;

using FCSAmerica.DifferenceMaker.Models;

partial class Redemption : System.Web.UI.Page
{

    //*******************************************************
    //** btnLookUp_Click()
    //** Description:    -populates the table with the record data, and makes it accessible
    //***Variables:
    //** dV              - dataview used to hold select data
    //*******************************************************
    override protected void OnInit(EventArgs e)
    {
        base.OnInit(e);
        btnLookUp.Click += new System.EventHandler(btnLookUp_Click);
        btnReset.Click += new System.EventHandler(btnReset_Click);
        btnRedeem.Click += new System.EventHandler(btnRedeem_Click);
    }

    protected void btnLookUp_Click(object sender, System.EventArgs e)
    {
        int RecipientSV = 0;
        TableCell tC = null;
        if (this.txtRedemptionCode.Text == "")
        {
            btnReset_Click(sender, e);
        }
        else
        {
            try
            {
                var awardId = Convert.ToInt32(txtRedemptionCode.Text);
                var recognitionDetail = GetRecognitionDetail(awardId);
                if (recognitionDetail != null)
                {
                    txtPresenter.Text = recognitionDetail.Presenter;
                    txtPresenterTeam.Text = recognitionDetail.PresenterTeam;

                    //get the employee id of the recipient, to test to see if it's the same as the person logged in
                    if (recognitionDetail.Recipient_ID != null)
                    {
                        RecipientSV = recognitionDetail.Recipient_ID;

                        if (SessionHelper.GetValue<int>(Session["currentUser_EmpID"]) != default(int))
                        {
                            //If the recipientSV is the same as the current user's employee id, the award cannot be redeemed
                            if (SessionHelper.GetValue<int>(Session["currentUser_EmpID"]) == RecipientSV)
                            {
                                //only fires validation if the award hasn't been redeemed
                                this.CustomValidator1.IsValid = recognitionDetail.RedeemedOn != null;
                            }
                        }
                    }

                    txtRecipient.Text = recognitionDetail.Recipient;

                    // If there's something for the recipient's team name, use it, otherwise, make the text box empty
                    txtRecipientTeam.Text = recognitionDetail.RecipientTeam != null
                                                ? recognitionDetail.RecipientTeam
                                                : string.Empty;

                    txtDatePresented.Text = recognitionDetail.PresentedOn;
                    txtReason.Text = recognitionDetail.Reason;

                    // Get the local handle of the table cell tCRedemptionControl
                    tC = (TableCell)tblInfo.FindControl("tCRedemptionControl");

                    if (recognitionDetail.RedeemedOn != null)
                    {
                        // If the DateRedeemed field is not null, the record has already been redeemed.
                        // Disable the redemption control panel
                        tC.Enabled = false;

                        // populate the fields with the redemption data from the record
                        txtDateRedeemed.Text = recognitionDetail.RedeemedOn;
                        txtRedemptionLocation.Text = recognitionDetail.RedemptionLocation;
                        txtRedemptionComments.Text = recognitionDetail.RedemptionComment;
                    }
                    else
                    {
                        // Otherwise, the record hasn't been redeemed.

                        if (this.CustomValidator1.IsValid == false)
                        {
                            // If the page is being viewed by the recipient, disable the redemption control panel,
                            // since someone can't redeem their own award.
                            tC.Enabled = false;
                            txtDateRedeemed.Text = "";
                            txtRedemptionLocation.Text = "";
                            txtRedemptionComments.Text = "";

                        }
                        else
                        {
                            // if the record hasn't been redeemed, and it's someone other than the recipient viewing the record,
                            // Enable the redemption control panel, and populate the data and RedemptionLocation dynamically
                            tC.Enabled = true;
                            txtDateRedeemed.Text = System.DateTime.Now.Date.ToString();
                            txtRedemptionLocation.Text = GetLocation();
                            txtRedemptionComments.Text = "";
                        }
                    }

                    // Make the table visible and enabled
                    this.tblInfo.Visible = true;
                    this.tblInfo.Enabled = true;
                }

                ////Make the table visible and enabled
                //this.tblInfo.Visible = true;
                //this.tblInfo.Enabled = true;
            }
            catch (Exception ex)
            {
                if (ex.Message == "There is no row at position 0.")
                {
                    Session["userMsg"] = "There is no award with that redemption code.";
                }
                else
                {
                    Session["errorMsg"] = ex.Message;
                }

                Response.Redirect("result.aspx?result=fail");
            }
        }
    }

    private Award_S_Result GetRecognitionDetail(int awardId)
    {
        var recognitionDetail = new Award_S_Result();
        using (var client = new HttpClient())
        {
            var requestUri = "redemption/getRedemption/" + awardId;
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            HttpResponseMessage responseMessage = client.GetAsync(requestUri).Result;
            if (responseMessage.IsSuccessStatusCode)
            {
                recognitionDetail = responseMessage.Content.ReadAsAsync<Award_S_Result>().Result;
            }
        }
        return recognitionDetail;
    }

    //*******************************************************
    //** Function Name: GetLocation()
    //** Description: Gets the location of the person currently logged in
    //***Variables***
    //** sqlConn     -sqlConnection to the employees database
    //** locatiuon   -local handle for the location of the user, returned by the stored procedure
    //** Employee_ID      -the current user's employee id
    //******************************************************

    protected string GetLocation()
    {
        using (var client = new HttpClient())
        {
            var requestUri = "employee/location/" + Session["currentUser_EmpID"];
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            var result = client.GetStringAsync(requestUri).Result;
            return string.IsNullOrEmpty(result) ? string.Empty : result;
        }
    }
    //*******************************************************
    //** Function Name: btnReset_Click
    //** Description: Reset's the page.  Called if a user clicks the Reset button
    //***Variables***
    //** tblInfo             - local handle for the "tblInfo" table
    //** txtRedemptionCode   - local handle for the txtRedemptionCode text box
    //** txtRedemptionComments-local handle for the txtRedemptionComments text box
    //******************************************************
    protected void btnReset_Click(object sender, System.EventArgs e)
    {
        Table tblInfo = this.tblInfo;
        TextBox txtRedemptionCode = (TextBox)tblInfo.FindControl("txtRedemptionCode");
        TextBox txtRedemptionComments = (TextBox)tblInfo.FindControl("txtRedemptionComments");

        txtRedemptionComments.Text = "";

        tblInfo.Visible = false;

        txtRedemptionCode.Text = "";

    }
    //*******************************************************
    //** Function Name: btnRedeem_Click
    //** Description: Redeems the award.  Called if someone clicks the btnRedeem button.
    //******************************************************
    protected void btnRedeem_Click(object sender, System.EventArgs e)
    {
        var awardId = Convert.ToInt32(txtRedemptionCode.Text);
        var redeemedDate = Convert.ToDateTime(txtDateRedeemed.Text);
        var responseMessage = UpdateRecognitionDetail(awardId, redeemedDate, txtRedemptionLocation.Text, txtRedemptionComments.Text);

        if (responseMessage.IsSuccessStatusCode)
        {
            Response.Redirect("result.aspx?result=success");
        }
        else
        {
            //If there was an error, redirect to the failure page and show error
            Session["errorMsg"] = responseMessage.ReasonPhrase;
            Response.Redirect("result.aspx?result=fail");
        }
    }

    private HttpResponseMessage UpdateRecognitionDetail(int awardId, DateTime redeemedOn, string redemptionLocation, string redemptionComment)
    {
        using (var client = new HttpClient())
        {
            var url = "redemption/updateRedemption/" + awardId;
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            var recognitionDetail = new RecognitionUpdateDto()
            {
                Award_ID = awardId,
                RedeemedOn = redeemedOn,
                RedemptionLocation = redemptionLocation,
                RedemptionComment = redemptionComment,
            };

            return client.PutAsJsonAsync(url, recognitionDetail).Result;
        }
    }

    //*******************************************************
    //** Function Name: Page_Load
    //** Description: Occurs when the page is loaded
    override protected void OnLoad(System.EventArgs e)
    {
        base.OnLoad(e);
        if (!(Page.IsPostBack))
        {
            if (SessionHelper.GetValue<bool>(Session["Award_Redeemed"]))
            {
                //Clearing these ensures that the most current data is used for session and error checking.
                Session.Clear();
                ViewState.Clear();
            }
        }

        Table tblInfo = this.tblInfo;
        //TextBox txtRedempCode = (TextBox)tblInfo.FindControl("txtRedemptionCode");
        TextBox txtRedempComments = (TextBox)tblInfo.FindControl("txtRedemptionComments");
        Button btnLookUp = (Button)tblInfo.FindControl("btnLookUp");
        Button btnRedeem = (Button)tblInfo.FindControl("btnRedeem");

        //add javascript function to the txtRedemptionCode and txtRedemptionComments textboxes to allow
        // for hitting enter and having it call the correct submit button
        //txtRedempCode.Attributes.Add("onkeypress", "return clickBtn(event, '" + btnLookUp.ClientID + "')");
        txtRedemptionCode.Attributes.Add("onkeypress", "return clickBtn(event, '" + btnLookUp.ClientID + "')");
        txtRedempComments.Attributes.Add("onkeypress", "return clickBtn(event, '" + btnRedeem.ClientID + "')");
        btnRedeem.Attributes.Add("onclick", "if (confirm('Upon clicking yes, this award will be marked as redeemed and cannot be redeemed again.  Please be sure you have your Visa gift card.')){}else{return false;}");
        //calls local reference of "GetCurrentUser" in case the user is accessing the page without visiting
        //The default page that gets the user's identification
        GetCurrentUser();
    }


    //**********************************************
    //*  Name: GetCurrentUser()
    //*  Description: Locates currently logged in user, and displays his/her name in
    //*              "Presenter" dropdownlist
    private void GetCurrentUser()
    {
        var loggedUserProvider = new LoggedUserProvider();
        var loggedUser = loggedUserProvider.GetLoggedUserFromNetworkId();
        txtPresenter.Text = loggedUser.NameDisplay;
        Session["currentUser_empID"] = loggedUser.Employee_ID;
    }
}
