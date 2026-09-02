import 'package:flutter/material.dart';
import 'dart:convert'; 
import '../services/api_service.dart';
import 'qr_scanner_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState(); 
}

class _AdminScreenState extends State<AdminScreen> { 
  List<dynamic> _rezervacije = [];
  List<dynamic> _tereni = [];
  bool _isLoading = true; 
  final _qrController = TextEditingController(); 
  String? _qrPoruka;
  String? _selectedTerenId;
  DateTime _selectedDate = DateTime.now();
  String? _generisiPoruka;
  final _razlogController = TextEditingController(); 
  DateTime _pocetakBlokade = DateTime.now();
  DateTime _krajBlokade = DateTime.now().add(const Duration(hours: 2));
  String? _blokadaPoruka;

  @override
  void initState() { //ucitaj podatek iz baze automatski kad neko pozov metode te
    super.initState();
    _loadRezervacije();
    _loadTereni();
  }

  Future<void> _loadTereni() async {
    try {
      final response = await ApiService.get('/Teren');
      if (response.statusCode == 200) {
        setState(() => _tereni = jsonDecode(response.body));
      }
    } catch (e) {} 
  }

  Future<void> _loadRezervacije() async {
    try {
      final response = await ApiService.get('/Admin/rezervacije');
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

  Future<void> _skenirajQR() async {
    final response = await ApiService.post('/Admin/skeniraj', {
      'kodVrijednost': _qrController.text,
    });
    if (response.statusCode == 200) {
      setState(() => _qrPoruka = 'QR kod uspješno skeniran!');
    } else {
      setState(() => _qrPoruka = '❌ ${response.body}');//ovu poruku smo postavili u backendu
    }
  }

  Future<void> _generisiTermine() async {
    if (_selectedTerenId == null) {
      setState(() => _generisiPoruka = 'Odaberite teren!');
      return; //prekidamo fju odmah da unese teren
    }
    final datum = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'; //padLeft ako je mjesec 6, pretvori ga u 06
    final response = await ApiService.post('/Termin/generisi', {
      'idTerena': _selectedTerenId,
      'datum': datum,
    });
    if (response.statusCode == 200) {
  final body = response.body; //uzmi sadrzaj odgovora backenda
  if (body.contains('već postoje')) {
    setState(() => _generisiPoruka = 'Termini već postoje za ovaj dan!');
  } else {
    setState(() => _generisiPoruka = 'Termini uspješno generisani!');
  }
} else {
      setState(() => _generisiPoruka = '❌ ${response.body}'); //ispisi sto backend vrati
    }
  }

  Future<void> _blokirajTeren() async {
    if (_selectedTerenId == null) {
      setState(() => _blokadaPoruka = 'Odaberite teren!');
      return;
    }
    final token = await ApiService.getToken(); 
    final parts = token!.split('.'); // HEADER.PAYLOAD.SIGNATURE parts[0] header, parts[1] payload, parts[2] signature
    final payload = jsonDecode( //PAYLOAD sadrzi idkorisnika, mail, uloga, pretvaramo u dart mapu kljuc vrijednost tipa idKOrinsika : aib3b2biufb
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))) //uzme drugipayload, pretvori ga u byte pa u tekst normalan itd jer pc radi s bajtima...
    );
    final adminId = payload['IdKorisnika'];
    final response = await ApiService.post('/Admin/blokiraj', {
      'idTerena': _selectedTerenId,
      'idAdmina': adminId,
      'pocetakBlokade': _pocetakBlokade.toIso8601String(), //pretvara u string format koji razumije backned 
      'krajBlokade': _krajBlokade.toIso8601String(),
      'razlog': _razlogController.text,
    });
    if (response.statusCode == 200) {
      setState(() => _blokadaPoruka = 'Teren uspješno blokiran!');
    } else {
      setState(() => _blokadaPoruka = '❌ ${response.body}');
    }
  }

  Future<DateTime?> showDateTimePicker(BuildContext context, DateTime initial) async {//initial je pocetni datum, i tab se otvara u contextu
    final date = await showDatePicker( //ovo omogucava otvaranje kalendara
      context: context, //uzimamo ekran nas na kojem otvaramo kalendar
      initialDate: initial, //pocetni datum na kojem se otvara kalendar
      firstDate: DateTime.now(), //ne mozemo birati proslost
      lastDate: DateTime(2100),//do 2100. godine
    );
    if (date == null) return null; //ako cancela datum
    if (!context.mounted) return null; //vrati null tjst prekida fju ako admin dok je trazio kroz kalendar izadje
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial), //pocetno vrijeme u pikeru
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute); //spaja datum i vrijeme u jedan rezultat
  }

