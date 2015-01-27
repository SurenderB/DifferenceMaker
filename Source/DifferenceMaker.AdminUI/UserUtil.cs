using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FCSAmerica.DifferenceMaker
{
    using System.Configuration;
    using System.DirectoryServices.AccountManagement;

    public class UserUtil
    {
        private static string Domain = ConfigurationManager.AppSettings["myDomain"];

        private static bool IsUserAdmin(string username)
        {
            using (var ctx = new PrincipalContext(ContextType.Domain, Domain))
            {
                UserPrincipal user = UserPrincipal.FindByIdentity(ctx, username);
                var adminGroup = ConfigurationManager.AppSettings["ActiveDirectoryAdminsGroup"];
                return user != null && user.GetGroups().Any(_ => _.Name == adminGroup);
            }
        }

        public static bool IsCurrentUserAdmin()
        {
            //return IsUserAdmin(Environment.UserDomainName + '\\' + Environment.UserName);
            return IsUserAdmin(HttpContext.Current.User.Identity.Name);
        }
    }
}
