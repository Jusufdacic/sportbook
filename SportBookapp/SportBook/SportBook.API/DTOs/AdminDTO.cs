//DTO ne cuva podatke u bazi vec prenosi samo podatke izmedju frontenda i baceknda. Dakle on definise podatke koje frontend salje backendu 
//Razlog je sigurnost da ne prenosimo direktno sve podatke iz baze po zahtjevu
// OVO dakle DTO je kao formular koji endpointi sa metodama PUT, POST i DELETE najcesse korsite. dakle kada forntend hoce da posalje na url nekong endointa zahtjev, backend kaze da ocekuje podatke od frontenda deifnisane za taj specificni DTO, pa frontend posalje json, .net pretvori u dto format i napravi objeakt i radi s njim dakle radi s dto podacima, kad hoce odgovor da posalje nazad, on ga pretvori u json i salje

namespace SportBook.API.DTOs
{

    public class SkenirajQRDTO
    {

        public string KodVrijednost { get; set; } = string.Empty;
    }

    public class BlokirajTerminDTO
    {

        public Guid IdTerena { get; set; }
        public Guid IdAdmina { get; set; }
        public DateTime PocetakBlokade { get; set; }
        public DateTime KrajBlokade { get; set; }
        public string? Razlog { get; set; }
    }
}
