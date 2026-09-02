import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'termin_screen.dart';

class TerenDetaljiScreen extends StatefulWidget {
  final Map<String, dynamic> teren;

  const TerenDetaljiScreen({super.key, required this.teren});

  @override
  State<TerenDetaljiScreen> createState() => _TerenDetaljiScreenState();
}

class _TerenDetaljiScreenState extends State<TerenDetaljiScreen> {
  List<dynamic> _recenzije = [];
  Map<String, dynamic>? _terenDetalji;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetalji();
    _loadRecenzije();
  }

  Future<void> _loadDetalji() async {
    try {
      final response = await ApiService.get('/Teren/${widget.teren['idTerena']}');
      if (response.statusCode == 200) {
        setState(() => _terenDetalji = jsonDecode(response.body));
      }
    } catch (e) {}
  }

  Future<void> _loadRecenzije() async {
    try {
      final response = await ApiService.get('/Recenzija/teren/${widget.teren['idTerena']}');
      if (response.statusCode == 200) {
        setState(() {
          _recenzije = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teren = _terenDetalji ?? widget.teren;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: Text(teren['naziv'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teren['naziv'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _infoRed(Icons.layers, 'Podloga', teren['tipPodloge'] ?? 'N/A'),
                  _infoRed(Icons.people, 'Kapacitet', '${teren['kapacitetIgraca']} igrača'),
                  _infoRed(Icons.home, 'Tip', teren['jeUnutarnji'] ? 'Unutarnji' : 'Vanjski'),
                  if (_terenDetalji != null && _terenDetalji!['radnaVremena'] != null) ...[
                    const SizedBox(height: 12),
                    const Text('Radna vremena:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...((_terenDetalji!['radnaVremena'] as List)
                        ..sort((a, b) {
                          int da = a['danUSedmici'] == 0 ? 7 : a['danUSedmici'];
                          int db = b['danUSedmici'] == 0 ? 7 : b['danUSedmici'];
                          return da.compareTo(db);
                        }))
                        .map((rv) {
                      const dani = ['Ned', 'Pon', 'Uto', 'Sri', 'Čet', 'Pet', 'Sub'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Color(0xFF2E7D32)),
                            const SizedBox(width: 8),
                            Text('${dani[rv['danUSedmici']]}: ${rv['pocetakRada'].substring(0, 5)} - ${rv['krajRada'].substring(0, 5)}'),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => TerminScreen(idTerena: teren['idTerena'], nazivTerena: teren['naziv']),
  ));
},
              icon: const Icon(Icons.calendar_today),
              label: const Text('Rezerviši termin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
            const SizedBox(height: 24),
            const Text('Recenzije', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recenzije.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: const Center(child: Text('Nema recenzija za ovaj teren.', style: TextStyle(color: Colors.grey))),
                      )
                    : Column(
                        children: _recenzije.map((rec) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: List.generate(5, (i) => Icon(
                                    i < rec['ocjena'] ? Icons.star : Icons.star_border,
                                    color: Colors.amber, size: 20,
                                  )),
                                ),
                                if (rec['komentar'] != null && rec['komentar'].isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(rec['komentar']),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  rec['rezervacija']?['korisnik']?['ime'] ?? 'Anonimno',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _infoRed(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}