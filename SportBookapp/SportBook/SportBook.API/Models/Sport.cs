namespace SportBook.API.Models
{
    
    public class Sport
    {
        
        public Guid IdSporta { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public string? Opis { get; set; }
        public string? IkonaUrl { get; set; }


        public List<TerenSport>? TerenSportovi { get; set; }
    }
}
