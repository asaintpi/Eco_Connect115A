import 'package:flutter/material.dart';
import 'profile_page.dart';  // Make sure this import points to your ProfilePage file

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Text('Home Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    const Text('Search Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    const Text('Jobs Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    ProfilePage(),  // Profile page included here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.business_center), label: 'Jobs'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
            ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.white,
              backgroundColor: Color(0xFF212121),
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
        ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
