namespace SportBook.API.Models
{

    public class Recenzija
    {

        public Guid IdRecenzije { get; set; }
        public Guid IdRezervacije { get; set; }
        public int Ocjena { get; set; }
        public string? Komentar { get; set; }
        public DateTime Datum { get; set; }
        public bool JeOdobrena { get; set; }

        
        public Rezervacija? Rezervacija { get; set; }
    }
}
