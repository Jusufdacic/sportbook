//ovdje ce cijela app pokrece kroz main fju, ovdje definisem boje, dugmadi i pozadinu za cijelu aplikaciju
import 'package:flutter/material.dart'; //ovo nudi sve atribute fluttera da korisimo, widgeti
import 'screens/login_screen.dart'; 

void main() {
  runApp(const SportBookApp()); //pokrece nasu aplikaciju sportbook
}

class SportBookApp extends StatelessWidget { //klasa koja nudi raspored svih widgeta, crtanje ui, stateless je jer ovdje definisemo fiksne stvari za sve screenove
  const SportBookApp({super.key}); 

  @override 
  Widget build(BuildContext context) { 

    return MaterialApp( //scoffuld je za ekran kostur, a ovo je kad hocemo ispod da se primjeni na cijeli ekran
      title: 'SportBook', //ovo je naziv aplikacije na mobitelu koji pise
      debugShowCheckedModeBanner: false, //posto pokrecemo aplikaciju u flutter run, pise crvenim debug dugme i ovo ga sakrije
      theme: ThemeData( //sta ovdje definisemo se primjenjuje na scaki dio aplikacije
        useMaterial3: true, //najnoviji google dizajn, pravila kako dugmadi izgledaju u apliakciji i sl
        colorScheme: ColorScheme.fromSeed(//uzimamo boju i iz te boje cu ja generisati meni potrebne boje to je vo oform Seed
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme( 
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0, //bez sjene
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( //za sva dugmad
          style: ElevatedButton.styleFrom( 
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder( //zaobljeni pravougaonik
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme( //sva polja za unos
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder( //promjena okvira kad kliknem na dugme
            borderRadius: BorderRadius.circular(12), 
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2), 
          ),
        ),
      ),
      home: LoginScreen(), 
    );
  }
}