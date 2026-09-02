import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //flutter biblioteka koja omogucava kopiranje teksta
import 'package:qr_flutter/qr_flutter.dart'; //omogucava generisanje qrkod slike
import 'home_screen.dart';

class QrScreen extends StatelessWidget {
  final String kodVrijednost; 

  const QrScreen({super.key, required this.kodVrijednost}); //kad zovemo ovaj screen, moramo posalti vrijendost qrkoda jer ne mzoemo otvoriti ovaj screen ako mu nemamov rijenost. Ovu vrijednost qr kod rezervacija kontroler sam aslje automatski preko navigatora

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('QR Kod')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.check_circle, //zelena kvacica na ekranu nakon skeniranja
                          color: Color(0xFF2E7D32), size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rezervacija uspješna!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pokažite QR kod na terenu',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    QrImageView( //KREIRA QRKOD SLIKU ovo uzme i napravi sliku na osnovu pdoataka ispod
                      data: kodVrijednost, //tekst iz backenda koji se enkodira u qrkod
                      version: QrVersions.auto, //ovo prilagodjavamo velicini ekrana gdje flutter sam izabere velicinu qrkod slike ovisno o size
                      size: 220,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //padding 16px desnolijevo i 8px goredole
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        kodVrijednost,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon( //elevatedbutton je dugme pravo, .icon s njime nagalsavamo da dugme ima ikonu
                      onPressed: () { //kad korisnik pritisne dugme izvrsi kod ispod
                        Clipboard.setData(ClipboardData(text: kodVrijednost)); //kopiramo pomocu Clipboard.setData ovaj CLippoardData() qrkod u nas ctrlc
                        ScaffoldMessenger.of(context).showSnackBar( //prikazi malu porukicu u ekranu tako sto pristupamo scaffold klasi  kroz context screen koja postavlja snackbar poruke tjst male poruke koje se krakto pojave i nestanu
                          const SnackBar(
                            content: Text('QR kod kopiran!'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy), //ikona kopiranja dugmeta za kopiranje
                      label: const Text('Kopiraj kod'), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () { //izvrsi kod isod kad pritisnes
                  Navigator.pushAndRemoveUntil( //prebaci korisnika na slj ekran i izbrisi prema uvjetu dole ovom route false 
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false, //obrisi sve ostale ekrane u stacku, dakle route je jedan ekran u stacku, a false obrisi taj ekran, i flutter prodje kroz svaki ekran u stacku tako
                  );
                },
                icon: const Icon(Icons.home), //ikona kucice
                label: const Text('Povratak na početnu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom( //ovo je laksi nacin jer u suprotnom bi morali pisati neki ButtonStyle objekat i pristupati preko njega
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32)), //simetrican razmak s obje strane
              ),
            ],
          ),
        ),
      ),
    );
  }
}