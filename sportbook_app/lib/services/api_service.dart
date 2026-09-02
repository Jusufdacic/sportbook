//LOKALNA MEMORIJA APLIKACIJE MOJE
//'token' → mojJWT token
//'ime' → moje ime...


import 'dart:convert'; //jdson decode - jsonencode
import 'package:http/http.dart' as http; //omogucava slaje http zahtjeva npr http.post() 
import 'package:shared_preferences/shared_preferences.dart'; 

class ApiService { //klasa komuikacije  s bakcendom, dakle sve get, post i put zahtjeve saljemo kroz ovu klasu
  static const String baseUrl = 'http://172.20.10.8:5029/api'; //varijabla klase, ne objekta APiService.baseURL

  static Future<String?> getToken() async { 
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString('token'); 
  }

//registracija, login
  static Future<void> saveToken(String token) async { 
    final prefs = await SharedPreferences.getInstance(); 
    await prefs.setString('token', token); 
  }
//registracija, login
  static Future<void> saveKorisnik(String id, String ime, String uloga) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idKorisnika', id);
    await prefs.setString('ime', ime);
    await prefs.setString('uloga', uloga);
  }

//npr moje rezrvacije, flutter pozove u tom screenu final id = await ApiService.getIdKorisnika();
//id dobije vrijednost id korinika iz lokalne memorije jer ovo prodje kroz nju nadje kljuc i onda fltuter salje zahtjev
//ApiService.get('/Rezervacija/korisnik/$id');
  static Future<String?> getIdKorisnika() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idKorisnika');
  }


  static Future<String?> getUloga() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uloga');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); //loaklno memorijski, ne iz baze i baceknda
  }



//poziva se get metoda ApiService.get('/Rezervacija/korisnik/$id'); i ovo ulazi dole u Stringendpoint
//Unutar metode ispod se procita token jer ga metoda nadje u lokalnoj memoriji
//Spoji url 'http://192.168.0.35:5029/api/Rezervacija/korisnik/123-abc...'
//http.get salje zahtjev backendu na tu odrejdenu lokaciju uz header taj
//backend primi taj zahtjev, pretvori ga ono u dto, obradi ga i vrati json format i to return vrati screenu
//btw rekli so sta ocekuje backend, to samo uskaldisti u ovaj url flutter i posalje

  static Future<http.Response> get(String endpoint) async { 
    final token = await getToken(); 
    return http.get(
      Uri.parse('$baseUrl$endpoint'), 
      headers: { 
        'Content-Type': 'application/json', //baceknd, saljem ti json format podataka
        if (token != null) 'Authorization': 'Bearer $token', //ako token postoji dodaj authorization header, authorization da je uskladjeno s atributom Authorize na endpointu
      },
    );
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async { 
    final token = await getToken();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),  // mi smo gore u url.parse slal itacno sta zelimo sad samo ovdje dole imamo bosy koji saljemo
    );
  }


//otkazivanje rezervacije
  static Future<http.Response> put(String endpoint) async { //DAKLE OVA METODA SE DIREKTNO POZIVA I VRACA ODGOVOR BACKENDA
    final token = await getToken();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}