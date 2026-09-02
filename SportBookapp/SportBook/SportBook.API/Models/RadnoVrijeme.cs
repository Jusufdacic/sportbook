namespace SportBook.API.Models
{
    
    public class RadnoVrijeme
    {
        
        public Guid IdRadnogVremena { get; set; }
        public Guid IdTerena { get; set; }
        public short DanUSedmici { get; set; }
        public TimeOnly PocetakRada { get; set; }
        public TimeOnly KrajRada { get; set; }
        public int TrajanjeTerminaMin { get; set; }


        public Teren? Teren { get; set; }
    }
}
