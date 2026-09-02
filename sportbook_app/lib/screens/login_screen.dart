import 'package:flutter/material.dart'; 
import 'dart:convert'; //jsdondecode u dart mapu
import '../services/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget { 
  const LoginScreen({super.key}); 

  @override
  State<LoginScreen> createState() => _LoginScreenState(); 
}

class _LoginScreenState extends State<LoginScreen> { 
  final _emailController = TextEditingController(); 
  final _lozinkaController = TextEditingController(); 
  bool _isLoading = false; 
  String? _error;

  Future<void> _login() async { 
    await ApiService.logout();
    setState(() { 
      _isLoading = true; 
      _error = null;
    });

    try { //sad nakon onog gore pokusavamo ovo izvrsiti
      final response = await ApiService.post('/Auth/login', { 
        'email': _emailController.text,
        'lozinka': _lozinkaController.text,
      });

      if (response.statusCode == 200) { 
        final data = jsonDecode(response.body);
        await ApiService.saveToken(data['token']);
        await ApiService.saveKorisnik(
          data['idKorisnika'].toString(),
          data['ime'],
          data['uloga'],
        );

        if (mounted) { 
          Navigator.pushReplacement( 
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()), 
          );
        }
      } else {
        setState(() => _error = 'Pogrešan email ili lozinka.');
      }
    } catch (e) {
      setState(() => _error = 'Greška pri povezivanju s serverom.'); 
    } finally {
      setState(() => _isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea( //safeare osigurava da se sadrzaj prikaze na ekranu i da nigdje nije sakriven tipa iznad statusne trake gore iznad na ekranu pa da pocinje ispod nje
        child: Center( 
          child: SingleChildScrollView( //ovo omogucava da kada tipa na ekranu otvorim tastaturu da dok nam je otvoreno mi nju mozemo scrollati gore dole
            padding: const EdgeInsets.all(24.0), 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Container( 
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration( 
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow( //sjena kvadrata za ljepsi dizajn
                        color: const Color(0xFF2E7D32).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.sports, size: 56, color: Colors.white),//unutar kvardata tog generisemo ikonu koja je bijela i velicine 56 i to pomocu ugradjene flutter ikone
                ),
                const SizedBox(height: 24), //prazan prostor izmedju teksta i kvadrata
                const Text(
                  'SportBook',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                    letterSpacing: 1.2, //razmak izmedju slova
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rezervacija sportskih terena',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),
                Card( //polje za unos emaila i lozinke i toga
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, //Razvuci polje za unos 
                      children: [
                        TextField(
                          controller: _emailController, //CONTROLLLLERRRRRRRRRRRRR KOJI PRATI
                          decoration: const InputDecoration( 
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress, //tastatura se otvara priagodjena za mail
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _lozinkaController,
                          decoration: const InputDecoration(
                            labelText: 'Lozinka',
                            prefixIcon: Icon(Icons.lock_outlined),
                          ),
                          obscureText: true, //ovo prikazuje tackice umjesto plaintexta
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
                            child: Text(_error!,
                                style: TextStyle(color: Colors.red.shade700)),
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login, //onpresses sta se desi kad pritisemo dugme prijava
                          child: _isLoading //iznad je ternarni operator, ako se loada onda je null i ne radi na klik, a ako nije kliknuto onda poziva login
                              ? const SizedBox( //ovdje isto teranrni, ako se loada ovo, ako ne ono dole
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator( //bijeli spiner unutar dugmeta
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Prijava',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12), //ovo je onaj zeleni tekst dole nemate racun
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute( //animacija prelaza ekrana
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Text('Nemate račun? Registrujte se',
                              style: TextStyle(color: Color(0xFF2E7D32))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}