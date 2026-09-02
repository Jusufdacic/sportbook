namespace SportBook.API.Models
{

    public class KorisnikUloga
    {

        public Guid Id { get; set; }
        public Guid IdKorisnika { get; set; }
        public Guid IdUloge { get; set; }
        public DateTime DatumDodjele { get; set; }


        public Korisnik? Korisnik { get; set; }
        public Uloga? Uloga { get; set; }
    }
}
