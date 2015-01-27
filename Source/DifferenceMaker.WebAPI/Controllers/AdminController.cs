namespace DifferenceMaker.WebAPI.Controllers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    using DataAccess;

    using DifferenceMaker.WebAPI.Models;

    public class AdminController : ApiController
    {
        /// View the recognition detail of a given award
        // http://localhost/DifferenceMaker.WebAPI/api/admin/viewRecognition/146916
        [Route("api/admin/viewRecognition/{atYourBest_SV}")]
        public IEnumerable<Award_S_Result> GetAtYourBest_by_AYB_SV_S(int atYourBest_SV)
        {
            using (var context = new Entities())
            {
                var result = context.Award_S(atYourBest_SV).ToList();
                return result;
            }
        }

        // http://localhost/DifferenceMaker.WebAPI/api/admin/deactivateRecognition/146916
        [Route("api/admin/deactivateRecognition/{awardId}"), HttpPut]
        public IHttpActionResult DeactivateRecognitionAward(int? awardId, AwardDto deactivateAwardsDto)
        {
            if (deactivateAwardsDto != null)
            {
                using (var context = new Entities())
                {
                    var result = context.Award_Deactivate(
                        deactivateAwardsDto.Award_Id);
                    return this.Ok();
                }
            }
            else
            {
                return this.NotFound();
            }
        }
    }
}
