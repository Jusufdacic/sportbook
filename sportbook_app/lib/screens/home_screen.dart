import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'teren_screen.dart';
import 'login_screen.dart';
import 'moje_rezervacije_screen.dart';
import 'admin_screen.dart';
import 'sportovi_screen.dart';

class HomeScreen extends StatefulWidget { 
  const HomeScreen({super.key}); 

  @override
  State<HomeScreen> createState() => _HomeScreenState();  
}

class _HomeScreenState extends State<HomeScreen> { 
  String _uloga = ''; //ovo polje cemo mijenjati

  @override
  void initState() { //pozivamo metodu za ucitavanje podataka iz baze tjst backenda uvijek
    super.initState(); // moramo takodjer pozvati i istu metodu na bazi klase nase glavne da bi radilo
    _loadKorisnik();// primjenjujemo konkretne podatke od korisnika
  }

  Future<void> _loadKorisnik() async { 
    final uloga = await ApiService.getUloga(); 
    setState(() {
      _uloga = uloga ?? '';
    });
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), 
      );
    }
  }

  Widget _kartica({ //metoda koja kreira sve one panele na ekranu, pozovemo je i vrati konkertan widget, al posto su panel isvi slicni onda kreiramo zajednicku koju cemo pozivati
    required IconData icon, //svaki panel ima ikonu, naziv, opis, sta se desi kad se klikne, boju neobaveznu defaul je zelena
    required String naziv,
    required String opis,
    required VoidCallback onPressed, //ocekuje funkciju koju kad pozovemo ono se izvrsi
    Color? boja,
  }) {
    return InkWell( //ova metoda vraca klikabilni kontejner kad je pozovemo i koji izgleda:
      onTap: onPressed, //pozovi onpresed fju kad pritisnemo a nju smo definisali dole kasnije
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [ //blaga crna sjena ispod kartice, al ovo je lista sjenajer kao kontejner mozeimati vise sjena
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4), //pomjera sjenu prema dole
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container( //mali kvadrat s ikonom gore lijevo
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: (boja ?? const Color(0xFF2E7D32)).withOpacity(0.1), //default zelena boja ako nije prosljedjena
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: boja ?? const Color(0xFF2E7D32), size: 28), //ikona s podraz. zeleonom bojom, ovo smo gore u kartici definisali
            ),
            const SizedBox(height: 16),
            Text(naziv,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(opis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //FULL EKRANNNNN
    return Scaffold( 
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar( //bar onaj iznad gore s podebljanim tekstom
        title: const Text('SportBook', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton( //dugme s desne strane
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Odjava',
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '© 2026 SportBook • Rezervacija sportskih terena',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
      body: SingleChildScrollView( //omogucava scrollanje ekrana
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,//banner dobrodosli admin, sirok kolko i ekran
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient( //ovo omgoucava da boja tamnozel u svzelenu s desna
                  colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row( //unutar zelenog kontejnera deifisnemo sad redove
                children: [ //unutar row stavi vise stvari jedno pored druge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16), 
                  Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dobrodošli!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      Text(_uloga.toUpperCase(), //varijabla iz lokalne memorije definisana gore a startu na pocetku
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              letterSpacing: 1.2)), //razmak izmedju slova
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), 
            Center( //centriraj dijete wrap koje sadrzi sve kartice da kartice budu u sredini ne na pocetku u redu
              child: Wrap( //redaj jedno pored drugo, ako ne mogu stati prelomi u red ispod
                spacing: 16,//razmak izmedju kartica desno i lijevo
                runSpacing: 16, //razmak izmedju akrtica gore i dole
                alignment: WrapAlignment.center, //karitce su centrirane i ako se prelome, centiraj ih u slj redu. OVo centrira kartice unutar wrapa, npr ako prelome u slj red, a ono gore Center full ovaj prozor znaci svih akrtica
                children: [ 
                  _kartica(
                    icon: Icons.sports_tennis,
                    naziv: 'Tereni',
                    opis: 'Pregledaj dostupne terene',
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TerenScreen())),
                  ),
                  _kartica(
                    icon: Icons.sports,
                    naziv: 'Sportovi',
                    opis: 'Dostupni sportovi',
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SporToviScreen())),
                  ),
                  _kartica(
                    icon: Icons.calendar_today,
                    naziv: 'Moje rezervacije',
                    opis: 'Pregled rezervacija',
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MojeRezervacijeScreen())),
                  ),
                  if (_uloga == 'administrator')
                    _kartica(
                      icon: Icons.admin_panel_settings,
                      naziv: 'Admin panel',
                      opis: 'Upravljanje sistemom',
                      boja: const Color(0xFFC62828),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AdminScreen())),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}