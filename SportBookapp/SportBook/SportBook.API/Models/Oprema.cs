namespace SportBook.API.Models
{

    public class Oprema
    {

        public Guid IdOpreme { get; set; }
        public Guid IdObjekta { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public decimal CijenaPosudbe { get; set; }
        public int KolicinaDostupna { get; set; }
        public bool JeAktivna { get; set; }


        public SportskiObjekat? SportskiObjekat { get; set; }
        public List<RezervacijaOprema>? RezervacijaOprema { get; set; }
    }
}
