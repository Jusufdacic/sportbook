using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SportBook.API.Data;
using SportBook.API.Models;
using SportBook.API.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace SportBook.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class RezervacijaController : ControllerBase
    {
        private readonly SportBookContext _context;

        public RezervacijaController(SportBookContext context)
        {
            _context = context;
        }


        // Kreiramo novu rezervaciju za korisnika
        [HttpPost]
        public async Task<IActionResult> KreirajRezervaciju([FromBody] KreirajRezervacijuDTO dto)
        {

            var termin = await _context.Termini
                .FirstOrDefaultAsync(t => t.IdTermina == dto.IdTermina);

            if (termin == null)
                return NotFound("Termin nije pronađen.");

            if (termin.Status != "slobodan")
                return BadRequest("Termin nije slobodan.");

            // OVO ZA DODAtNU PROVJERU ALI NISAM KORISTIO
            var postojecaAktivnaRezervacija = await _context.Rezervacije
                .FirstOrDefaultAsync(r => r.IdTermina == dto.IdTermina && r.Status == "aktivna");

            if (postojecaAktivnaRezervacija != null)
                return BadRequest("Termin već ima aktivnu rezervaciju.");

            // todatetime spaja datum i vrijeme u jedno i tako su i u bazi spaseni, dole ispod bolje je terminPocetak
            var terminDatum = termin.Datum.ToDateTime(termin.Pocetak);  // Npr: 15.6.2026 10:00
            var terminKraj = termin.Datum.ToDateTime(termin.Kraj);       // Npr: 15.6.2026 11:00

            // Provjeravamo da li se preklapa termin s nekom blokadom
            var blokada = await _context.BlokadeTermina
                .FirstOrDefaultAsync(b => b.IdTerena == termin.IdTerena &&
                    b.PocetakBlokade <= terminKraj && //pocetak blokadene smije biti veci od kraja termina i obruto
                    b.KrajBlokade >= terminDatum);

            if (blokada != null)
                return BadRequest("Teren je blokiran u tom periodu.");

            //kreiramo rezervaciju
            var rezervacija = new Rezervacija
            {
                IdRezervacije = Guid.NewGuid(),
                IdKorisnika = dto.IdKorisnika,
                IdTermina = dto.IdTermina,
                DatumRezervacije = DateTime.Now,
                Status = "aktivna",
                UkupnaCijena = termin.Cijena,   
                StatusPlacanja = "na_cekanju",
                Napomena = dto.Napomena
            };


            termin.Status = "zauzet";

 
            var qrKod = new QRKod
            {
                IdQrKoda = Guid.NewGuid(),
                IdRezervacije = rezervacija.IdRezervacije,
                KodVrijednost = $"SPORTBOOK-{rezervacija.IdRezervacije}",  
                DatumGenerisanja = DateTime.Now,
                DatumIsteka = DateTime.Now.AddDays(7), 
                JeIskoristen = false
            };


            _context.Rezervacije.Add(rezervacija);
            _context.QRKodovi.Add(qrKod);
            _context.Termini.Update(termin);  


            await _context.SaveChangesAsync();

  
            return Ok(new { rezervacija, qrKod }); //ovdje nam flutter uzme qrkodvrijednost, a rezervaciju vracamo da bi flutter mogao znati id rezervacije i da bi mogo time manipulisati u tablu Moje rezervacije
        }

        // MOJE REZERVACIJE TAB
        [HttpGet("korisnik/{idKorisnika}")] 
        public async Task<IActionResult> GetRezervacijeKorisnika(Guid idKorisnika)
        {

            var rezervacije = await _context.Rezervacije
                .Include(r => r.Termin)
                    .ThenInclude(t => t!.Teren)   // t! = null-forgiving (znamo da nije null) jer se zna desiti da c# kompajler moze upozoravati bespotrebno da je ovo null vriejnost,a nije 100% jer termin ma teren a termin ima rezetrvaciju koju projveravamo 100%
                .Include(r => r.QRKod)
                .Where(r => r.IdKorisnika == idKorisnika)
                .OrderByDescending(r => r.DatumRezervacije)
                .Select(r => new { 
                    idRezervacije = r.IdRezervacije,
                    status = r.Status,
                    ukupnaCijena = r.UkupnaCijena,
                    datumRezervacije = r.DatumRezervacije,
                    napomena = r.Napomena,
                    qrKod = r.QRKod == null ? null : new {
                        kodVrijednost = r.QRKod.KodVrijednost //ako ima qrkod, vrati samo kodvrijednost
                    },
                    termin = r.Termin == null ? null : new {
                        datum = r.Termin.Datum,
                        pocetak = r.Termin.Pocetak,
                        kraj = r.Termin.Kraj,
                        nazivTerena = r.Termin.Teren != null ? r.Termin.Teren.Naziv : null 
                    }
                })
                .ToListAsync();

            return Ok(rezervacije);//korisnik moze imati vise rezervacija pa vracamo listu
        }


        // Otkazivanje aktivne rezervacije
        [HttpPut("{id}/otkazi")] //id rezervacije/otkazi u url
        public async Task<IActionResult> OtkaziRezervaciju(Guid id)
        {

            var rezervacija = await _context.Rezervacije
                .Include(r => r.Termin)
                .FirstOrDefaultAsync(r => r.IdRezervacije == id);

            if (rezervacija == null)
                return NotFound("Rezervacija nije pronađena.");

            if (rezervacija.Status == "otkazana")
                return BadRequest("Rezervacija je već otkazana.");

            rezervacija.Status = "otkazana";

            // ! = null-forgiving operator - znamo da Termin postoji jer smo ga Includali
            rezervacija.Termin!.Status = "slobodan";

            await _context.SaveChangesAsync();

            return Ok("Rezervacija uspješno otkazana.");
        }
    }
}
