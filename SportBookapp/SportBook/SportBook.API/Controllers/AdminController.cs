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
    [Authorize(Roles = "administrator")]
    public class AdminController : ControllerBase
    {
        private readonly SportBookContext _context; 

        public AdminController(SportBookContext context)
        {
            _context = context;
        }

  
        // Vraća sve rezervacije u sistemu (admin pregled)
        [HttpGet("rezervacije")]
        public async Task<IActionResult> GetSveRezervacije() 
        {

            var rezervacije = await _context.Rezervacije
                .Include(r => r.Korisnik)
                .Include(r => r.Termin)
                .OrderByDescending(r => r.DatumRezervacije)
                .ToListAsync();

            return Ok(rezervacije);
        }


        // Admin skenira QR kod korisnika na ulazu u teren
        [HttpPost("skeniraj")]
        public async Task<IActionResult> SkenirajQRKod([FromBody] SkenirajQRDTO dto) 
        {

            var qrKod = await _context.QRKodovi
                .Include(q => q.Rezervacija)
                .FirstOrDefaultAsync(q => q.KodVrijednost == dto.KodVrijednost);


            if (qrKod == null)
                return NotFound("QR kod nije pronađen.");

            if (qrKod.JeIskoristen)
                return BadRequest("QR kod je već iskorišten.");

            if (qrKod.DatumIsteka < DateTime.Now)
                return BadRequest("QR kod je istekao.");

            qrKod.JeIskoristen = true; //ovo je da sprjecimo da vise puta skeniramo kod

            await _context.SaveChangesAsync();

            
            return Ok(new { poruka = "QR kod uspješno skeniran.", rezervacija = qrKod.Rezervacija }); //anonimni objekat, rezervacije = qrkod.rezervacija nam ne treba, ali za neku buducu nadogradnju jer ono sadrzi sve neke podatke vezane konkretno za taj qrkod
        }


        [HttpPost("blokiraj")]
        public async Task<IActionResult> BlokirajTermin([FromBody] BlokirajTerminDTO dto)
        {

            var teren = await _context.Tereni
                .FirstOrDefaultAsync(t => t.IdTerena == dto.IdTerena);
            if (teren == null)
                return NotFound("Teren nije pronađen.");

            var blokada = new BlokadaTermina
            {
                IdBlokade = Guid.NewGuid(),
                IdTerena = dto.IdTerena, //ovdje stavimo status jer ako teren jeste ovdje znaci da e blokiran i time nedostupan
                BlokiraoKorisnik = dto.IdAdmina,        
                PocetakBlokade = dto.PocetakBlokade,
                KrajBlokade = dto.KrajBlokade,
                Razlog = dto.Razlog
            };

            _context.BlokadeTermina.Add(blokada);
            await _context.SaveChangesAsync();

            return Ok(blokada);
        }
    }
}
