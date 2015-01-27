namespace FCSAmerica.DifferenceMaker.Models
{
    using System.Configuration;
    using System.Net;
    using System.Web;

    using DataAccess;

    using Newtonsoft.Json;

    public class LoggedUserProvider
    {
        public Employee_HasNetworkID_Result GetLoggedUserFromNetworkId()
        {
            var networkId = this.GetNetworkIdOnly(HttpContext.Current.User.Identity.Name);
            //var networkId = "maiert"; // TODO: remove hack
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