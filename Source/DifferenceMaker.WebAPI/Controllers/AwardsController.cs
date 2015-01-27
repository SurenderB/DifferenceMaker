namespace DifferenceMaker.WebAPI.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    using DataAccess;

    public class AwardsController : ApiController
    {

        // http://localhost/DifferenceMaker.WebAPI/api/awards/received/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/received/{leaderEmpSv}")]
        public IEnumerable<Awards_EmployeeReceivedDuringPeriod_Result> GetAwardsReceivedByEmpSV(int leaderEmpSv, [FromUri]DateTime startDate, [FromUri]DateTime endDate)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeeReceivedDuringPeriod(leaderEmpSv, startDate, endDate).ToList();
                return result;
            }
        }
        
        // Fill the employee datagrid
        //http://localhost/DifferenceMaker.WebAPI/api/awards/presented/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/presented/{leaderEmpSv}")]
        public IEnumerable<Awards_EmployeePresentedDuringPeriod_Result> GetAwardsPresentedByEmpSV(int leaderEmpSv, [FromUri]DateTime startDate, [FromUri]DateTime endDate)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeePresentedDuringPeriod(leaderEmpSv, startDate, endDate).ToList();
                return result;
            }
        }

        //http://localhost/DifferenceMaker.WebAPI/api/awards/unredeemed/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/unredeemed/{leaderEmpSv}")]
        public IEnumerable<Awards_TeamHasNotRedeemedDuringPeriod_Result> GetAwardsUnredeemedByEmpSV(int leaderEmpSv, [FromUri]DateTime startDate, [FromUri]DateTime endDate)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_TeamHasNotRedeemedDuringPeriod(leaderEmpSv, startDate, endDate).ToList();
                return result;
            }
        }

        //http://localhost/DifferenceMaker.WebAPI/api/awards/redeemed/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/redeemed/{leaderEmpSv}")]
        public IEnumerable<Awards_EmployeeRedeemedDuringPeriod_Result> GetRedeemedAwardsReceivedByEMPSV(int leaderEmpSv, [FromUri]DateTime startDate, [FromUri]DateTime endDate)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeeRedeemedDuringPeriod(leaderEmpSv, startDate, endDate).ToList();
                return result;
            }
        }

        //Pending rewards for an employee
        //http://localhost/DifferenceMaker.WebAPI/api/awards/pending/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/pending/{EmpSv}")]
        public IEnumerable<Awards_EmployeeHasNotRedeemedDuringPeriod_Result> GetUnredeemedAwardsByEMPSV(int empSv, [FromUri]DateTime? startDate = null, [FromUri]DateTime? endDate = null)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeeHasNotRedeemedDuringPeriod(empSv, startDate ?? new DateTime(1900, 1, 1), endDate ?? new DateTime(2200, 1, 1)).ToList();
                return result;
            }
        }
        // Awards received by an employee
        //http://localhost/DifferenceMaker.WebAPI/api/awards/recognitionsReceived/819?startDate=01/01/2005&endDate=01/01/2015
        [Route("api/awards/recognitionsReceived/{EmpSv}")]
        public IEnumerable<Awards_EmployeeReceivedDuringPeriod_Result> GetAwardsReceivedByEmpSV(int empSv, [FromUri]DateTime? startDate = null, [FromUri]DateTime? endDate = null)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeeReceivedDuringPeriod(empSv, startDate ?? new DateTime(1900, 1, 1), endDate ?? new DateTime(2200, 1, 1)).ToList();
                return result;
            }
        }

        // Awards given by the employee
        [Route("api/awards/recognitionsGiven/{EmpSv}")]
        public IEnumerable<Awards_EmployeePresentedDuringPeriod_Result> GetAwardsPresentedByEmpSV(int empSv, [FromUri]DateTime? startDate = null, [FromUri]DateTime? endDate = null)
        {
            using (var context = new Entities())
            {
                var result = context.Awards_EmployeePresentedDuringPeriod(empSv, startDate ?? new DateTime(1900, 1, 1), endDate ?? new DateTime(2200, 1, 1)).ToList();
                return result;
            }
        }

    }
}
