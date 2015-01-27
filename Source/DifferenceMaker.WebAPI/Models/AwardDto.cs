namespace DifferenceMaker.WebAPI.Models
{
    using System;

    public class AwardDto
    {
        public int Award_Id { get; set; }
        public DateTime RedeemedOn { get; set; }
        public string RedemptionLocation { get; set; }
        public string RedemptionComment { get; set; }
    }
}