import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'teren_detalji_screen.dart';

class TerenScreen extends StatefulWidget {
  const TerenScreen({super.key});

  @override
  State<TerenScreen> createState() => _TerenScreenState();
}

class _TerenScreenState extends State<TerenScreen> {
  List<dynamic> _tereni = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTereni();
  }

  Future<void> _loadTereni() async {
    try {
      final response = await ApiService.get('/Teren');
      if (response.statusCode == 200) {
        setState(() {
          final lista = jsonDecode(response.body) as List;
          lista.sort((a, b) => a['naziv'].compareTo(b['naziv']));
         _tereni = lista;
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
      appBar: AppBar(
        title: const Text('Tereni'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tereni.length,
              itemBuilder: (context, index) {
                final teren = _tereni[index];
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
                      child: const Icon(Icons.sports_tennis,
                          color: Color(0xFF2E7D32)),
                    ),
                    title: Text(teren['naziv'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(teren['tipPodloge'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TerenDetaljiScreen(teren: teren),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}