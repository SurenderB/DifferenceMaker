namespace FCSAmerica.DifferenceMaker.Models
{
    using System;

    public class RecognitionUpdateDto
    {
        public int Award_ID { get; set; }
        public DateTime RedeemedOn { get; set; }
        public string RedemptionLocation { get; set; }
        public string RedemptionComment { get; set; }
    }
}