import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:cosmic_explorer/screens/login_screen.dart';
import 'package:cosmic_explorer/screens/celestial_gallery_screen.dart';
import 'package:cosmic_explorer/screens/favorites_screen.dart';
import 'package:cosmic_explorer/screens/profile_screen.dart';
import 'package:cosmic_explorer/screens/folders_screen.dart';
import 'package:cosmic_explorer/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 2;
  bool? _isLoggedIn;
  late List<Widget> _widgetOptions;

  _MyAppState();

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
    _widgetOptions = <Widget>[
      FoldersScreen(),
      FavoritesScreen(),
      CelestialGalleryScreen(),
      SearchScreen(),
      ProfileScreen(updateLoginStatus: _updateLoginStatus),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateLoginStatus(bool isLoggedIn) {
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celestial Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _getHomeScreen(),
    );
  }

  Widget _getHomeScreen() {
    if (_isLoggedIn!) {
      return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Folders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Gallery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      );
    } else {
      return LoginScreen(updateLoginStatus: _updateLoginStatus);
    }
  }
}
