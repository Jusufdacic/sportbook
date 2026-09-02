namespace SportBook.API.DTOs
{

    public class DodajOpremuDTO
    {

        public Guid IdRezervacije { get; set; }
        public Guid IdOpreme { get; set; }
        public int Kolicina { get; set; }
    }
}
