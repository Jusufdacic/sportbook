import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';

class OpremaScreen extends StatefulWidget {
  final String idRezervacije;

  const OpremaScreen({super.key, required this.idRezervacije});

  @override
  State<OpremaScreen> createState() => _OpremaScreenState();
}

class _OpremaScreenState extends State<OpremaScreen> {
  List<dynamic> _oprema = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOprema();
  }

  Future<void> _loadOprema() async {
    try {
      final response = await ApiService.get('/Oprema/989861a6-bce3-49cd-8644-3f98466419bf');
      if (response.statusCode == 200) {
        setState(() {
          _oprema = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _dodajOpremu(String idOpreme, int kolicina) async {
    final response = await ApiService.post('/Oprema/dodaj', {
      'idRezervacije': widget.idRezervacije,
      'idOpreme': idOpreme,
      'kolicina': kolicina,
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oprema dodana uspješno!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      _loadOprema();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška pri dodavanju opreme.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Oprema')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _oprema.isEmpty
              ? const Center(
                  child: Text('Nema dostupne opreme',
                      style: TextStyle(color: Colors.grey, fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _oprema.length,
                  itemBuilder: (context, index) {
                    final oprema = _oprema[index];
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
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.sports_handball,
                                  color: Color(0xFF2E7D32)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(oprema['naziv'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                      '${oprema['cijenaPosudbe']} KM • Dostupno: ${oprema['kolicinaDostupna']}',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: oprema['kolicinaDostupna'] > 0
                                  ? () => _dodajOpremu(oprema['idOpreme'], 1)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              child: const Text('Dodaj'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}