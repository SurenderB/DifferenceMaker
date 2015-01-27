#region  Imports...

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Http;
using System.Web;
using System.Web.UI.WebControls;

using DataAccess;

using FCSAmerica.DifferenceMaker;
using FCSAmerica.DifferenceMaker.Models;

using log4net;

#endregion

partial class Admin_Reporting : System.Web.UI.Page
{
    ILog _log = LogManager.GetLogger("Reporting");

    #region  Constants...

    private const int VW_REPORT_SELECTION = 0;

    #endregion

    #region  Private Attributes...

    private static string _currentPayPeriod = string.Empty;

    #endregion

    #region  Event Handlers...

    /// <summary>
    /// Initializes the web page.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>    
    override protected void OnInit(EventArgs e)
    {
        base.OnInit(e);
        lnkAwardsByEmployee.Click += this.lnkAwardsByEmployee_Click;
        lnkAybForTax.Click += this.lnkAybForTax_Click;
        ddlYearAyb.SelectedIndexChanged += this.ddlYearAyb_SelectedIndexChanged;
    }

    //ORIGINAL LINE: Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles this.Load
    override protected void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        if (!(Page.IsPostBack))
        {
            if (UserUtil.IsCurrentUserAdmin())
            {
                //Set so person can view all awards, and do record deletions
                Session["currentUser_EmpID"] = -1;

                //Only Admins can execute the tax report
                lnkAybForTax.Visible = true;
            }
            else
            {
                //If the person isn't in "AYBAdmins", get their user ID, so the report will only be on their subemployees
                GetCurrentUser();

                //Hide the tax report link if the current user is not an Admin
                //lnkAybForTax.Visible = false;
                lnkAybForTax.Visible = false;
            }

            //Set the initial view
            this.mvAdmin.ActiveViewIndex = VW_REPORT_SELECTION;

            //Obtain the current pay period
            _currentPayPeriod = GetCurrentPayPeriod();

            //Populate the year drop-down list with a set of valid years (based on what's in the database)
            PopulateYearsLists();

            //Populate the pay period drop-down list based on the currently selected year
            PopulatePayPeriods(DateTime.Now.Year);
            Session["CurrentNodeValue"] = "0";
        }
    }

    /// <summary>
    /// Generates the "Awards for Tax Purposes" report.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>
    protected void btnGenerateTaxReport_Click(object sender, System.EventArgs e)
    {
        this.treeEmployees.Visible = false;

        if (this.ddlAybReportType.SelectedIndex == 0)
        {
            Session["fileName"] = "AYB25DollarAwards";
        }
        else if (this.ddlAybReportType.SelectedIndex == 1)
        {
            Session["fileName"] = "AYBOtherDollarAwards";
        }
    }

    /// <summary>
    /// Displays the "Awards by Employee" report criteria form.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>
    protected void lnkAwardsByEmployee_Click(object sender, System.EventArgs e)
    {
        GetActiveEmployees();

        if (this.treeEmployees.Nodes != null)
        {
            this.mvAdmin.ActiveViewIndex = 1;
        }
    }

    /// <summary>
    /// Displays the "Awards for Tax Purposes" report criteria form.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>
    protected void lnkAybForTax_Click(object sender, System.EventArgs e)
    {
        this.mvAdmin.ActiveViewIndex = 2;
    }

    /// <summary>
    /// Reloads the pay period selection drop-down list when a different year is selected.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs" /> instance containing the event data.</param>
    protected void ddlYearAyb_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        PopulatePayPeriods(int.Parse(ddlYearAyb.SelectedValue));
    }

    #endregion

    #region  Private Methods...

    /// <summary>
    /// Populates the years lists based on the minimum and maximum years found in the payroll schedules
    /// stored within the database.
    /// </summary>
    private void PopulateYearsLists()
    {
        ddlYearAyb.Items.Clear();

        for (int year = GetMinimumPayPeriodYear(); year <= DateTime.Now.Year; year++)
        {
            ddlYearAyb.Items.Add(new ListItem(year.ToString(), year.ToString()));

            if (year == DateTime.Now.Year)
            {
                ddlYearAyb.SelectedIndex = ddlYearAyb.Items.Count - 1;
            }
        }
    }

    /// <summary>
    /// Populates the list of active employees that report to the person currently logged in.
    /// </summary>
    private void GetActiveEmployees()
    {
        this.treeEmployees.Visible = true;
        //this.pnlGridButtons.Visible = false;

        DataSet dsEmployees = new DataSet();
        var tvEmployees = this.treeEmployees;
        //Get the leader information for the root node of the tree
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entities"].ToString());
        SqlCommand leadersCommand = new SqlCommand("Leader_S", sqlConn);
        SqlDataAdapter dALeaders = new SqlDataAdapter();
        dALeaders.SelectCommand = leadersCommand;
        dALeaders.SelectCommand.CommandType = CommandType.StoredProcedure;
        dALeaders.SelectCommand.Parameters.Add("@Employee_ID", SqlDbType.Int).Value = SessionHelper.GetValue<int>(Session["currentUser_EmpID"]);

        DataTable dtLeaders = new DataTable();

        dtLeaders.TableName = "dtLeaders";
        dALeaders.Fill(dtLeaders);

        //Get sub employee information for the parent/leaf nodes of the tree
        SqlCommand empCommand = new SqlCommand("Employees_OfLeader", sqlConn);
        SqlDataAdapter dAEmployees = new SqlDataAdapter();

        dAEmployees.SelectCommand = empCommand;
        dAEmployees.SelectCommand.CommandType = CommandType.StoredProcedure;
        dAEmployees.SelectCommand.Parameters.Add("@LeaderEmployee_ID", SqlDbType.Int).Value = SessionHelper.GetValue<int>(Session["currentUser_EmpID"]);

        DataTable dtEmployees = new DataTable();

        dtEmployees.TableName = "dtEmployees";

        dAEmployees.Fill(dtEmployees);

        dsEmployees.Tables.Add(dtLeaders);
        dsEmployees.Tables.Add(dtEmployees);

        //add relations to dataset to allow for hierarchical logic
        dsEmployees.Relations.Add("relEmployees", dsEmployees.Tables["dtLeaders"].Columns["Employee_ID"], dsEmployees.Tables["dtEmployees"].Columns["LeaderEmployee_ID"], false);
        dsEmployees.Relations.Add("relEmptoLeader", dsEmployees.Tables["dtEmployees"].Columns["Employee_ID"], dsEmployees.Tables["dtEmployees"].Columns["LeaderEmployee_ID"], false);

        TreeNode nodeLeader;
        TreeNode nodeEmployee = null;
        TreeNode nodeEmployee_level2 = null;
        TreeNode nodeEmployee_level3 = null;
        TreeNode nodeEmployee_level4 = null;

        foreach (DataRow rowLeader in dsEmployees.Tables["dtLeaders"].Rows)
        {
            //Leader
            nodeLeader = new TreeNode();
            nodeLeader.Text = (string)rowLeader["Leader Name"];
            nodeLeader.Value = rowLeader["Employee_ID"].ToString();
            tvEmployees.Nodes.Add(nodeLeader);

            foreach (DataRow rowemployee in rowLeader.GetChildRows("relEmployees"))
            {
                //Leader
                // -SubLeader
                nodeEmployee = new TreeNode();
                nodeEmployee.Text = (string)rowemployee["NameDisplay"];
                nodeEmployee.Value = rowemployee["Employee_ID"].ToString();
                nodeLeader.ChildNodes.Add(nodeEmployee);
                foreach (DataRow rowemployee_level2 in rowemployee.GetChildRows("relEmpToLeader"))
                {
                    //Leader
                    //   -SubLeader
                    //       -SubLeader
                    nodeEmployee_level2 = new TreeNode();
                    nodeEmployee_level2.Text = (string)rowemployee_level2["NameDisplay"];
                    nodeEmployee_level2.Value = rowemployee_level2["Employee_ID"].ToString();
                    nodeEmployee.ChildNodes.Add(nodeEmployee_level2);
                    foreach (DataRow rowEmployee_level3 in rowemployee_level2.GetChildRows("relEmpToLeader"))
                    {
                        //Leader
                        //   -SubLeader
                        //       -SubLeader
                        //           -Subleader
                        nodeEmployee_level3 = new TreeNode();
                        nodeEmployee_level3.Text = (string)rowEmployee_level3["NameDisplay"];
                        nodeEmployee_level3.Value = rowEmployee_level3["Employee_ID"].ToString();
                        nodeEmployee_level2.ChildNodes.Add(nodeEmployee_level3);
                        foreach (DataRow rowEmployee_level4 in rowEmployee_level3.GetChildRows("relEmpToLeader"))
                        {
                            //Leader
                            //   -SubLeader
                            //       -SubLeader
                            //           -SubLeader
                            //               -Lowest Level Employee
                            nodeEmployee_level4 = new TreeNode();
                            nodeEmployee_level4.Text = (string)rowEmployee_level4["NameDisplay"];
                            nodeEmployee_level4.Value = rowEmployee_level4["Employee_ID"].ToString();
                            nodeEmployee_level3.ChildNodes.Add(nodeEmployee_level4);
                        }
                    }
                }
            }
        }

        //Free up resources
        dsEmployees.Dispose();
        dALeaders.Dispose();
        dAEmployees.Dispose();
        sqlConn.Close();
        sqlConn.Dispose();
        //select first node of the tree automatically
        if (this.treeEmployees.Nodes.Count > 0)
        {
            this.treeEmployees.Nodes[0].Selected = true;
        }
    }

    /// <summary>
    /// Gets the currently logged in user's customer ID and stores it within a session variable.
    /// </summary>
    /// <remarks>The Employee ID for the currently logged in user is stored in a session variable
    /// called "currentUser_empID".</remarks>
    private void GetCurrentUser()
    {
        var loggedUserProvider = new LoggedUserProvider();
        var loggedUser = loggedUserProvider.GetLoggedUserFromNetworkId();
        var currentUserID = loggedUser.Employee_ID;
        Session["currentUser_empID"] = currentUserID;
    }

    /// <summary>
    /// Gets the current pay period.
    /// </summary>
    /// <returns>The current pay period in the format of "YYYY-NN" where:
    ///   YYYY = Year
    ///   NN   = Pay period number.
    /// If no pay period is available for the current date, then an empty string is returned.</returns>
    private string GetCurrentPayPeriod()
    {
        object payPeriod = null;
        return String.Empty;
    }

    /// <summary>
    /// Populates the pay period selection drop-down list.
    /// </summary>
    /// <param name="year">The year in which to populate pay periods for.</param>
    private void PopulatePayPeriods(int year)
    {
        string text = null;
        string formattedPayPeriodSchedule = null;
        
        int index = 1;
        ddlPayPeriodAyb.Items.Clear();

        var yearPaySchedules = new List<PaySchedule_OfYear_Result>();

        using (var client = new HttpClient())
        {
            var payScheduleUri = "report/payschedule/" + year;
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            HttpResponseMessage responseMessage = client.GetAsync(payScheduleUri).Result;
            if (responseMessage.IsSuccessStatusCode)
            {
                yearPaySchedules = responseMessage.Content.ReadAsAsync<List<PaySchedule_OfYear_Result>>().Result;
            }
            foreach (var yearPaySchedule in yearPaySchedules)
            {
                var yearPay = yearPaySchedule.PayrollDeadlineDate_dt;

                if (yearPay != null)
                {
                    formattedPayPeriodSchedule = yearPaySchedule.PayPeriodNumber_tx; //index.ToString().PadLeft(2, '0') + " - " + DateTime.Parse(yearPay.ToString()).ToShortDateString();
                    ddlPayPeriodAyb.Items.Add(new ListItem(formattedPayPeriodSchedule, formattedPayPeriodSchedule));
                    if (yearPaySchedule.PayPeriodNumber_tx == _currentPayPeriod)
                    {
                        ddlPayPeriodAyb.SelectedIndex = ddlPayPeriodAyb.Items.Count - 1;
                    }
                }
            }
        }
    }

    /// <summary>
    /// Gets a list of payment period years from the database.
    /// </summary>
    /// <returns></returns>
    private int GetMinimumPayPeriodYear()
    {
        //Fills up the ddlAybYear with the min and max value of dropdown
        var minimumPayPeriodYears = new List<PaySchedule_MinMaxOfYear_Result>();
        var minYear = 0;
        using (var client = new HttpClient())
        {
            var requestUri = "report/minmaxpayschedule/";
            client.BaseAddress = new Uri(ConfigurationManager.AppSettings["restUrl"]);
            HttpResponseMessage responseMessage = client.GetAsync(requestUri).Result;
            if (responseMessage.IsSuccessStatusCode)
            {
                minimumPayPeriodYears = responseMessage.Content.ReadAsAsync<List<PaySchedule_MinMaxOfYear_Result>>().Result;
            }
            foreach (var payPeriodYear in minimumPayPeriodYears)
            {
                minYear = payPeriodYear.MinPayScheduleYear.HasValue ? payPeriodYear.MinPayScheduleYear.Value : DateTime.Now.Year;
            }
            return minYear;
        }
    }

    #endregion

    protected void treeEmployees_SelectedNodeChanged(object sender, EventArgs e)
    {
        Session["CurrentNodeValue"] = (sender as TreeView).SelectedNode.Value;
    }

}
