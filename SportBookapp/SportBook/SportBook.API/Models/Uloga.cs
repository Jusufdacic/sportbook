namespace SportBook.API.Models
{

    public class Uloga
    {

        public Guid IdUloge { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public string? Opis { get; set; }
    }
}
