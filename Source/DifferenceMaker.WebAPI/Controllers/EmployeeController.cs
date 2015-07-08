// --------------------------------------------------------------------------------------------------------------------
// <copyright file="EmployeeController.cs" company="">
//   
// </copyright>
// <summary>
//   The employee controller.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace DifferenceMaker.WebAPI.Controllers
{
    using DataAccess;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using System.Web.Http;

    /// <summary>
    /// The employee controller.
    /// </summary>
    public class EmployeeController : ApiController
    {
        /// <summary>
        /// The get emp sv by network id.
        /// </summary>
        /// <param name="networkID">
        /// The network id.
        /// </param>
        /// <returns>
        /// The <see cref="IHttpActionResult"/>.
        /// </returns>
        /// http://localhost/DifferenceMaker.WebAPI/api/employee/bramwellj
        [Route("api/employee/{networkId}")]
        public IHttpActionResult GetEmpSVbyNetworkID(string networkId)
        {
            try
            {
                using (var context = new Entities())
                {
                    var result = context.Employee_HasNetworkID(networkId).FirstOrDefault();
                    if (result != null)
                    {
                        return this.Ok(result);
                    }

                    return this.NotFound();
                }
            }
            catch (Exception e)
            {
                // return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
                return this.BadRequest(e.ToString());
            }
        }

        //// Gets the employeeId for a given userId
        ///// http://localhost/DifferenceMaker.WebAPI/api/employee/bramwellj
        //[Route("api/employee/fromUserId/{networkId}")]
        //public string GetEmpSVFromNetworkID(string networkId)
        //{
        //    using (var context = new Entities())
        //    {
        //        var result = context.Employee_HasNetworkID(networkId).FirstOrDefault();
        //        return result.Emp_SV.ToString();
        //    }
        //}

        /// <summary>
        /// The get location by emp sv.
        /// </summary>
        /// <param name="employeeId">
        /// The employee id.
        /// </param>
        /// <param name="groupName">
        /// The group name.
        /// </param>
        /// <returns>
        /// The <see cref="IHttpActionResult"/>.
        /// </returns>

        // http://localhost/DifferenceMaker.WebAPI/api/employee/location/819
        [Route("api/employee/location/{employeeId}")]
        public HttpResponseMessage GetLocationByEmpSV(int employeeId)
        {
            try
            {
                using (Entities context = new Entities())
                {
                    string loc = context.Employee_Location(employeeId).FirstOrDefault() ?? "[Unknown]";
                    var response = Request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new StringContent(loc, Encoding.UTF8, "text/html");
                    return response;
                }
            }
            catch (Exception e)
            {
                // return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
            }
        }

        // Gets a list of all Active Employees
        //http://localhost/DifferenceMaker.WebAPI/api/employee/activeEmployees/
        [Route("api/employee/activeEmployees/")]
        public IEnumerable<Employees_AllActive_Result> GetAllActiveEmployees()
        {
            using (var context = new Entities())
            {
                var result = context.Employees_AllActive().ToList();
                return result;
            }
        }

        // Gets a list of Presenter/Recipient Team
        //http://localhost/DifferenceMaker.WebAPI/api/employee/employeeTeam/2245
        [Route("api/employee/employeeTeam/{employeeId}")]
        public HttpResponseMessage GetTeamByEmpSV(int? employeeId)
        {
            try
            {
                using (var context = new Entities())
                {
                    var result = context.Team_OfEmployee(employeeId).SingleOrDefault();
                    var response = this.Request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new StringContent(result, Encoding.UTF8, "text/html");
                    return response;
                }
            }
            catch (Exception e)
            {
                // return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
                return this.Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
            }
        }
        // TODO: WHAT IS THE DIFFERENCE BETWEEN THIS ONE AND THE ONE BELOW THIS - NOT USED ANYWHERE
        // Gets a the leader for a given employee
        //http://localhost/DifferenceMaker.WebAPI/api/employee/employeeLeader/2245
        [Route("api/employee/employeeLeader/{employeeId}")]
        public HttpResponseMessage GetLeaderbySV(int? employeeId)
        {
            try
            {
                using (var context = new Entities())
                {
                    var result = context.Leader_OfEmployee(employeeId).SingleOrDefault();
                    var response = this.Request.CreateResponse(HttpStatusCode.OK);
                    if (result != null)
                    {
                        response.Content = new StringContent(result.LeaderDisplayName, Encoding.UTF8, "text/html");
                    }

                    return response;
                }
            }
            catch (Exception e)
            {
                // return Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
                return this.Request.CreateErrorResponse(HttpStatusCode.BadRequest, e);
            }
        }
        // TODO: WHAT IS THE DIFFERENCE BETWEEN THIS ONE AND THE ONE ABOVE THIS - NOT currently USED ANYWHERE

        // Gets a the leader for a given employee
        //http://localhost/DifferenceMaker.WebAPI/api/employee/employeeLeaders/2245
        [Route("api/employee/employeeLeaders/{employeeId}")]
        public List<Leader_OfEmployee_Result> GetLeadersByEmpSV(int? employeeId)
        {
            using (var context = new Entities())
            {
                return context.Leader_OfEmployee(employeeId).ToList();
            }
        }


        //// TODO: WHAT IS THE DIFFERENCE BETWEEN THIS ONE AND THE two ONE ABOVE THIS - NOT currently USED ANYWHERE and not in the entity framework as well

        ////Get the leader information for the root node of the tree
        ////http://localhost/DifferenceMaker.WebAPI/api/employee/employeeLeaders/2245
        //[Route("api/employee/employeeLeaders/{employeeId}")]
        //public List<Leader_S_Result> GetLeadersbySV(int? employeeId)
        //{
        //    using (var context = new Entities())
        //    {
        //        return context.Leader_S(employeeId).ToList();
        //    }
        //}

        // TODO: For Reporing.aspx.cs in adding employees to the sub tree node - NOT currently USED ANYWHERE and not in the entity framework as well
        //Get sub employee information for the parent/leaf nodes of the tree
        //http://localhost/DifferenceMaker.WebAPI/api/employee/leaderEmployee/2245
        [Route("api/employee/leaderEmployee/{leaderId}")]
        public IEnumerable<Employees_OfLeader_Result> GetSubEmployeesByLeaderID(int? leaderId)
        {
            using (var context = new Entities())
            {
                //write query how to select only EmployeeName
                var result = context.Employees_OfLeader(leaderId).ToList();
                return result;
            }
        }


    }
}
