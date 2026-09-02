import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';

class SporToviScreen extends StatefulWidget {
  const SporToviScreen({super.key});

  @override
  State<SporToviScreen> createState() => _SporToviScreenState();
}

class _SporToviScreenState extends State<SporToviScreen> {
  List<dynamic> _sportovi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSportovi();
  }

  Future<void> _loadSportovi() async {
    try {
      final response = await ApiService.get('/Teren/sportovi');
      if (response.statusCode == 200) {
        setState(() {
          _sportovi = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Sportovi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sportovi.length,
              itemBuilder: (context, index) {
                final sport = _sportovi[index];
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sports,
                          color: Color(0xFF2E7D32)),
                    ),
                    title: Text(sport['naziv'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(sport['opis'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}