namespace SportBook.API.Models
{
  
    public class BlokadaTermina
    {
        
        public Guid IdBlokade { get; set; }
        public Guid IdTerena { get; set; }
        public Guid BlokiraoKorisnik { get; set; }
        public DateTime PocetakBlokade { get; set; }
        public DateTime KrajBlokade { get; set; }
        public string? Razlog { get; set; }


        public Teren? Teren { get; set; } //nav svojstva ne moraju po pravilu uvijek biti ucitana
        public Korisnik? Korisnik { get; set; }
    }
}
