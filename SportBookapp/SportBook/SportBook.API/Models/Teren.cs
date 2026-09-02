namespace SportBook.API.Models
{
   
    public class Teren
    {
        
        public Guid IdTerena { get; set; }
        public Guid IdObjekta { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public string? TipPodloge { get; set; }
        public bool JeUnutarnji { get; set; }
        public int KapacitetIgraca { get; set; }
        public string? Opis { get; set; }
        public string? SlikaUrl { get; set; }
        public bool JeAktivan { get; set; }


        
        public SportskiObjekat? SportskiObjekat { get; set; }
        public List<TerenSport>? TerenSportovi { get; set; }
        public List<RadnoVrijeme>? RadnaVremena { get; set; }
        public List<Termin>? Termini { get; set; }
    }
}
