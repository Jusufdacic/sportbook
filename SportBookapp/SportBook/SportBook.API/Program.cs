// Konfiguracija servisa i middleware, JWT, CORS, DI

using Microsoft.EntityFrameworkCore; //rad s bazom
using Microsoft.AspNetCore.Authentication.JwtBearer; //registracija middlewarea
using Microsoft.IdentityModel.Tokens; //iz bajta u simetrini kljuc 
using System.Text; //iz string u bajte tajni kljuc
using SportBook.API.Data; 


var builder = WebApplication.CreateBuilder(args); //bulder builda sve sto app treba prije rada, args je npr dotnet run --launch-profile http


builder.Services.AddControllers() //no besk 
    .AddJsonOptions(options => 
    {
        options.JsonSerializerOptions.ReferenceHandler =
            System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });


builder.Services.AddDbContext<SportBookContext>(options => //DI, u suprotnom bi u svaki controller var context = new SportBookContext(connectionString); 
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

//JWT AUTENTIFIKACIJA 

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme) //addaj i ukljuci jwt autentikaciju
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters //set pravila provjere
        {
           
            ValidateIssuerSigningKey = true, //token potpisan ispravnim kljucem

            IssuerSigningKey = new SymmetricSecurityKey( //provjera jel isti tajni kljuc koristimo
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!)),

            ValidateIssuer = false, //ne provjeravamo ko nam je izdao token

            ValidateAudience = false //ne provjeravamo za koga je token namijenjen
        };
    });


builder.Services.AddAuthorization();


// CORS cross origin resource sharing omogucava da frontend smije zvati backend preko browswera ako su na drugaicjim protovima, backend na 5029 a frontend nekom drugom


builder.Services.AddCors(options => //omoguci servise corsa kroz obejkat options dodaj politiku dotovle fluttera
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin() //svi zahtjevi s bilo koje adrese
              .AllowAnyMethod() //dozovli get, post, put, deflete
              .AllowAnyHeader(); //dozovli header u kojem je JWT
    });
});


var app = builder.Build(); //keriraj app iz svih prethodnih servisa




app.UseCors("AllowFlutter");

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers(); //aktivacija url

app.Run();
