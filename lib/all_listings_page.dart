import 'package:flutter/material.dart';

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Search Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Jobs Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Profile Page', style: TextStyle(fontSize: 35, color: Colors.white)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
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
        selectedItemColor: const Color(0xFF1DB954),
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[850], // Darker grey for contrast
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Fixed type for better UI consistency
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AllListingsPage()));
}
