namespace SportBook.API.Models
{

    public class Korisnik
    {
       
        public Guid IdKorisnika { get; set; }
        public string Ime { get; set; } = string.Empty; //obavezno string polje po def null je program moze upozoravati
        public string Prezime { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string LozinkaHash { get; set; } = string.Empty;
        public string? Telefon { get; set; }
        public DateTime DatumRegistracije { get; set; }
        public bool JeAktivan { get; set; }

        public List<KorisnikUloga>? KorisnikUloge { get; set; }  //liste su jedan prema vise
    }
}
