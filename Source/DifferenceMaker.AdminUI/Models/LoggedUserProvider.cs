using System.Web;

namespace FCSAmerica.DifferenceMaker.Models
{
    using DataAccess;
    using Newtonsoft.Json;
    using System.Configuration;
    using System.Net;

    public class LoggedUserProvider
    {
        /// <summary>
        /// The get logged user from network id.
        /// </summary>
        /// <returns>
        /// The <see cref="Employee_HasNetworkID_Result"/>.
        /// </returns>
        public Employee_HasNetworkID_Result GetLoggedUserFromNetworkId()
        {
            var networkId = GetNetworkIdOnly(HttpContext.Current.User.Identity.Name);

            WebClient client = new WebClient();
            var restUrl = ConfigurationManager.AppSettings["restUrl"];
            var resultString = client.DownloadString(restUrl + "employee/" + networkId);
            var loggedUser = JsonConvert.DeserializeObject<Employee_HasNetworkID_Result>(resultString);
            return loggedUser;

        }

        private string GetNetworkIdOnly(string networkIdWithDomain)
        {
            var splitString = networkIdWithDomain.Split('\\');
            return splitString[1];
        }
    }
}