namespace SportBook.API.Models
{

    public class SportskiObjekat
    {

        public Guid IdObjekta { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public string Adresa { get; set; } = string.Empty;
        public string Grad { get; set; } = string.Empty;
        public string? Telefon { get; set; }
        public string? Email { get; set; }
        public bool JeAktivan { get; set; }


        public List<Teren>? Tereni { get; set; } 
        public List<Oprema>? Oprema { get; set; }
    }
}
