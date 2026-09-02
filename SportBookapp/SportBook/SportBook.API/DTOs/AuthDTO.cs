namespace SportBook.API.DTOs
{

    public class RegisterDTO
    {

        public string Ime { get; set; } = string.Empty;
        public string Prezime { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Lozinka { get; set; } = string.Empty;
        public string? Telefon { get; set; }
    }

 
    public class LoginDTO
    {

        public string Email { get; set; } = string.Empty;
        public string Lozinka { get; set; } = string.Empty;
    }


    public class AuthResponseDTO
    {

        public string Token { get; set; } = string.Empty;
        public string IdKorisnika { get; set; } = string.Empty;
        public string Ime { get; set; } = string.Empty;
        public string Prezime { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Uloga { get; set; } = string.Empty;
    }
}
