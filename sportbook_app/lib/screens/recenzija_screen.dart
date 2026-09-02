import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';

class RecenzijaScreen extends StatefulWidget {
  final String idRezervacije;

  const RecenzijaScreen({super.key, required this.idRezervacije});

  @override
  State<RecenzijaScreen> createState() => _RecenzijaScreenState();
}

class _RecenzijaScreenState extends State<RecenzijaScreen> {
  int _ocjena = 5;
  final _komentarController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _uspjeh;

  Future<void> _dodajRecenziju() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _uspjeh = null;
    });

    try {
      final response = await ApiService.post('/Recenzija', {
        'idRezervacije': widget.idRezervacije,
        'ocjena': _ocjena,
        'komentar': _komentarController.text,
      });

      if (response.statusCode == 200) {
        setState(() => _uspjeh = 'Recenzija uspješno dodana!');
      } else {
        setState(() => _error = 'Već ste ostavili recenziju za ovu rezervaciju.');;
      }
    } catch (e) {
      setState(() => _error = 'Greška pri dodavanju recenzije.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Ostavi recenziju')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vaša ocjena',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => setState(() => _ocjena = index + 1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < _ocjena ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 48,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _ocjena == 1 ? 'Loše' :
                      _ocjena == 2 ? 'Može biti bolje' :
                      _ocjena == 3 ? 'Prosječno' :
                      _ocjena == 4 ? 'Dobro' : 'Odlično!',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _komentarController,
              decoration: const InputDecoration(
                labelText: 'Komentar (opcionalno)',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
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
            if (_uspjeh != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                ),
                child: Text(_uspjeh!,
                    style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _dodajRecenziju,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18)),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Pošalji recenziju',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}