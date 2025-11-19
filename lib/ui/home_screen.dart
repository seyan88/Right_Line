import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sahur;
  final String imsak;

  PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sahur,
    required this.imsak,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
      sahur: json['Fajr'],
      imsak: json['Imsak'] ?? json['Fajr'],
    );
  }
}

// Class masjid
class Mosque {
  final String name;
  final LatLng location;

  Mosque({required this.name, required this.location});
}

List<Mosque> mosques = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? userLocation;
  PrayerTimes? prayerTimes;

  String userName = "User";

  int _selectedIndex = 0; // 0 Adzan - 1 Map - 2 About

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      setState(() {
        userName = args != null ? args.split('@').first : 'User';
      });
    });
    _determinePosition();
  }

  //  AMBIL LOKASI USER 
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      userLocation = LatLng(pos.latitude, pos.longitude);
    });

    _fetchPrayerTimes();
    _fetchNearbyMosques(); // 🔥 ambil masjid terdekat
  }

  //  JADWAL SHOLAT
  Future<void> _fetchPrayerTimes() async {
    if (userLocation == null) return;

    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final url = Uri.parse(
        'http://api.aladhan.com/v1/timings/$date?latitude=${userLocation!.latitude}&longitude=${userLocation!.longitude}&method=2');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        prayerTimes = PrayerTimes.fromJson(data['data']['timings']);
      });
    }
  }

  //  MASJID TERDEKAT 
  Future<void> _fetchNearbyMosques() async {
    if (userLocation == null) return;

    final lat = userLocation!.latitude;
    final lon = userLocation!.longitude;

    final overpassUrl = Uri.parse(
      'https://overpass-api.de/api/interpreter?data=[out:json];'
      '(node["amenity"="place_of_worship"]["religion"="muslim"](around:2000,$lat,$lon););out;',
    );

    final response = await http.get(overpassUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<Mosque> fetched = [];

      for (var e in data["elements"]) {
        final name = e["tags"]?["name"] ?? "Masjid";
        final lat = e["lat"];
        final lon = e["lon"];

        fetched.add(
          Mosque(
            name: name,
            location: LatLng(lat, lon),
          ),
        );
      }

      setState(() {
        mosques = fetched;
      });
    }
  }

  //  NAVIGASI GOOGLE MAPS 
  Future<void> _openGoogleMapsNavigation(LatLng from, LatLng to) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&travelmode=driving');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  //  LOGOUT 
 Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();

  //  hapus session login.
  await prefs.remove('isLoggedIn');
  await prefs.remove('currentUser');

  if (!mounted) return;

  Navigator.pushReplacementNamed(context, '/login_screen');
}

  //  UI MAP
  Widget _buildMap() {
    if (userLocation == null) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: userLocation!,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),

        // Marker User
        MarkerLayer(
          markers: [
            Marker(
              point: userLocation!,
              width: 40,
              height: 40,
              child: const Icon(Icons.my_location,
                  color: Colors.blue, size: 32),
            ),
            // Marker Masjid
            ...mosques.map(
              (m) => Marker(
                point: m.location,
                width: 200,
                height: 60,
                child: GestureDetector(
                  onTap: () =>
                      _openGoogleMapsNavigation(userLocation!, m.location),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.red, size: 38),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  //  LIST SHOLAT 
  Widget _buildPrayerList() {
    if (prayerTimes == null) {
      return const Center(child: Text("Memuat jadwal..."));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _timeCard("Sahur", prayerTimes!.sahur),
        _timeCard("Imsak", prayerTimes!.imsak),
        _timeCard("Subuh", prayerTimes!.fajr),
        _timeCard("Dzuhur", prayerTimes!.dhuhr),
        _timeCard("Ashar", prayerTimes!.asr),
        _timeCard("Maghrib", prayerTimes!.maghrib),
        _timeCard("Isya", prayerTimes!.isha),
      ],
    );
  }

  Widget _timeCard(String label, String time) {
    return Card(
      color: Colors.teal.shade50,
      child: ListTile(
        leading: Icon(Icons.access_time, color: Colors.teal.shade400),
        title: Text(label),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //  ABOUT 
  Widget _buildAbout() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "About Aplikasi\n\nAplikasi ini dibuat untuk keperluan UTS / Proyek.Pemograman Mobile 2 \n\n© 2025 - Sulastian Setiadi_ 23552011342",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  //  SELECT PAGE 
  Widget _buildPage() {
    if (_selectedIndex == 0) return _buildPrayerList();
    if (_selectedIndex == 1) return _buildMap();
    return _buildAbout();
  }

  //  BUILD 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hallo, $userName"),
        backgroundColor: Colors.teal.shade600,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: null,
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(color: Colors.teal.shade600),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Jam Adzan"),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Peta Masjid"),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),

      body: _buildPage(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade500,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: "Adzan"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}
