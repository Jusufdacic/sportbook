namespace SportBook.API.Models
{
 
    public class QRKod
    {

        public Guid IdQrKoda { get; set; }
        public Guid IdRezervacije { get; set; }
        public string KodVrijednost { get; set; } = string.Empty;
        public DateTime DatumGenerisanja { get; set; }
        public DateTime DatumIsteka { get; set; }
        public bool JeIskoristen { get; set; }

       
        public Rezervacija? Rezervacija { get; set; }
    }
}
