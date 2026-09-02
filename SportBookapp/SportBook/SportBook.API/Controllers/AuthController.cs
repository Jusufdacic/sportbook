using Microsoft.AspNetCore.Mvc; //atributi [ApiController], [HttpPost], Ok(), IActionResult
using Microsoft.EntityFrameworkCore; // AnyAsync(), FirstOrDefaultAsync()
using Microsoft.IdentityModel.Tokens; // SymmetricSecurityKey 
using System.IdentityModel.Tokens.Jwt; // geneisanje tokena
using System.Security.Claims; 
using System.Text;
using SportBook.API.Data;
using SportBook.API.DTOs;
using SportBook.API.Models;

namespace SportBook.API.Controllers
{
    // [Route("api/[controller]")] - ruta je /api/Auth 
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase //nasljedjujemo klasu ugradjenu koja omogucava Ok, Bad i sl.
    {

        private readonly SportBookContext _context; //readonly postavi jednom i ne mijenja se nikad
        private readonly IConfiguration _configuration;

 
        public AuthController(SportBookContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterDTO dto) 
        {
        

            if (await _context.Korisnici.AnyAsync(k => k.Email == dto.Email)) 
                return BadRequest("Korisnik s tim emailom vec postoji.");


            var lozinkaHash = BCrypt.Net.BCrypt.HashPassword(dto.Lozinka);

            // Kreiranje novog Korisnik objekta koji će se sačuvati u bazi
            var korisnik = new Korisnik
            {
                IdKorisnika = Guid.NewGuid(),
                Ime = dto.Ime,
                Prezime = dto.Prezime,
                Email = dto.Email,
                LozinkaHash = lozinkaHash,  
                Telefon = dto.Telefon,
                DatumRegistracije = DateTime.Now,
                JeAktivan = true
            };


            _context.Korisnici.Add(korisnik);

            var ulogaKlijent = await _context.Uloge.FirstOrDefaultAsync(u => u.Naziv == "klijent");
            if (ulogaKlijent != null)
            {
                _context.KorisnikUloge.Add(new KorisnikUloga
                {
                    Id = Guid.NewGuid(),
                    IdKorisnika = korisnik.IdKorisnika,
                    IdUloge = ulogaKlijent.IdUloge,
                    DatumDodjele = DateTime.Now
                });
            }


            await _context.SaveChangesAsync();

            var token = GenerisiToken(korisnik, "klijent");

  
            return Ok(new AuthResponseDTO 
            {
                Token = token,
                IdKorisnika = korisnik.IdKorisnika.ToString(),
                Ime = korisnik.Ime,
                Prezime = korisnik.Prezime,
                Email = korisnik.Email,
                Uloga = "klijent"
            });
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDTO dto)
        {

            var korisnik = await _context.Korisnici
                .Include(k => k.KorisnikUloge)
                    .ThenInclude(ku => ku.Uloga)
                .FirstOrDefaultAsync(k => k.Email == dto.Email);

            if (korisnik == null || !BCrypt.Net.BCrypt.Verify(dto.Lozinka, korisnik.LozinkaHash)) 
                return Unauthorized("Pogrešan email ili lozinka.");


            var uloga = korisnik.KorisnikUloge?.FirstOrDefault()?.Uloga?.Naziv ?? "klijent";
          
            // Generiši JWT token
            var token = GenerisiToken(korisnik, uloga);

   
            return Ok(new AuthResponseDTO
            {
                Token = token,
                IdKorisnika = korisnik.IdKorisnika.ToString(),
                Ime = korisnik.Ime,
                Prezime = korisnik.Prezime,
                Email = korisnik.Email,
                Uloga = uloga
            });
        }

        // Odgovor: JWT eader.Payload (claims).Signature
        private string GenerisiToken(Korisnik korisnik, string uloga)
        {
            
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                _configuration["Jwt:Key"] ?? "DefaultSecretKey12345678901234567890"));


            var claims = new[]
            {
                new Claim("IdKorisnika", korisnik.IdKorisnika.ToString()),  
                new Claim(ClaimTypes.Email, korisnik.Email),                 
                new Claim(ClaimTypes.Role, uloga)                            
            };


            var token = new JwtSecurityToken( //header se interno kreira
                claims: claims,
                expires: DateTime.Now.AddDays(7),
                signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
            );

            return new JwtSecurityTokenHandler().WriteToken(token); 
        }
    }
}
