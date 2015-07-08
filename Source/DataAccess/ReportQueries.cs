using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    using System.Data;
    using System.Data.SqlClient;
    using System.Security.Cryptography;

    /// <summary>
    /// Generates report data from the database.
    /// </summary>
    public class ReportQueries
    {
        /// <summary>
        /// Creates the awards reports that are for tax purposes.
        /// </summary>
        /// <param name="payPeriodNumber">Pay period number</param>
        /// <param name="is25DollarReport">True for the tax report for the $25 awards; false for the report for the non-$25 awards.</param>
        /// <returns></returns>
        public IEnumerable<Awards_RedeemedDuringPayPeriod_Result> ExportTaxReport(string payPeriodNumber, bool is25DollarReport)
        {
            using (var context = new Entities())
            {
                var data = context.Awards_RedeemedDuringPayPeriod(payPeriodNumber, is25DollarReport).ToList();
                var columnRows = from x in data
                                 select new { Name = x.Employee_Name, Clock = x.Clock_No, Amount = x.Gross_Amount ?? 0 };

                if (is25DollarReport)
                {
                    var groupedRows = from x in columnRows
                                      group x by x.Clock
                                      into g
                                      select
                                          new Awards_RedeemedDuringPayPeriod_Result()
                                              {
                                                  Batch_Name = "W11 W11-AYB",
                                                  Employee_Name = g.First().Name,
                                                  Clock_No = g.Key,
                                                  Payroll_Code = "FTXRM",
                                                  Gross_Amount = g.Count() * 25,
                                                  S1 = 0,
                                                  S2 = 2,
                                                  S3 = "T"
                                              };
                    return groupedRows;
                }
                else
                {
                    var groupedRows = from x in columnRows
                                      group x by x.Clock
                                      into g
                                      select
                                          new Awards_RedeemedDuringPayPeriod_Result
                                              {
                                                  Batch_Name = "W11 W11-ERTAX",
                                                  Employee_Name = g.First().Name, 
                                                  Clock_No = g.Key, 
                                                  Payroll_Code = "ERTAX",
                                                  Gross_Amount = g.Sum(x => x.Amount),
                                                  S1 = 0,
                                                  S2 = 2,
                                                  S3 = "T"
                                              };

                    return groupedRows;
                }
            }
        }
    }
}
