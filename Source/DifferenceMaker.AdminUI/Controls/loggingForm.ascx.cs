using System;
using System.Collections.Generic;
using System.Configuration;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.UI.WebControls;

using DataAccess;

using FCSAmerica.DifferenceMaker;
using FCSAmerica.DifferenceMaker.Models;

using Newtonsoft.Json;

partial class Controls_loggingForm : System.Web.UI.UserControl
{


    #region  Event Handlers...
    override protected void OnInit(EventArgs e)
    {
        base.OnInit(e);
        btnSubmit.Click += this.btnSubmit_Click;
        btnReset.Click += this.btnReset_Click;
        ddlRecipient.SelectedIndexChanged += this.ddlRecipient_SelectedIndexChanged;
        //ddlRecipient.DataBound += new System.EventHandler(ddlRecipient_SelectedIndexChanged);
        ddlReason.SelectedIndexChanged += this.ddlReason_SelectedIndexChanged;
        cmbAward.SelectedIndexChanged += new System.EventHandler(cmbAward_SelectedIndexChanged);
    }

    override protected void OnLoad(System.EventArgs e)
    {
        //base.OnLoad(e);

        if (!(this.IsPostBack) || (SessionHelper.GetValue<int>(Session["currentUser_EmpID"]) == default(int)) || (SessionHelper.GetValue<int>(Session["currentUser_EmpID"]) == -1))
        {
            GetCurrentUser();
            //LoadSession()
            if (!(this.IsPostBack))
            {
                this.PopulateActiveEmployees();
                this.PopulateRecipients();
                this.PopulateAwardCombo();
                this.PopulateAwardReason();
                this.PopulateAwardReasonDescription();
                this.webCalendarPresented.Value = System.DateTime.Now.Date.ToShortDateString();
            }
        }
    }

    private void PopulateActiveEmployees()
    {
        var activeEmployees = this.GetActiveEmployees();
        foreach (var activeEmployee in activeEmployees)
        {
            this.ddlRecipient.Items.Add(
                new ListItem { Text = activeEmployee.NameDisplay, Value = activeEmployee.Employee_ID.ToString() });
        }
    }

    private List<Employees_AllActive_Result> GetActiveEmployees()
    {
        var activeEmployees = new List<Employees_AllActive_Result>();
        using (var client = new HttpClient())
        {
            var requestUri = "employee/activeEmployees/";
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            HttpResponseMessage responseMessage = client.GetAsync(requestUri).Result;
            if (responseMessage.IsSuccessStatusCode)
            {
                activeEmployees = responseMessage.Content.ReadAsAsync<List<Employees_AllActive_Result>>().Result;
            }
        }
        return activeEmployees;
    }

    //***********************************************
    // Name: btnSubmit_Click()
    // Description: Handles events if the submit button is clicked
    //****Variables: ***
    //**********************************************

    protected void btnSubmit_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            //Set session for current information
            SetSession();

            MultiView mvLogging;
            View loggingActiveView;

            mvLogging = (MultiView)this.Parent.FindControl("mvGiveAnAward");


            loggingActiveView = (View)mvLogging.FindControl("logReview");

