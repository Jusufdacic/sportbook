using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SportBook.API.Data;
using SportBook.API.Models;
using SportBook.API.DTOs;

namespace SportBook.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OpremaController : ControllerBase
    {
        private readonly SportBookContext _context;

        public OpremaController(SportBookContext context)
        {
            _context = context;
        }


        // Vraća svu aktivnu opremu 
        [HttpGet]
        public async Task<IActionResult> GetSvaOprema()
        {

            var oprema = await _context.Oprema
                .Where(o => o.JeAktivna)
                .ToListAsync();

            return Ok(oprema); 
        }

  

        // Dodaje opremu uz postojeću rezervaciju
        [HttpPost("dodaj")]
        public async Task<IActionResult> DodajOpremu([FromBody] DodajOpremuDTO dto)
        {

            var rezervacija = await _context.Rezervacije
                .FirstOrDefaultAsync(r => r.IdRezervacije == dto.IdRezervacije);

            if (rezervacija == null)
                return NotFound("Rezervacija nije pronađena.");

            var oprema = await _context.Oprema
                .FirstOrDefaultAsync(o => o.IdOpreme == dto.IdOpreme);

            if (oprema == null)
                return NotFound("Oprema nije pronađena.");

            if (oprema.KolicinaDostupna < dto.Kolicina)
                return BadRequest("Nema dovoljno opreme na stanju."); //nama je kolicna uvijek 1 

            //Veza između rezervacije i opreme
            var rezervacijaOprema = new RezervacijaOprema
            {
                Id = Guid.NewGuid(),
                IdRezervacije = dto.IdRezervacije,
                IdOpreme = dto.IdOpreme,
                Kolicina = dto.Kolicina,
                // Ovo dole ima atribut u bazi, ali ne koristimo ga bas
                CijenaUkupno = oprema.CijenaPosudbe * dto.Kolicina
            };


            oprema.KolicinaDostupna -= dto.Kolicina;

            _context.RezervacijaOprema.Add(rezervacijaOprema);
            _context.Oprema.Update(oprema);
            await _context.SaveChangesAsync();

            return Ok(rezervacijaOprema); //ovo nista ne vraca i priakzuje na ekranu, ali radi buducih implementacija nije lose
        }
    }
}
