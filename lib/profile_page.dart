import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_page.dart';  // Import the Edit Profile Page
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
  String? profileImageUrl;
  //File? _profileImage;

  @override
  void initState() {
    super.initState();
    getUserDataByPhone();
    //_loadProfileImage();
  }

  Future<void> getUserDataByEmail() async {
    final database = FirebaseDatabase.instance.ref();
    final email = Provider.of<UserState>(context, listen: false).email;

    try {
      if (email != null && email.isNotEmpty) {
        final event = await database.child('users')
            .orderByChild('email')
            .equalTo(email)
            .once();

        final snapshot = event.snapshot;

        if (snapshot.value != null) {
          final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);

          userData.forEach((key, value) {
            final user = Map<String, dynamic>.from(value);
            print('User found: $user');
            setState(() {
              name = user['name'];
              bio = user['description'];
              profileImageUrl = user['profileImageUrl']; // Retrieve profile image URL
            });
            // Perform actions with the retrieved data
            print('Name: $name');
            print('Description: $bio');
            print('Profile Image URL: $profileImageUrl');
          });
        } else {
          print('No user found with the email: $email');
        }
      } else {
        print('Email is not available or empty.');
      }
    } on FirebaseException catch (e) {
      print('Error retrieving data: $e');
    }
  }

  Future<void> getUserDataByPhone() async {
    final database = FirebaseDatabase.instance.ref();
    final phone = Provider.of<UserState>(context, listen: false).phone;

    try {
      if (phone == '1111111111') {
        print('Phone number is default, retrieving email from database...');

        final event = await database.child('users')
            .orderByChild('phone')
            .equalTo(phone)
            .once();

        final snapshot = event.snapshot;

        if (snapshot.value != null) {
          final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);

          String? userEmail;
          userData.forEach((key, value) {
            final user = Map<String, dynamic>.from(value);
            userEmail = user['email'];
            print('User email: $userEmail');
          });

          if (userEmail != null) {
            final emailEvent = await database.child('users')
                .orderByChild('email')
                .equalTo(userEmail)
                .once();

            final emailSnapshot = emailEvent.snapshot;

            if (emailSnapshot.value != null) {
              final Map<String, dynamic> emailUserData = Map<String, dynamic>.from(emailSnapshot.value as Map);
              emailUserData.forEach((key, value) {
                final user = Map<String, dynamic>.from(value);
                print('User found by email: $user');
                setState(() {
                  name = user['name'];
                  bio = user['description'];
                  profileImageUrl = user['profileImageUrl']; // Retrieve profile image URL
                });
                print('Name: $name');
                print('Description: $bio');
                print('Profile Image URL: $profileImageUrl');
              });
            } else {
              print('No user found with the email: $userEmail');
            }
          } else {
            print('No email found for phone number: $phone');
          }
        } else {
          print('No user found with the phone number: $phone');
          // Fallback to get user data by email
          getUserDataByEmail();
        }
      } else {
        final event = await database.child('users')
            .orderByChild('phone')
            .equalTo(phone)
            .once();

        final snapshot = event.snapshot;

        if (snapshot.value != null) {
          final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          userData.forEach((key, value) {
            final user = Map<String, dynamic>.from(value);
            print('User found: $user');
            setState(() {
              name = user['name'];
              bio = user['description'];
              profileImageUrl = user['profileImageUrl']; // Retrieve profile image URL
            });
            print('Name: $name');
            print('Description: $bio');
            print('Profile Image URL: $profileImageUrl');
          });
        } else {
          print('No user found with the phone number: $phone');
          // Consider using getUserDataByEmail() as a fallback or error handling.
          getUserDataByEmail();
        }
      }
    } on FirebaseException catch (e) {
      print('Error retrieving data: $e');
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
              backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
              child: profileImageUrl == null
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
