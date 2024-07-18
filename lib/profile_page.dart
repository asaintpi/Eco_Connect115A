import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_page.dart';  // Import the Edit Profile Page
import 'all_listings_page.dart';  // Import the All Listings Page
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'globalstate.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Index for 'Profile', assuming it's the fourth item
  String name = ''; // Placeholder name
  String bio = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    getUserDataByPhone();
    _loadProfileImage();
  }

  Future<void> getUserDataByPhone() async {
    final database = FirebaseDatabase.instance.ref();
    final phone = Provider.of<UserState>(context, listen: false).phone;
    try {
      // Query the 'users' node for entries where 'phone' equals the provided phone number
      final event = await database.child('users')
          .orderByChild('phone')
          .equalTo(phone)
          .once();

      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Process the retrieved data
        final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          userData.forEach((key, value) {
          final user = Map<String, dynamic>.from(value);
          print('User found: $user');
          // Access user details
          setState(() {
            name = user['name'];
            bio = user['description'];
          });
          // Perform actions with the retrieved data
          print('Name: $name');
          print('Description: $bio');
        });
      } else {
        print('No user found with the phone number: $phone');
      }
    } on FirebaseException catch (e) {
      // Handle potential errors during data retrieval
      print('Error retrieving data: $e');
    }
  }

  void _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/profile_image.png');

    if (file.existsSync()) {
      setState(() {
        _profileImage = file;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AllListingsPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Set the background color to dark grey
      body: Padding(
        padding: EdgeInsets.only(top: 60), // Adjust the top padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400], // Set the circle color to a shade of grey
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              )
                  : null,
            ),
            const SizedBox(height: 20), // Space between profile picture and name
            Text(
              name, // Display the placeholder name
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 24, // Set font size
                fontWeight: FontWeight.bold, // Make text bold
              ),
            ),
            Divider(
              color: Colors.grey[700], // Set the color of the divider
              thickness: 1, // Set the thickness of the divider
              indent: 50, // Adjust the indent for a more balanced look
              endIndent: 50, // Adjust the end indent as well
            ),
            const SizedBox(height: 10), // Space between the divider and location
            Text(
              'Santa Cruz, CA', // Display the placeholder location
              style: TextStyle(
                color: Colors.grey[500], // Set the text color to a lighter grey
                fontSize: 18, // Set the font size
              ),
            ),
            const SizedBox(height: 20), // Space before the bio section
            Container(
              padding: EdgeInsets.all(16), // Padding inside the container for the text
              color: Color(0xFF212121), // Darker grey background for the bio section
              child: Text(
                bio,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space before the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space elements evenly
              children: [
                Column(
                  children: <Widget>[
                    Text('Jobs', style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle Jobs Button Press
                      },
                      icon: Icon(Icons.work, color: Colors.white),
                      label: Text('Open', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF212121), // Button background color
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    const Text('Requests', style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle Requests Button Press
                      },
                      icon: const Icon(Icons.request_page, color: Colors.white),
                      label: const Text('View', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF212121), // Button background color
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80), // Space before the new button
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954), // Custom green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
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
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFF212121),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
