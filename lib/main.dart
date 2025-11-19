import 'package:flutter/material.dart';
//HEAD
import 'package:uts_sulastian_setiadi/ui/splash_screen.dart';
import 'package:uts_sulastian_setiadi/ui/login_screen.dart';
import 'package:uts_sulastian_setiadi/ui/register_screen.dart';
import 'package:uts_sulastian_setiadi/ui/home_screen.dart';

import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//HEAD
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/home_screen': (context) => const HomeScreen(),  
      },

      title: 'Movie App UI',
      theme: ThemeData.dark(),
      home: const MovieHomePage(),
    );
  }
}

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  //  DATA SECTION 
  final List<Map<String, String>> nowPlaying = [
    {
      'title': 'Deadpool & Wolverin',
      'image':
          'https://media-cache.cinematerial.com/p/500x/jaq8imk4/deadpool-wolverine-movie-poster.jpg?v=1718788116'
    },
    {
      'title': 'Inside Out 2',
      'image': 'http://www.impawards.com/2024/posters/med_inside_out_two_ver15.jpg'
    },
    {
      'title': 'Venom: The Last Dance',
      'image':
          'https://image.tmdb.org/t/p/original/vGXptEdgZIhPg3cGlc7e8sNPC2e.jpg'
    },
  ];

  final List<String> trending = [
    "https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg",
    "https://image.tmdb.org/t/p/original/vGXptEdgZIhPg3cGlc7e8sNPC2e.jpg",
    "https://image.tmdb.org/t/p/w500/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg",
  ];

  final List<String> popular = [
    "https://image.tmdb.org/t/p/w500/5mzr6JZbrqnqD8rCEvPhuCE5Fw2.jpg",
    "http://www.impawards.com/2019/posters/captain_marvel.jpg",
    "https://image.tmdb.org/t/p/original/75CrFwhW7R3ZFZk0KdJfZU1XG8Q.jpg",
  ];

  final List<String> topRated = [
    "https://image.tmdb.org/t/p/original/eEslKSwcqmiNS6va24Pbxf2UKmJ.jpg",
    "http://www.impawards.com/2025/posters/five_nights_at_freddys_two_ver3.jpg",
    "https://image.tmdb.org/t/p/w500/2CAL2433ZeIihfX1Hb2139CX0pW.jpg",
  ];

  @override
  void initState() {
    super.initState();
    // Auto-slide 3 detik
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < nowPlaying.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Now Playing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // AUTO SLIDE SECTION 
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: _pageController,
              itemCount: nowPlaying.length,
              itemBuilder: (context, index) {
                final movie = nowPlaying[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(movie['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          movie['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // SECTIONS
          _buildSection("Trending", trending),
          _buildSection("Popular", popular),
          _buildSection("Top Rated", topRated),
        ],
      ),

      //  BOTTOM NAVIGATION BAR 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
        ],
      ),
    );
  }

  //  SECTION BUILDER 
  Widget _buildSection(String title, List<String> posters) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          _buildHorizontalList(posters),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "More",
            style: TextStyle(color: Colors.redAccent.shade200),
          ),
        ],
      ),
    );
  }

  //  HORIZONTAL LIST 
  Widget _buildHorizontalList(List<String> posters) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posters.length,
        itemBuilder: (context, index) {
          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(posters[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),

    );
  }
}
