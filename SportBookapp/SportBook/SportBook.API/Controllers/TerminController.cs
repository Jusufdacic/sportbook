using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using SportBook.API.Data;
using SportBook.API.DTOs;
using SportBook.API.Models;

namespace SportBook.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TerminController : ControllerBase
    {
        private readonly SportBookContext _context;

        public TerminController(SportBookContext context)
        {
            _context = context;
        }

        // Vraća listu termina za određeni teren na određeni datum
        [HttpGet("{idTerena}/{datum}")]
        public async Task<IActionResult> GetTermini(Guid idTerena, DateOnly datum)
        {
  
            var teren = await _context.Tereni
                .FirstOrDefaultAsync(t => t.IdTerena == idTerena);

            if (teren == null)
                return NotFound("Teren nije pronađen.");

            var termini = await _context.Termini
                .Where(t => t.IdTerena == idTerena && t.Datum == datum)
                .OrderBy(t => t.Pocetak)
                .ToListAsync();

            return Ok(termini);
        }

        // Automatski generiše termine za teren na određeni datum na osnovu radnog vremena
        [Authorize(Roles = "administrator")]
        [HttpPost("generisi")]
        public async Task<IActionResult> GeneriziTermine([FromBody] GeneriziTermineDTO dto)
        {
  
            var radnoVrijeme = await _context.RadnaVremena 
                .FirstOrDefaultAsync(rv => rv.IdTerena == dto.IdTerena &&
                    rv.DanUSedmici == (short)dto.Datum.DayOfWeek); //danusedmici

            if (radnoVrijeme == null)
                return BadRequest("Teren ne radi taj dan.");

            var postojeciTermini = await _context.Termini
                .Where(t => t.IdTerena == dto.IdTerena && t.Datum == dto.Datum)
                .ToListAsync();

            if (postojeciTermini.Any())
                return Ok("Termini već postoje za taj dan.");

            // Dohvacamo primarni sport terena 
            var terenSport = await _context.TerenSportovi
                .FirstOrDefaultAsync(ts => ts.IdTerena == dto.IdTerena &&
                    ts.JePrimarniSport); //jedan teren moze imat ivise sportova, a to koji je primarni sport na terenu odredjuje i cijenu samog temrina i zato ga provjeravamo

            if (terenSport == null)
                return BadRequest("Teren nema definisan sport.");

            if (radnoVrijeme.TrajanjeTerminaMin <= 0)
                return BadRequest("Trajanje termina mora biti veće od 0 minuta.");

            //GENERISANJE TERMINA
            var termini = new List<Termin>();
            var trenutnoVrijeme = radnoVrijeme.PocetakRada; 

            while (trenutnoVrijeme.Add(TimeSpan.FromMinutes(radnoVrijeme.TrajanjeTerminaMin))
                <= radnoVrijeme.KrajRada)
            {
                termini.Add(new Termin
                {
                    IdTermina = Guid.NewGuid(),
                    IdTerena = dto.IdTerena,
                    IdSporta = terenSport.IdSporta, //pri genrisanju termina nam je bitan gore terensport jer u bazi imamo ovo
                    Datum = dto.Datum,
                    Pocetak = trenutnoVrijeme,
                    Kraj = trenutnoVrijeme.Add(TimeSpan.FromMinutes(radnoVrijeme.TrajanjeTerminaMin)),
                    Cijena = terenSport.CijenaPоSatu,  
                    Status = "slobodan"               
                });

                
                trenutnoVrijeme = trenutnoVrijeme.Add(
                    TimeSpan.FromMinutes(radnoVrijeme.TrajanjeTerminaMin));
            }

            await _context.Termini.AddRangeAsync(termini); //ovo dodaje cijelu onu gore listu add.termini odjednom u tabelu
            await _context.SaveChangesAsync();  

            return Ok(termini);  
        }
    }
}
