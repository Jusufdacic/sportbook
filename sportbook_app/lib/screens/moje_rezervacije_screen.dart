import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'oprema_screen.dart';
import 'recenzija_screen.dart';

class MojeRezervacijeScreen extends StatefulWidget {
  const MojeRezervacijeScreen({super.key});

  @override
  State<MojeRezervacijeScreen> createState() => _MojeRezervacijeScreenState();
}

class _MojeRezervacijeScreenState extends State<MojeRezervacijeScreen> {
  List<dynamic> _rezervacije = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRezervacije();
  }

  Future<void> _loadRezervacije() async {
    try {
      final idKorisnika = await ApiService.getIdKorisnika();
      final response = await ApiService.get('/Rezervacija/korisnik/$idKorisnika');
      if (response.statusCode == 200) {
        setState(() {
          _rezervacije = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _otkaziRezervaciju(String idRezervacije) async {
    final response = await ApiService.put('/Rezervacija/$idRezervacije/otkazi');
    if (response.statusCode == 200) {
      _loadRezervacije();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Moje rezervacije')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rezervacije.isEmpty
              ? const Center(
                  child: Text('Nemate rezervacija',
                      style: TextStyle(color: Colors.grey, fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rezervacije.length,
                  itemBuilder: (context, index) {
                    final rez = _rezervacije[index];
                    final aktivna = rez['status'] == 'aktivna';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: aktivna
                                        ? const Color(0xFF2E7D32).withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    rez['status'].toUpperCase(),
                                    style: TextStyle(
                                      color: aktivna
                                          ? const Color(0xFF2E7D32)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${rez['ukupnaCijena']} KM',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (rez['termin'] != null) ...[
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Color(0xFF2E7D32)),
                                  const SizedBox(width: 8),
                                  Text('${rez['termin']['datum']}'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16, color: Color(0xFF2E7D32)),
                                  const SizedBox(width: 8),
                                  Text(
                                      '${rez['termin']['pocetak'].substring(0, 5)} - ${rez['termin']['kraj'].substring(0, 5)}'),
                                ],
                              ),
                            ],
                            if (rez['napomena'] != null &&
                                rez['napomena'].isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.note,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(rez['napomena'],
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                            if (aktivna) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _otkaziRezervaciju(
                                        rez['idRezervacije']),
                                    icon: const Icon(Icons.cancel, size: 16),
                                    label: const Text('Otkaži'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => OpremaScreen(
                                              idRezervacije:
                                                  rez['idRezervacije']),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.sports_handball,
                                        size: 16),
                                    label: const Text('Oprema'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RecenzijaScreen(
                                              idRezervacije:
                                                  rez['idRezervacije']),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.star, size: 16),
                                    label: const Text('Recenzija'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}