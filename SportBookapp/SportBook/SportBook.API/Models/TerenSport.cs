namespace SportBook.API.Models
{
  
    public class TerenSport
    {
       
        public Guid Id { get; set; }
        public Guid IdTerena { get; set; }
        public Guid IdSporta { get; set; }
        public decimal CijenaPоSatu { get; set; }
        public bool JePrimarniSport { get; set; }

        
        public Teren? Teren { get; set; }
        public Sport? Sport { get; set; }
    }
}