            mvLogging.SetActiveView(loggingActiveView);
        }
    }

    //***********************************************
    // Name: btnReset_Click()
    // Description: Handles events if the reset button is clicked
    // ***Variables: ***
    // webCalendarPresented: -variable to represent date presented calendar
    // ddlRecipient:         -dropdownlist to show recipient
    // txtReason:            -text box to show reason
    //**********************************************
    protected void btnReset_Click(object sender, System.EventArgs e)
    {

        Session.Clear();
        ViewState.Clear();

        GetCurrentUser();
        ddlRecipient.SelectedIndex = 0;
        //ddlRecipient_SelectedIndexChanged(sender, e);
        //ddlReason.SelectedIndex = 0;
        txtOther.Text = string.Empty;
        webCalendarPresented.Value = DateTime.Now.Date.ToShortDateString();
        this.cmbAward.SelectedIndex = 0;
        this.ddlReason.SelectedIndex = 0;
        this.txtAwardDescription.Text = string.Empty;
        this.txtOtherAmount.Text = string.Empty;
        this.lblAwardDescription.Text = string.Empty;
        this.lblAwardReasonDescription.Text = string.Empty;
        PopulateAwardReason();
        this.ShowOtherAmountControls(false);
        this.ShowAwardReasonDescription(false);
        this.ShowOtherReasonDescription(false);
    }



    //**********************************************
    //* Name:  ddlRecipient_SelectedIndexChanged
    //* Description: Handles the event for if the ddlRecipient dropdownlist is changed
    //**********************************************
    protected void ddlRecipient_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        this.txtRecipientTeam.Text = this.GetEmployeeTeam(ddlRecipient.SelectedValue);
    }


    //ORIGINAL LINE: Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.PreRender
    override protected void OnPreRender(System.EventArgs e)
    {
        base.OnPreRender(e);
        if (Page.IsPostBack == true)
        {

            if (SessionHelper.GetValue<bool>(Session["Record_Submitted"]))
            {
                //If this page is being loaded, and the record was submitted, refresh page with default data

                Page_Reset(e);

            }
            else
            {
                // ''Checks to see if we are changing after it has been reviewed, or changing for the first time
                //'If Session_Set is true, then the page has been redirected here via review.ascx
                //'   Otherwise, the page is being edited, so don't reload the session  again

                //LoadSession()
            }
        }
    }

    protected void ddlReason_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        TextBox txtOther = null;
        DropDownList ddlReason = this.ddlReason;
        Label lblOther = new Label();

        txtOther = this.txtOther;
        lblOther = this.Label6;
        if (ddlReason.SelectedValue == "Other - ")
        {

            ShowOtherReasonDescription(true);
        }
        else
        {
            txtOther.Text = string.Empty;
            ShowOtherReasonDescription(false);
        }
    }

    /// <summary>
    /// Handles selected index change event.
    /// </summary>
    protected void cmbAward_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        ListItem li = this.cmbAward.SelectedItem;

        PopulateAwardReason();
        PopulateAwardReasonDescription();

        if (li == null)
        {
            ShowOtherAmountControls(false);
        }
        else
        {
            if (int.Parse(li.Value) == -1)
            {
                // User selected "other amount" so show the other amount and amount description input controls
                ShowOtherAmountControls(true);
            }
            else
            {
                ShowOtherAmountControls(false);
            }
        }
    }

    #endregion

    #region  Private Methods...

    private void PopulateRecipients()
    {
        this.ddlRecipient.Items.Clear();
        this.ddlRecipient.Items.Add(new ListItem("--- Select A Recipient ---", "-1", true));

        WebClient client = new WebClient();
        var restUrl = ConfigurationManager.AppSettings["restUrl"];
        var resultString = client.DownloadString(restUrl + "employee/activeEmployees/");
        var recipients = JsonConvert.DeserializeObject<List<Employees_AllActive_Result>>(resultString);
        if (recipients != null)
        {
            foreach (var recipient in recipients)
            {
                ddlRecipient.Items.Add(new ListItem(recipient.NameDisplay, recipient.Employee_ID.ToString(), true));
            }
        }
    }

    /// <summary>
    /// Populates the awards combobox list items.
    /// </summary>
    /// <remarks>Only leaders have access to awards other than $25.00.</remarks>
    private void PopulateAwardCombo()
    {
        // Clear combobox items
        this.cmbAward.Items.Clear();

        // Always add $25 award
        this.cmbAward.Items.Add(new ListItem("$25.00", "25", true));

        // Add the rest of the awards only if the current user is a leader or admin
        if (SessionHelper.GetValue<bool>(Session["currentUserIsLeader"]) || UserUtil.IsCurrentUserAdmin())
        {
            this.cmbAward.Items.Add(new ListItem("$100.00", "100", true));
            this.cmbAward.Items.Add(new ListItem("$175.00", "175", true));
            this.cmbAward.Items.Add(new ListItem("$250.00", "250", true));
            this.cmbAward.Items.Add(new ListItem("Other", "-1", true));
        }

        // Select the $25.00 award by default
        this.cmbAward.SelectedIndex = 0;
    }

    /// <summary>
    /// Populates the Reasons list items. 
    /// </summary>
    /// <remarks>Default reasons based on the amount of the award</remarks>
    private void PopulateAwardReason()
    {
        DropDownList cmbAward = this.cmbAward;

        //Clear drop down list items
        this.ddlReason.Items.Clear();
        //Hide the other reason additional description
        ShowOtherReasonDescription(false);

        if (this.cmbAward.SelectedValue == "100")
        {
            this.ddlReason.Items.Add(new ListItem("Exceed position expectations on a short term project", "Exceed position expectations on a short term project", true));
        }
        else if (this.cmbAward.SelectedValue == "175")
        {
            this.ddlReason.Items.Add(new ListItem("Exceed position expectations on a long term project", "Exceed position expectations on a long term project", true));
        }
        else if (this.cmbAward.SelectedValue == "250")
        {
            this.ddlReason.Items.Add(new ListItem("Expended significant time and effort towards a project", "Expended significant time and effort towards a project", true));
        }
        else if (this.cmbAward.SelectedValue == "-1")
        {
            this.ddlReason.Items.Add(new ListItem("Other - ", "Other - ", true));
            //If other is selected show the Other Reason Description.
            ShowOtherReasonDescription(true);
        }
        else if (this.cmbAward.SelectedValue == "25")
        {
            //reasons for $25
            this.ddlReason.Items.Add(new ListItem("Assist with tasks outside job responsibility", "Assist with tasks outside job responsibility", true));
            this.ddlReason.Items.Add(new ListItem("Participate on workgroup in an exemplary manner", "Participate on workgroup in an exemplary manner", true));
            this.ddlReason.Items.Add(new ListItem("Exceed expectations on task/workgroup", "Exceed expectations on task/workgroup", true));
            this.ddlReason.Items.Add(new ListItem("Immediate solution for urgent deadline", "Immediate solution for urgent deadline", true));
            this.ddlReason.Items.Add(new ListItem("Exemplary service for customer", "Exemplary service for customer", true));
            this.ddlReason.Items.Add(new ListItem("Work extra hours to complete urgent task", "Work extra hours to complete urgent task", true));
            this.ddlReason.Items.Add(new ListItem("Exemplary core values/Basic principles", "Exemplary core values/Basic principles", true));
            this.ddlReason.Items.Add(new ListItem("Other - ", "Other - ", true));
        }

    }

    /// <summary>
    /// Sets the Reason Description label
    /// </summary>
    /// <remarks>Adds additional description to the 100,175,250 award reason</remarks>
    private void PopulateAwardReasonDescription()
    {
        DropDownList cmbAward = this.cmbAward;

        ShowAwardReasonDescription(false);
        if (this.cmbAward.SelectedValue == "100")
        {
            ShowAwardReasonDescription(true);
            lblAwardReasonDescription.Text = "Reason Description: <br>This Recognition would be appropriate for an employee whose efforts were above and beyond the normal functions of their position on a consistent basis for the duration of a short term project . This recognition requires the presenter's leader's approval.";
        }
        else if (this.cmbAward.SelectedValue == "175")
        {
            ShowAwardReasonDescription(true);
            lblAwardReasonDescription.Text = "Reason Description: <br>This Recognition would be appropriate for an employee whose efforts were above and beyond the normal functions of their position for an extended period of time. This recognition requires the presenter's leader's approval.";
        }
        else if (this.cmbAward.SelectedValue == "250")
        {
            ShowAwardReasonDescription(true);
            lblAwardReasonDescription.Text = "Reason Description: <br>This Recognition would be appropriate when the employee has expended significant time and effort towards a project. This award requires the presenter's leader's approval. ";
        }
    }

    //**********************************************
    //*  Name: GetCurrentUser()
    //*  Description: Locates currently logged in user, and displays his/her name in
    //*              "Presenter" dropdownlist
    //****VARIABLES****
    //*  txtPresent      -local handle of txtPresenter
    //*  myConnection    -connection to sql database
    //*  ds              -dataset that holds all data
    //*  table           -a table used for searching through dataset for name
    //*  row             -a row used for searching through dataset for name
    //*  dataAdapter     -a data adapter used to find current user name in dropdownlist
    //*  i               -integer used for sorting
    //*  tempUser        -a temporary string used for various functions regarding the user name
    //*  currentUser     -a string variable for holding current user's name
    //*********************************************
    private void GetCurrentUser()
    {
        var loggedUserProvider = new LoggedUserProvider();
        var loggedUser = loggedUserProvider.GetLoggedUserFromNetworkId();
        if (loggedUser != null)
        {
            txtPresenter.Text = loggedUser.NameDisplay;
            Session["currentUser_empID"] = loggedUser.Employee_ID;
            Session["currentUserIsLeader"] = loggedUser.IsSupervisor;

            GetPresenterTeam();
        }
        else
        {
            Session["currentUser_empID"] = -99999999;
            Session["currentUserIsLeader"] = false;
        }

    }
    //**********************************************
    //*  Name: SetSession
    //*  Description: Puts all of the information in the current page into the session state
    //****VARIABLES****
    //*  ddlPresenter        - dropdownlist for presenter's name
    //*  txtPresenterTeam    - Presenter's team name
    //*  ddlRecipient        - dropdownlist for recipient's nam
    //*  txtRecipientTeam    - Recipient's team name
    //*  txtReason           - Text Box for the user to type in their reason for the award
    //**** Session Variables *****
    //*  ddlPresenter_index  - variable representing ddlPresenter's selected index
    //*  Presenter_Team      - variable representing Presenter's team name
    //*  ddlRecipient_index  - variable representing ddlRecipient's selected index
    //*  Recipient_SV        - Variable representing recipient's seed value
    //*  Recipient_Team      - variable representing recipient's team name
    //*  Date_Presented      - variable representing the date presented
    //*  Reason              - Variable representing the reason for the award
    //*  Session_Set         - Boolean variable to check to see if the page has been submitted for review
    //*********************************************
    private void SetSession()
    {
        Session["Presenter_Name"] = this.txtPresenter.Text;
        Session["Presenter_Team"] = this.txtPresenterTeam.Text;
        Session["ddlRecipient_index"] = this.ddlRecipient.SelectedIndex;
        Session["Recipient_SV"] = this.ddlRecipient.SelectedValue;
        Session["Recipient_Name"] = this.ddlRecipient.SelectedItem.Text;
        Session["Recipient_Team"] = this.txtRecipientTeam.Text;
        Session["Date_Presented"] = (this.webCalendarPresented.Value);
        Session["Reason"] = this.ddlReason.Text + this.txtOther.Text;

        decimal awardAmount = 0M;
        bool isOtherAmount = false;
        string awardDescription = string.Empty;
        bool isAtYourBest = false;

        GetAwardInfo(ref awardAmount, ref isOtherAmount, ref awardDescription, ref isAtYourBest);

        Session["AwardAmount"] = awardAmount;
        Session["IsOtherAmount"] = isOtherAmount;
        Session["IsAtYourBest"] = isAtYourBest;

        if (isAtYourBest)
        {
            Session["AwardDescription"] = "At Your Best Award";
        }
        else
        {
            Session["AwardDescription"] = awardDescription;
        }

        //Flag that acknowledges that the session has been set, so the page knows to reload the session on postback
        Session["Session_Set"] = true;

    }

    /// <summary>
    /// Gets information about the selected award from the UI.
    /// </summary>
    /// <param name="awardAmount">The amount of the award.</param>
    /// <param name="isOtherAmount">A Boolean that indicates whether or not the amount is an "other" amount.</param>
    /// <param name="awardDescription">A description of the award (only valid if amount is type "other").</param>
    /// <param name="isAtYourBest">True if the amount is not "other" and the amount = $25.</param>
    /// <remarks></remarks>
    private void GetAwardInfo(ref decimal awardAmount, ref bool isOtherAmount, ref string awardDescription, ref bool isAtYourBest)
    {
        ListItem li = this.cmbAward.SelectedItem;

        if (int.Parse(li.Value) == -1)
        {
            // Other amount was selected
            awardAmount = System.Convert.ToDecimal(this.txtOtherAmount.Text);
            isOtherAmount = true;
            awardDescription = this.txtAwardDescription.Text;
            isAtYourBest = false;
        }
        else
        {
            // Standard amount was selected
            awardAmount = System.Convert.ToDecimal(li.Value);
            isOtherAmount = false;
            awardDescription = string.Empty;

            if (int.Parse(li.Value) == 25)
            {
                isAtYourBest = true;
            }
            else
            {
                isAtYourBest = false;
            }
        }
    }

    //**********************************************
    //*  Name: GetPresenterTeam()
    //*  Description: Populates txtPresenterTeam with team name based on currently logged in user
    //*********************************************
    protected void GetPresenterTeam()
    {
        this.txtPresenterTeam.Text = this.GetEmployeeTeam(this.Session["currentUser_EmpID"].ToString());
    }

    private string GetEmployeeTeam(string employeeId)
    {
        using (var client = new HttpClient())
        {
            var requestUri = "employee/employeeTeam/" + employeeId;
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            var result = client.GetStringAsync(requestUri).Result;
            return string.IsNullOrEmpty(result) ? string.Empty : result;
        }
    }

    //***********************************************
    // Name: Page_Reset()
    // Description: Resets the page after a record was submitted
    // ***Variables: ***
    // webCalendarPresented: -variable to represent date presented calendar
    // ddlRecipient:         -dropdownlist to show recipient
    // txtReason:            -text box to show reason
    //**********************************************
    protected
    void Page_Reset(System.EventArgs e)
    {
        Session.Clear(); //clears session state
        ViewState.Clear(); //clears viewstate
        GetCurrentUser(); //gets current user's employee id and stores it in session
        //resets page to default values
        ddlRecipient.SelectedIndex = 0;
        //ddlRecipient_SelectedIndexChanged(this, e);
        ddlReason.SelectedIndex = 0;
        txtOther.Text = string.Empty;
        webCalendarPresented.Value = DateTime.Now.Date.ToShortDateString();
        this.cmbAward.SelectedIndex = 0;
        this.ddlReason.SelectedIndex = 0;
        this.txtAwardDescription.Text = string.Empty;
        this.txtOtherAmount.Text = string.Empty;
        this.lblAwardDescription.Text = string.Empty;
        this.lblAwardReasonDescription.Text = string.Empty;
        PopulateAwardReason();
        this.ShowOtherAmountControls(false);
        this.ShowAwardReasonDescription(false);
        this.ShowOtherReasonDescription(false);
    }

    /// <summary>
    /// Shows or hids the controls that are only visible if the "other" amount is selected.
    /// </summary>
    /// <param name="visible">Set to True to show the controls, set to False to hide the controls.</param>
    private void ShowOtherAmountControls(bool visible)
    {
        this.rowOtherAwardAmount.Visible = visible;
        this.rowAwardDescription.Visible = visible;
    }

    /// <summary>
    /// Shows or hides the Award Desription that are only visible if certain amount is selected.
    /// </summary>
    /// <param name="visible">Set to True to show the controls, set to False to hide the controls.</param>
    private void ShowAwardReasonDescription(bool visible)
    {
        this.lblAwardReasonDescription.Visible = visible;
    }

    /// <summary>
    /// Shows or hides the Other Reason Description
    /// </summary>
    /// <param name="visible">Set to True to show the controls, set to False to hide the controls.</param>
    private void ShowOtherReasonDescription(bool visible)
    {
        this.txtOther.Visible = visible;
        this.Label6.Visible = visible;
    }
    #endregion
}