//generisanje termina pa biranje datuma
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, /pocetni datum pri otvaranju kalendara
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Widget _sekcija(String naziv, Widget child) { //fja koja vraca konkretan vildjivi element
    return Container( //iznad prima naslov i sadrzaj, ovo je metoda jer je svaki oblacic isti
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column( //unutrasnji sadrzaj ovog widgeta je jedan ispod drugog pa imamo u njemu listu naziv, ispod prazan porsto i ispod child
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(naziv,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Admin panel')),
      body: SingleChildScrollView( //omogucava scrollanje ekrana
        padding: const EdgeInsets.all(16),
        child: Column( //tekst unutar body pravimo kao raspored
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sekcija('Skeniraj QR kod', Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _qrController,
                  decoration: const InputDecoration(
                    labelText: 'QR kod vrijednost',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
                const SizedBox(height: 8),
                Row( //ovo su elementi oni jedni pored drugih poredani qrkod, obrisi isl.
                  children: [
                    Expanded( //uzimamo cijeli raspolozivi prostor u row do side boxa
                      child: ElevatedButton.icon( //napravi dugme i ubaci u row
                        onPressed: _skenirajQR,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Skeniraj'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const QrScannerScreen())), //prebaci na scrren qrscanner
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Kamerom'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ),
                  ],
                ),
                if (_qrPoruka != null) ...[
                  const SizedBox(height: 8),
                  Text(_qrPoruka!, style: const TextStyle(fontWeight: FontWeight.bold)), //prikazi skeniraj poruku ako se pojavi  jer imamo polje za unijeti kod ono
                ],
              ],
            )),

            _sekcija('Generiši termine', Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, //svi elementi unutar zauzimaj punu sirinu
              children: [
                DropdownButtonFormField<String>( //ovo kao select u css padajuci izbor
                  decoration: const InputDecoration(labelText: 'Odaberi teren'),
                  items: _tereni.map<DropdownMenuItem<String>>((teren) { //items su elementi dropdowna i teren desno predstavlja trenutni teren i ovo svaki teren stavlja u dropdown
                    return DropdownMenuItem<String>( //iz gore mape terena kao sto se cuvaju u bazi stavi jedan teren u  dropdown kao
                      value: teren['idTerena'],
                      child: Text(teren['naziv']),
                    );
                  }).toList(), //map vraca neki tip sto je iterable tako se zove i ropdown ne moze to korisiti vec samo listu
                  onChanged: (value) => setState(() => _selectedTerenId = value), //kad pritisne admin teren, desi se promjena, uzmi idkorisnika i osjvezi stranicu
                ),
                const SizedBox(height: 8),
                Row( //ovdje stvari slazemo horizontalno
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF2E7D32), size: 18),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _pickDate, //datum tekst ono kad se pritisne otvori kalenda
                      child: Text(
                        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                        style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _generisiTermine,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Generiši termine'),
                ),
                if (_generisiPoruka != null) ...[//provjeri ima li poruke, ako nema nastavi, ... kaze raspakiraj listu widgeta ovdje i dodaj ovaj jer children je jedna velika lista
                  const SizedBox(height: 8), //razmak i dekst poruke ispod dugmeta
                  Text(_generisiPoruka!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            )),

            _sekcija('Blokiraj teren', Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Odaberi teren'),
                  items: _tereni.map<DropdownMenuItem<String>>((teren) {
                    return DropdownMenuItem<String>(
                      value: teren['idTerena'],
                      child: Text(teren['naziv']),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedTerenId = value),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _razlogController,
                  decoration: const InputDecoration(labelText: 'Razlog blokade'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Početak: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDateTimePicker(context, _pocetakBlokade);
                        if (picked != null) setState(() => _pocetakBlokade = picked);
                      },
                      child: Text(
                        '${_pocetakBlokade.day}.${_pocetakBlokade.month}.${_pocetakBlokade.year} ${_pocetakBlokade.hour}:${_pocetakBlokade.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Kraj: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDateTimePicker(context, _krajBlokade);
                        if (picked != null) setState(() => _krajBlokade = picked);
                      },
                      child: Text(
                        '${_krajBlokade.day}.${_krajBlokade.month}.${_krajBlokade.year} ${_krajBlokade.hour}:${_krajBlokade.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _blokirajTeren,
                  icon: const Icon(Icons.block),
                  label: const Text('Blokiraj teren'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                if (_blokadaPoruka != null) ...[
                  const SizedBox(height: 8),
                  Text(_blokadaPoruka!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            )),

            _sekcija('Sve rezervacije', _isLoading //ternarni operator, ako se loada, prikazi kruzic uunutar ovog dijela, ako se ne priakzuje krug priakzi sve ispod: , a isloading smo definisali na pocetku gore u stae pa ako ga je neka metoda oborila na fals onda
                ? const Center(child: CircularProgressIndicator()) 
                : Column(
                    children: _rezervacije.map((rez) { //lista svih rezervacija, prodji kroz svaku rezervaciju jednu po jednu
                      final aktivna = rez['status'] == 'aktivna'; //provjeri jeli status rezervacije aktivan
                      return Container( //za svaku rezervaciju vracamo kontejner
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rez['korisnik']?['email'] ?? 'Nepoznat', //ispisi korisnika i mail, ako ga nema ispisi nepoznat
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (rez['termin'] != null) //ako termin postoji prikazi vrijeme
                                    Text(
                                      '${rez['termin']['datum']} • ${rez['termin']['pocetak'].substring(0, 5)}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  Text('${rez['ukupnaCijena']} KM',
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Container( //kontejner koji drzi status aktivan otkazan
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), //razmak od teksta 10px desno i lijevi i 4 gore i dole
                              decoration: BoxDecoration(
                                color: aktivna //pozadina badge ako je crvena ili zelena
                                    ? const Color(0xFF2E7D32).withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                rez['status'].toUpperCase(),
                                style: TextStyle(
                                  color: aktivna ? const Color(0xFF2E7D32) : Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(), //sve kontejnere stavljamo u listu da ih column moze pokazati
                  )),
          ],
        ),
      ),
    );
  }
}