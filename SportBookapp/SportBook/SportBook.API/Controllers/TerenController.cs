using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SportBook.API.Data;
using SportBook.API.Models;

namespace SportBook.API.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class TerenController : ControllerBase
    {
        private readonly SportBookContext _context;

        public TerenController(SportBookContext context)
        {
            _context = context;
        }

        // Vraćamo listu svih aktivnih terena s prosječnom ocjenom
        [HttpGet] 
        public async Task<IActionResult> GetSviTereni()
        {
      
            var tereni = await _context.Tereni
                .Where(t => t.JeAktivan)
                .Select(t => new {
                    idTerena = t.IdTerena,
                    naziv = t.Naziv,
                    tipPodloge = t.TipPodloge,
                    jeUnutarnji = t.JeUnutarnji,
                    kapacitetIgraca = t.KapacitetIgraca,
                    prosjecnaOcjena = _context.Recenzije
                    .Where(r => r.JeOdobrena && r.Rezervacija.Termin.IdTerena == t.IdTerena) //r je recenzija
                    .Average(r => (double?)r.Ocjena)
                    })

                .ToListAsync(); 

            return Ok(tereni);  
        }


        // Vraća detalje jednog terena po ID-u 
        [HttpGet("{id}")]
        public async Task<IActionResult> GetTeren(Guid id)
        {

            var teren = await _context.Tereni
                .Include(t => t.TerenSportovi)
                    .ThenInclude(ts => ts.Sport)
                .Include(t => t.RadnaVremena)  
                .FirstOrDefaultAsync(t => t.IdTerena == id);

            
            if (teren == null)
                return NotFound("Teren nije pronađen."); //HTTP 404 je ovo

            // Kreiramo objekat s podacima koje šaljemo Flutteru
            var rezultat = new {
                idTerena = teren.IdTerena,
                naziv = teren.Naziv,
                tipPodloge = teren.TipPodloge,
                jeUnutarnji = teren.JeUnutarnji,
                kapacitetIgraca = teren.KapacitetIgraca,
                terenSportovi = teren.TerenSportovi,
                radnaVremena = teren.RadnaVremena.Select(rv => new { 
                    danUSedmici = (int)rv.DanUSedmici,    // jer je u bazi int
                    pocetakRada = rv.PocetakRada,
                    krajRada = rv.KrajRada,
                    trajanjeTerminaMin = rv.TrajanjeTerminaMin
                })
            };

            return Ok(rezultat);
        }

        // Vraća listu svih sportova u sistemu (za ekran "Sportovi" u Flutteru)
        [HttpGet("sportovi")]
        public async Task<IActionResult> GetSviSportovi()
        {

            var sportovi = await _context.Sportovi
                .ToListAsync();

            return Ok(sportovi);
        }
    }
}
