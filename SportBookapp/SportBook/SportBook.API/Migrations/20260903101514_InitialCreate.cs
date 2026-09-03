using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SportBook.API.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    IdKorisnika = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnik", x => x.IdKorisnika);
                });

            migrationBuilder.CreateTable(
                name: "Sport",
                columns: table => new
                {
                    IdSporta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IkonaUrl = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sport", x => x.IdSporta);
                });

            migrationBuilder.CreateTable(
                name: "SportskiObjekat",
                columns: table => new
                {
                    IdObjekta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Grad = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SportskiObjekat", x => x.IdObjekta);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    IdUloge = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloga", x => x.IdUloge);
                });

            migrationBuilder.CreateTable(
                name: "Oprema",
                columns: table => new
                {
                    IdOpreme = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdObjekta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CijenaPosudbe = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    KolicinaDostupna = table.Column<int>(type: "int", nullable: false),
                    JeAktivna = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Oprema", x => x.IdOpreme);
                    table.ForeignKey(
                        name: "FK_Oprema_SportskiObjekat_IdObjekta",
                        column: x => x.IdObjekta,
                        principalTable: "SportskiObjekat",
                        principalColumn: "IdObjekta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Teren",
                columns: table => new
                {
                    IdTerena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdObjekta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TipPodloge = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    JeUnutarnji = table.Column<bool>(type: "bit", nullable: false),
                    KapacitetIgraca = table.Column<int>(type: "int", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SlikaUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Teren", x => x.IdTerena);
                    table.ForeignKey(
                        name: "FK_Teren_SportskiObjekat_IdObjekta",
                        column: x => x.IdObjekta,
                        principalTable: "SportskiObjekat",
                        principalColumn: "IdObjekta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KorisnikUloga",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdKorisnika = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdUloge = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DatumDodjele = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisnikUloga", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KorisnikUloga_Korisnik_IdKorisnika",
                        column: x => x.IdKorisnika,
                        principalTable: "Korisnik",
                        principalColumn: "IdKorisnika",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KorisnikUloga_Uloga_IdUloge",
                        column: x => x.IdUloge,
                        principalTable: "Uloga",
                        principalColumn: "IdUloge",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BlokadaTermina",
                columns: table => new
                {
                    IdBlokade = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdTerena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    BlokiraoKorisnik = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PocetakBlokade = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KrajBlokade = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Razlog = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BlokadaTermina", x => x.IdBlokade);
                    table.ForeignKey(
                        name: "FK_BlokadaTermina_Korisnik_BlokiraoKorisnik",
                        column: x => x.BlokiraoKorisnik,
                        principalTable: "Korisnik",
                        principalColumn: "IdKorisnika",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BlokadaTermina_Teren_IdTerena",
                        column: x => x.IdTerena,
                        principalTable: "Teren",
                        principalColumn: "IdTerena",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RadnoVrijeme",
                columns: table => new
                {
                    IdRadnogVremena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdTerena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DanUSedmici = table.Column<short>(type: "smallint", nullable: false),
                    PocetakRada = table.Column<TimeOnly>(type: "time", nullable: false),
                    KrajRada = table.Column<TimeOnly>(type: "time", nullable: false),
                    TrajanjeTerminaMin = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RadnoVrijeme", x => x.IdRadnogVremena);
                    table.ForeignKey(
                        name: "FK_RadnoVrijeme_Teren_IdTerena",
                        column: x => x.IdTerena,
                        principalTable: "Teren",
                        principalColumn: "IdTerena",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "TerenSport",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdTerena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdSporta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CijenaPоSatu = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    JePrimarniSport = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TerenSport", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TerenSport_Sport_IdSporta",
                        column: x => x.IdSporta,
                        principalTable: "Sport",
                        principalColumn: "IdSporta",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TerenSport_Teren_IdTerena",
                        column: x => x.IdTerena,
                        principalTable: "Teren",
                        principalColumn: "IdTerena",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    IdTermina = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdTerena = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdSporta = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Datum = table.Column<DateOnly>(type: "date", nullable: false),
                    Pocetak = table.Column<TimeOnly>(type: "time", nullable: false),
                    Kraj = table.Column<TimeOnly>(type: "time", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Termin", x => x.IdTermina);
                    table.ForeignKey(
                        name: "FK_Termin_Sport_IdSporta",
                        column: x => x.IdSporta,
                        principalTable: "Sport",
                        principalColumn: "IdSporta",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Termin_Teren_IdTerena",
                        column: x => x.IdTerena,
                        principalTable: "Teren",
                        principalColumn: "IdTerena",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Rezervacija",
                columns: table => new
                {
                    IdRezervacije = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdKorisnika = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdTermina = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DatumRezervacije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UkupnaCijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StatusPlacanja = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Napomena = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rezervacija", x => x.IdRezervacije);
                    table.ForeignKey(
                        name: "FK_Rezervacija_Korisnik_IdKorisnika",
                        column: x => x.IdKorisnika,
                        principalTable: "Korisnik",
                        principalColumn: "IdKorisnika",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Rezervacija_Termin_IdTermina",
                        column: x => x.IdTermina,
                        principalTable: "Termin",
                        principalColumn: "IdTermina",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "QRKod",
                columns: table => new
                {
                    IdQrKoda = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdRezervacije = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KodVrijednost = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumGenerisanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumIsteka = table.Column<DateTime>(type: "datetime2", nullable: false),
                    JeIskoristen = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_QRKod", x => x.IdQrKoda);
                    table.ForeignKey(
                        name: "FK_QRKod_Rezervacija_IdRezervacije",
                        column: x => x.IdRezervacije,
                        principalTable: "Rezervacija",
                        principalColumn: "IdRezervacije",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Recenzija",
                columns: table => new
                {
                    IdRecenzije = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdRezervacije = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false),
                    JeOdobrena = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Recenzija", x => x.IdRecenzije);
                    table.ForeignKey(
                        name: "FK_Recenzija_Rezervacija_IdRezervacije",
                        column: x => x.IdRezervacije,
                        principalTable: "Rezervacija",
                        principalColumn: "IdRezervacije",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RezervacijaOprema",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdRezervacije = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IdOpreme = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false),
                    CijenaUkupno = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RezervacijaOprema", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RezervacijaOprema_Oprema_IdOpreme",
                        column: x => x.IdOpreme,
                        principalTable: "Oprema",
                        principalColumn: "IdOpreme",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RezervacijaOprema_Rezervacija_IdRezervacije",
                        column: x => x.IdRezervacije,
                        principalTable: "Rezervacija",
                        principalColumn: "IdRezervacije",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BlokadaTermina_BlokiraoKorisnik",
                table: "BlokadaTermina",
                column: "BlokiraoKorisnik");

            migrationBuilder.CreateIndex(
                name: "IX_BlokadaTermina_IdTerena",
                table: "BlokadaTermina",
                column: "IdTerena");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_IdKorisnika",
                table: "KorisnikUloga",
                column: "IdKorisnika");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_IdUloge",
                table: "KorisnikUloga",
                column: "IdUloge");

            migrationBuilder.CreateIndex(
                name: "IX_Oprema_IdObjekta",
                table: "Oprema",
                column: "IdObjekta");

            migrationBuilder.CreateIndex(
                name: "IX_QRKod_IdRezervacije",
                table: "QRKod",
                column: "IdRezervacije",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RadnoVrijeme_IdTerena",
                table: "RadnoVrijeme",
                column: "IdTerena");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_IdRezervacije",
                table: "Recenzija",
                column: "IdRezervacije",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_IdKorisnika",
                table: "Rezervacija",
                column: "IdKorisnika");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_IdTermina",
                table: "Rezervacija",
                column: "IdTermina",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RezervacijaOprema_IdOpreme",
                table: "RezervacijaOprema",
                column: "IdOpreme");

            migrationBuilder.CreateIndex(
                name: "IX_RezervacijaOprema_IdRezervacije",
                table: "RezervacijaOprema",
                column: "IdRezervacije");

            migrationBuilder.CreateIndex(
                name: "IX_Teren_IdObjekta",
                table: "Teren",
                column: "IdObjekta");

            migrationBuilder.CreateIndex(
                name: "IX_TerenSport_IdSporta",
                table: "TerenSport",
                column: "IdSporta");

            migrationBuilder.CreateIndex(
                name: "IX_TerenSport_IdTerena",
                table: "TerenSport",
                column: "IdTerena");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_IdSporta",
                table: "Termin",
                column: "IdSporta");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_IdTerena",
                table: "Termin",
                column: "IdTerena");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BlokadaTermina");

            migrationBuilder.DropTable(
                name: "KorisnikUloga");

            migrationBuilder.DropTable(
                name: "QRKod");

            migrationBuilder.DropTable(
                name: "RadnoVrijeme");

            migrationBuilder.DropTable(
                name: "Recenzija");

            migrationBuilder.DropTable(
                name: "RezervacijaOprema");

            migrationBuilder.DropTable(
                name: "TerenSport");

            migrationBuilder.DropTable(
                name: "Uloga");

            migrationBuilder.DropTable(
                name: "Oprema");

            migrationBuilder.DropTable(
                name: "Rezervacija");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Sport");

            migrationBuilder.DropTable(
                name: "Teren");

            migrationBuilder.DropTable(
                name: "SportskiObjekat");
        }
    }
}
