namespace DifferenceMaker.WebAPI.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    using DataAccess;

    public class ReportController : ApiController
    {
             // Fill tax report datagrid 
        [Route("api/report/payPeriodNumber/{payrollDeadlineDate}")]
        public IEnumerable<string> GetPayPeriodNumber(DateTime? payrollDeadlineDate)
        {
            using (var context = new Entities())
            {
                var result = context.PayPeriod_OfPayrollDeadlineOn(payrollDeadlineDate).ToList();
                return result;
            }
        }

        // Fill tax report datagrid
        //http://localhost/DifferenceMaker.WebAPI/api/report/payPeriodReward?payPeriodNumber=2015-01&isAYB=true
        [Route("api/report/payPeriodReward")]
        public IEnumerable<Awards_RedeemedDuringPayPeriod_Result> GetPayPeriodReward_S([FromUri]string payPeriodNumber, [FromUri]bool isAYB)
        {
            return new ReportQueries().ExportTaxReport(payPeriodNumber, isAYB).ToList();
        }

        // Pay period selection for Tax Report Data
        //http://localhost/DifferenceMaker.WebAPI/api/report/payschedule/2014
        [Route("api/report/paySchedule/{payrollYear}")]
        public IEnumerable<PaySchedule_OfYear_Result> GetYearPaySchedule_S(int payrollYear)
        {
            using (var context = new Entities())
            {
                var result = context.PaySchedule_OfYear((short)payrollYear).ToList();
                return result;
            }
        }


        // Year selection for Tax Report Data
        //http://localhost/DifferenceMaker.WebAPI/api/report/minmaxpayschedule/
        [Route("api/report/minmaxpayschedule/")]
        public IEnumerable<PaySchedule_MinMaxOfYear_Result> GetMinMaxPayScheduleYear()
        {
            using (var context = new Entities())
            {
                var result = context.PaySchedule_MinMaxOfYear().ToList();
                return result;
            }
        }
    }
    
}
