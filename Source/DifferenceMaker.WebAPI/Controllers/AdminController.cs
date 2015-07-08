namespace DifferenceMaker.WebAPI.Controllers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    using DataAccess;

    using DifferenceMaker.WebAPI.Models;

    public class AdminController : ApiController
    {
        /// <summary>
        /// The get at your best_by_ ay b_ s v_ s.
        /// </summary>
        /// <param name="atYourBest_SV">
        /// The at Your Best_ SV.
        /// </param>
        /// View the recognition detail of a given award
        /// <returns>
        /// The <see cref="IEnumerable"/>.
        /// </returns>
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

        /// <summary>
        /// The deactivate recognition award.
        /// </summary>
        /// <param name="awardId">
        /// The award id.
        /// </param>
        /// <param name="deactivateAwardsDto">
        /// The deactivate awards DTO.
        /// </param>
        /// <returns>
        /// The <see cref="IHttpActionResult"/>.
        /// </returns>
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
