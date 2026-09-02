namespace SportBook.API.Models
{

    public class RezervacijaOprema
    {

        public Guid Id { get; set; }
        public Guid IdRezervacije { get; set; }
        public Guid IdOpreme { get; set; }
        public int Kolicina { get; set; }
        public decimal CijenaUkupno { get; set; }

  
        public Rezervacija? Rezervacija { get; set; }
        public Oprema? Oprema { get; set; }
    }
}
