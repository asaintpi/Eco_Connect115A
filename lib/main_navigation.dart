import 'package:eco_connect/all_listings_page.dart';
import 'package:eco_connect/dm_page.dart';
import 'package:eco_connect/profile_page.dart';
import 'notification.dart';
import 'package:eco_connect/search_posts.dart';
import 'package:flutter/material.dart';


class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final List<Widget> pages = [AllListingsPage(), SearchPostsPage(), DMPage(), ProfilePage()];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        selectedItemColor: const Color(0xFF1DB954),
        backgroundColor: Colors.grey[850],
        // Darker grey for contrast
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType
            .fixed, // Fixed type f

      ),

    );
  }





}
