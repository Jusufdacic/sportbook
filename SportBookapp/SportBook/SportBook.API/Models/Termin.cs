namespace SportBook.API.Models
{
   
    public class Termin
    {
     
        public Guid IdTermina { get; set; }
        public Guid IdTerena { get; set; }
        public Guid IdSporta { get; set; }
        public DateOnly Datum { get; set; }
        public TimeOnly Pocetak { get; set; }
        public TimeOnly Kraj { get; set; }
        public decimal Cijena { get; set; }
        public string Status { get; set; } = "slobodan";

        

        public Teren? Teren { get; set; }
        public Sport? Sport { get; set; }
        public Rezervacija? Rezervacija { get; set; }
    }
}
