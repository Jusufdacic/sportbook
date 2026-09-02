import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'qr_screen.dart';

class RezervacijaScreen extends StatefulWidget {
  final String idTermina; //podaci koje primamo od drugog screena kad navigiramo na ovaj
  final String pocetak; //ovi podaci konkretno dolaze iz teren screena
  final String kraj; 
  final String cijena;

  const RezervacijaScreen({
    super.key,
    required this.idTermina,
    required this.pocetak,
    required this.kraj,
    required this.cijena,
  });

  @override
  State<RezervacijaScreen> createState() => _RezervacijaScreenState();
}

class _RezervacijaScreenState extends State<RezervacijaScreen> {
  final _napomenaController = TextEditingController(); //stvari tjst stanja koja se mijenjaju tokom koristenja ekrana
  bool _isLoading = false; 
  String? _error;

  Future<void> _kreirajRezervaciju() async { 
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await ApiService.getToken(); 
      final parts = token!.split('.'); //header.payload.signature
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))) //pretvori u dart mapu
      );
      final idKorisnika = payload['IdKorisnika']; 

      final response = await ApiService.post('/Rezervacija', { 
        'idKorisnika': idKorisnika,
        'idTermina': widget.idTermina, 
        'napomena': _napomenaController.text,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); 
        final qrKodVrijednost = data['qrKod']['kodVrijednost']; 

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => QrScreen(kodVrijednost: qrKodVrijednost), //OVDJE PROSLJEDJUJEMO VRIJEDNOST U WIDGET KLASU QRSCREENA
            ),
          );
        }
      } else {
        setState(() => _error = response.body.isNotEmpty ? response.body : 'Greška pri rezervaciji.'); //ima li teksta u odgovoru, ako ima ispisi ga, ako nema ispisi gresku
      }
    } catch (e) { 
      setState(() => _error = 'Greška: $e'); 
    } finally { //uvijek na kraju sta god da se desi ukloni spinner
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Rezervacija')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column( //unutar body kreiramo raspored
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ //unutar columna imamo listu kao i uvijek
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detalji termina',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Color(0xFF2E7D32), size: 20),
                      const SizedBox(width: 8),
                      Text('${widget.pocetak} - ${widget.kraj}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.payments, color: Color(0xFF2E7D32), size: 20),
                      const SizedBox(width: 8),
                      Text('${widget.cijena} KM',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _napomenaController,
              decoration: const InputDecoration(
                labelText: 'Napomena (opcionalno)',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(_error!, style: TextStyle(color: Colors.red.shade700)),
              ),
            ],
            const Spacer(), //popunjava sav prazan prostor izmedju widgeta ispod i dugmeta ispod
            ElevatedButton(
              onPressed: _isLoading ? null : _kreirajRezervaciju, //ako ternarno nije null, pozovi tu metodu
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Potvrdi rezervaciju',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}