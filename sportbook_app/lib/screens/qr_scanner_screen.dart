import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; //ovo omogucava kameru za skeniranje koda
import '../services/api_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _scanned = false; //psotavljamo da qrkod na pocetku nije skeniran
  String? _poruka; //ovdje sam postavio takodjer da se ne ispisuje poruka nikakva u tom screenu

  Future<void> _onDetect(BarcodeCapture capture) async { //metoda koja se automatski pozove kada kamera skenira kod, BarcodeCapture je onaj qrkod koji kamera uhvati kada skenira
    if (_scanned) return; //ak je kod skenrian izadji iz ekrana
    final barcode = capture.barcodes.first; //uzmi prvi podatak tjst qrkod koji prepoznas odmah u Capture inad
    final kod = barcode.rawValue;//uzmi vrijednost qr koda - to je ono qrkod vrijednost
    if (kod == null) return; 

    setState(() => _scanned = true);

    final response = await ApiService.post('/Admin/skeniraj', {
      'kodVrijednost': kod,
    });

    if (response.statusCode == 200) {
      setState(() => _poruka = 'QR kod uspješno skeniran!');
    } else {
      setState(() => _poruka = '❌ Greška: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeniraj QR kod'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column( //Raspored jedno ispod drugog sve
        children: [
          Expanded(// zauzmi cijeli ekran, tipa kameru kad otvorimo ona cijeli ekran zauzme
            child: _poruka != null //Ternarni, ako nema poruke pozovi mobilesanner dole, ako ima uradi ovo ispod dole
                ? Center( //centriramo slj. sadrzaj horizontalno i vertikalno
                    child: Column( //unutar njega imamo raspored
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_poruka!, //garantujemo da poruka nije null jer smo je gore provjerili pa da nas flutter ne upozorava dzabe
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        ElevatedButton( //kreiramo novo dugme za ponovno skeniranje
                          onPressed: () => setState(() {
                            _scanned = false;
                            _poruka = null;
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Skeniraj ponovo'),
                        ),
                      ],
                    ),
                  )
                : MobileScanner(onDetect: _onDetect), //MobileScanner je widget koji prikazuje kameru na ekranu, parametar ondetect: kad prepoznas qr kod, pozovi metodu ondetect
          ),
        ],
      ),
    );
  }
}