import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'rezervacija_screen.dart';

class TerminScreen extends StatefulWidget {
  final String idTerena;
  final String nazivTerena;

  const TerminScreen({
    super.key,
    required this.idTerena,
    required this.nazivTerena,
  });

  @override
  State<TerminScreen> createState() => _TerminScreenState();
}

class _TerminScreenState extends State<TerminScreen> {
  List<dynamic> _termini = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTermini();
  }

  Future<void> _loadTermini() async {
    setState(() {
      _isLoading = true;
      _termini = [];
    });
    try {
      final datum = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
      final response = await ApiService.get('/Termin/${widget.idTerena}/$datum');
      if (response.statusCode == 200) {
        setState(() => _termini = jsonDecode(response.body));
      }
    } catch (e) {}
    finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadTermini();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: Text(widget.nazivTerena)),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Odaberi datum'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loadTermini,
                  child: const Text('Traži'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _termini.isEmpty
                    ? const Center(
                        child: Text('Nema termina za ovaj datum',
                            style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : ListView.builder(
                        key: ValueKey(_termini.length),
                        padding: const EdgeInsets.all(16),
                        itemCount: _termini.length,
                        itemBuilder: (context, index) {
                          final termin = _termini[index];
                          final slobodan = termin['status'] == 'slobodan';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: slobodan
                                      ? const Color(0xFF2E7D32).withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.access_time,
                                  color: slobodan ? const Color(0xFF2E7D32) : Colors.red,
                                ),
                              ),
                              title: Text(
                                '${termin['pocetak'].substring(0, 5)} - ${termin['kraj'].substring(0, 5)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text('${termin['cijena']} KM',
                                  style: const TextStyle(color: Colors.grey)),
                              trailing: slobodan
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RezervacijaScreen(
                                              idTermina: termin['idTermina'],
                                              pocetak: termin['pocetak'].substring(0, 5),
                                              kraj: termin['kraj'].substring(0, 5),
                                              cijena: termin['cijena'].toString(),
                                            ),
                                          ),
                                        );
                                        _loadTermini();
                                      },
                                      child: const Text('Rezerviši'),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text('Zauzeto',
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                                    ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}