namespace FCSAmerica.DifferenceMaker.Models
{
    using System;

    public class RecognitionInsertDto
    {
        public int Presenter_Emp_SV { get; set; }
        public int Recipient_Emp_SV { get; set; }
        public DateTime DatePresented_DT { get; set; }
        public string Reason_TX { get; set; }
        public Nullable<bool> IsAYB_yn { get; set; }
        public Nullable<decimal> AwardAmt_cur { get; set; }
        public string Description_tx { get; set; }
        public int Award_Id { get; set; }
    }
}