import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<void> writeUserData() async {
    final database = FirebaseDatabase.instance.ref();
    final Map<String, dynamic> user = {
      'name': 'Tom Doe',
      'age': 30,
    };

    try {
      // Push data to the 'users' node with a unique key
      await database.child('users').push().set(user);
      // Show success message or perform other actions (optional)
      print('User data written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212), // Set background color to dark grey
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ECOCONNECT',
              style: TextStyle(
                fontSize: 100, // Adjust the size as needed
                fontWeight: FontWeight.bold,
                color: Color(0xFF1DB954), // Set text color
              ),
            ),
            const SizedBox(height: 20),
            const Text('We will send you a one time code to get started'),
            ElevatedButton(
              onPressed: writeUserData,
              child: const Text('Write User Data'),
            ),
          ],
        ),
      ),
    );
  }
}
