using Microsoft.EntityFrameworkCore;
using SportBook.API.Models;

namespace SportBook.API.Data
{
    
    public class SportBookContext : DbContext
    {

        public SportBookContext(DbContextOptions<SportBookContext> options) : base(options) 
        {
        }


        public DbSet<Korisnik> Korisnici { get; set; }
        public DbSet<Uloga> Uloge { get; set; }
        public DbSet<KorisnikUloga> KorisnikUloge { get; set; }
        public DbSet<SportskiObjekat> SportskiObjekti { get; set; }
        public DbSet<Sport> Sportovi { get; set; }
        public DbSet<Teren> Tereni { get; set; }
        public DbSet<TerenSport> TerenSportovi { get; set; }
        public DbSet<RadnoVrijeme> RadnaVremena { get; set; }
        public DbSet<BlokadaTermina> BlokadeTermina { get; set; }
        public DbSet<Termin> Termini { get; set; }
        public DbSet<Rezervacija> Rezervacije { get; set; }
        public DbSet<QRKod> QRKodovi { get; set; }
        public DbSet<Oprema> Oprema { get; set; }
        public DbSet<RezervacijaOprema> RezervacijaOprema { get; set; }
        public DbSet<Recenzija> Recenzije { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
 
            modelBuilder.Entity<Korisnik>().ToTable("Korisnik").HasKey(k => k.IdKorisnika);
            modelBuilder.Entity<Uloga>().ToTable("Uloga").HasKey(u => u.IdUloge);
            modelBuilder.Entity<KorisnikUloga>().ToTable("KorisnikUloga").HasKey(ku => ku.Id);
            modelBuilder.Entity<SportskiObjekat>().ToTable("SportskiObjekat").HasKey(so => so.IdObjekta);
            modelBuilder.Entity<Sport>().ToTable("Sport").HasKey(s => s.IdSporta);
            modelBuilder.Entity<Teren>().ToTable("Teren").HasKey(t => t.IdTerena);
            modelBuilder.Entity<TerenSport>().ToTable("TerenSport").HasKey(ts => ts.Id);
            modelBuilder.Entity<RadnoVrijeme>().ToTable("RadnoVrijeme").HasKey(rv => rv.IdRadnogVremena);
            modelBuilder.Entity<BlokadaTermina>().ToTable("BlokadaTermina").HasKey(b => b.IdBlokade);
            modelBuilder.Entity<Termin>().ToTable("Termin").HasKey(t => t.IdTermina);
            modelBuilder.Entity<Rezervacija>().ToTable("Rezervacija").HasKey(r => r.IdRezervacije);
            modelBuilder.Entity<QRKod>().ToTable("QRKod").HasKey(q => q.IdQrKoda);
            modelBuilder.Entity<Oprema>().ToTable("Oprema").HasKey(o => o.IdOpreme);
            modelBuilder.Entity<RezervacijaOprema>().ToTable("RezervacijaOprema").HasKey(ro => ro.Id);
            modelBuilder.Entity<Recenzija>().ToTable("Recenzija").HasKey(r => r.IdRecenzije);



            modelBuilder.Entity<QRKod>()
                .HasOne(q => q.Rezervacija)
                .WithOne(r => r.QRKod)
                .HasForeignKey<QRKod>(q => q.IdRezervacije);


            modelBuilder.Entity<Recenzija>()
                .HasOne(r => r.Rezervacija)
                .WithOne(rez => rez.Recenzija)
                .HasForeignKey<Recenzija>(r => r.IdRezervacije);


            modelBuilder.Entity<Rezervacija>()
                .HasOne(r => r.Termin)
                .WithOne(t => t.Rezervacija)
                .HasForeignKey<Rezervacija>(r => r.IdTermina);

    
            modelBuilder.Entity<KorisnikUloga>()
                .HasOne(ku => ku.Korisnik)
                .WithMany(k => k.KorisnikUloge)
                .HasForeignKey(ku => ku.IdKorisnika);

           
            modelBuilder.Entity<KorisnikUloga>()
                .HasOne(ku => ku.Uloga)
                .WithMany()
                .HasForeignKey(ku => ku.IdUloge);


            modelBuilder.Entity<TerenSport>()
                .HasOne(ts => ts.Teren)
                .WithMany(t => t.TerenSportovi)
                .HasForeignKey(ts => ts.IdTerena);


            modelBuilder.Entity<TerenSport>()
                .HasOne(ts => ts.Sport)
                .WithMany(s => s.TerenSportovi)
                .HasForeignKey(ts => ts.IdSporta);


            modelBuilder.Entity<Teren>()
                .HasOne(t => t.SportskiObjekat)
                .WithMany(so => so.Tereni)
                .HasForeignKey(t => t.IdObjekta);


            modelBuilder.Entity<RadnoVrijeme>()
                .HasOne(rv => rv.Teren)
                .WithMany(t => t.RadnaVremena)
                .HasForeignKey(rv => rv.IdTerena);


            modelBuilder.Entity<Termin>()
                .HasOne(t => t.Teren)
                .WithMany(t => t.Termini)
                .HasForeignKey(t => t.IdTerena);


            modelBuilder.Entity<Termin>()
                .HasOne(t => t.Sport)
                .WithMany()
                .HasForeignKey(t => t.IdSporta);


            modelBuilder.Entity<Rezervacija>()
                .HasOne(r => r.Korisnik)
                .WithMany()
                .HasForeignKey(r => r.IdKorisnika);


            modelBuilder.Entity<Oprema>()
                .HasOne(o => o.SportskiObjekat)
                .WithMany(so => so.Oprema)
                .HasForeignKey(o => o.IdObjekta);


            modelBuilder.Entity<RezervacijaOprema>()
                .HasOne(ro => ro.Rezervacija)
                .WithMany(r => r.RezervacijaOprema)
                .HasForeignKey(ro => ro.IdRezervacije);


            modelBuilder.Entity<RezervacijaOprema>()
                .HasOne(ro => ro.Oprema)
                .WithMany(o => o.RezervacijaOprema)
                .HasForeignKey(ro => ro.IdOpreme);


            modelBuilder.Entity<BlokadaTermina>()
                .HasOne(b => b.Teren)
                .WithMany()
                .HasForeignKey(b => b.IdTerena);


            modelBuilder.Entity<BlokadaTermina>()
                .HasOne(b => b.Korisnik)
                .WithMany()
                .HasForeignKey(b => b.BlokiraoKorisnik);
        }
    }
}
