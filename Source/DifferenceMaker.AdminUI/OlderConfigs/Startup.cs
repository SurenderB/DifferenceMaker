using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(DifferenceMaker.AdminUI.Startup))]
namespace DifferenceMaker.AdminUI
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
