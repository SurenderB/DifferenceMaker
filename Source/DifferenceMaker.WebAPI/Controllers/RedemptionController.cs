namespace DifferenceMaker.WebAPI.Controllers
{
    using System;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    using System.Web.Http;
    using System.Web.Http.Results;

    using DataAccess;

    using DifferenceMaker.WebAPI.Models;

    /// <summary>
    /// Controller that handles all the CRUD options for redemption code detail.
    /// </summary>
    public class RedemptionController : ApiController
    {
        // http://localhost/DifferenceMaker.WebAPI/api/redemption/getRedemption/146916
        [Route("api/redemption/getRedemption/{atYourBestSV}")]
        public IHttpActionResult GetRedemptionCodeDetail(int? atYourBestSV)
        {
            using (var context = new Entities())
            {
                var result = context.Award_S(atYourBestSV).FirstOrDefault();
                if (result != null)
                {
                    return this.Ok(result);
                }
                else
                {
                    return this.NotFound();
                }
            }
        }

        // http://localhost/DifferenceMaker.WebAPI/api/redemption/updateRedemption/146916
        [Route("api/redemption/updateRedemption/{awardId}"), HttpPut]
        public IHttpActionResult UpdateRedemptionCodeDetail(int awardId, AwardDto recognitionDto)
        {
            if (recognitionDto != null)
            {
                using (var context = new Entities())
                {
                    var result = context.Award_Redeem(
                        recognitionDto.RedeemedOn,
                        recognitionDto.RedemptionLocation,
                        recognitionDto.RedemptionComment,
                        recognitionDto.Award_Id);
                    return this.Ok();
                }
            }
            else
            {
                return this.NotFound();
            }
        }

        // http://localhost/DifferenceMaker.WebAPI/api/redemption/insertRedemption/
        [Route("api/redemption/insertRedemption/"), HttpPost]
        public IHttpActionResult InsertRedemptionCodeDetail(AwardInsertDto recognitionDto)
        {
            if (recognitionDto != null)
            {
                ObjectParameter awardId = new ObjectParameter("Award_ID", typeof(int));

                using (var context = new Entities())
                {
                    var result = context.Award_I(
                        recognitionDto.Presenter_Emp_SV,
                        recognitionDto.Recipient_Emp_SV,
                        recognitionDto.DatePresented_DT,
                        recognitionDto.Reason_TX,
                        recognitionDto.IsAYB_yn,
                        recognitionDto.AwardAmt_cur,
                        recognitionDto.Description_tx,
                        awardId
                        );
                    if ((int)awardId.Value > 0)
                    {
                        recognitionDto.Award_Id = (int)awardId.Value;
                        return this.Ok(recognitionDto);
                    }
                    else return new ExceptionResult(new Exception("Unable to insert."), this);
                }
            }
            else
            {
                return new ExceptionResult(new Exception("Object is null"),this);
            }
        }
    }
}
