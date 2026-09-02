namespace SportBook.API.DTOs
{

    public class KreirajRezervacijuDTO
    {

        public Guid IdKorisnika { get; set; }
        public Guid IdTermina { get; set; }
        public string? Napomena { get; set; }
    }
}
