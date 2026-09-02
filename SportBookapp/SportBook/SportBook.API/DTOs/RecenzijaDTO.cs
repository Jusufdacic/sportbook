namespace SportBook.API.DTOs
{

    public class DodajRecenzijuDTO
    {

        public Guid IdRezervacije { get; set; }
        public int Ocjena { get; set; }
        public string? Komentar { get; set; }
    }
}
