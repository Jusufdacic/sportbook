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
    public class RecenzijaController : ControllerBase
    {
        private readonly SportBookContext _context;

        public RecenzijaController(SportBookContext context)
        {
            _context = context;
        }


        // Dodaje novu recenziju za termin koji je već prošao
        [Authorize]
        [HttpPost] 
        public async Task<IActionResult> DodajRecenziju([FromBody] DodajRecenzijuDTO dto)
        {

            var rezervacija = await _context.Rezervacije
                .Include(r => r.Termin)
                .FirstOrDefaultAsync(r => r.IdRezervacije == dto.IdRezervacije);

            if (rezervacija == null)
                return NotFound("Rezervacija nije pronađena.");

            if (rezervacija.Status != "aktivna")
                return BadRequest("Rezervacija nije aktivna.");

            if (rezervacija.Termin == null || rezervacija.Termin.Datum > DateOnly.FromDateTime(DateTime.Now)) 
                return BadRequest("Recenziju možete ostaviti tek nakon što termin prođe.");


            var postojecaRecenzija = await _context.Recenzije
                .FirstOrDefaultAsync(r => r.IdRezervacije == dto.IdRezervacije);

            if (postojecaRecenzija != null)
                return BadRequest("Recenzija za ovu rezervaciju već postoji.");

            // Nova recenzije
            var recenzija = new Recenzija
            {
                IdRecenzije = Guid.NewGuid(),
                IdRezervacije = dto.IdRezervacije,
                Ocjena = dto.Ocjena,
                Komentar = dto.Komentar,
                Datum = DateTime.Now,
                JeOdobrena = true  
            };

            _context.Recenzije.Add(recenzija);
            await _context.SaveChangesAsync();

            return Ok(recenzija);
        }


        // Vraća sve recenzije za određeni teren, sortirane od najnovijih
        [HttpGet("teren/{idTerena}")]
        public async Task<IActionResult> GetRecenzijeTerana(Guid idTerena)
        {
            
            var recenzije = await _context.Recenzije
                .Include(r => r.Rezervacija)
                    .ThenInclude(rez => rez.Korisnik)    
                .Include(r => r.Rezervacija)
                    .ThenInclude(rez => rez.Termin)        // Za filtriranje po IdTerena jer to mozemo samo naci u tabeli termina koja je veza izmedju njih
                .Where(r => r.Rezervacija.Termin.IdTerena == idTerena && r.JeOdobrena)
                .OrderByDescending(r => r.Datum)
                .Select(r => new {
                    idRecenzije = r.IdRecenzije,
                    ocjena = r.Ocjena,
                    komentar = r.Komentar,
                    datum = r.Datum,
                    rezervacija = new {
                        korisnik = new {
                            ime = r.Rezervacija.Korisnik.Ime 
                        }
                    }
                })
                .ToListAsync();

            return Ok(recenzije);
        }
    }
}
