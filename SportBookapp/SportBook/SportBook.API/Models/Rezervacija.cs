namespace SportBook.API.Models
{

    public class Rezervacija
    {

        public Guid IdRezervacije { get; set; }
        public Guid IdKorisnika { get; set; }
        public Guid IdTermina { get; set; }
        public DateTime DatumRezervacije { get; set; }
        public string Status { get; set; } = "aktivna"; 
        public decimal UkupnaCijena { get; set; }
        public string StatusPlacanja { get; set; } = "na_cekanju";
        public string? Napomena { get; set; }


        public Korisnik? Korisnik { get; set; }
        public Termin? Termin { get; set; }
        public QRKod? QRKod { get; set; }
        public List<RezervacijaOprema>? RezervacijaOprema { get; set; }
        public Recenzija? Recenzija { get; set; }
    }
}
