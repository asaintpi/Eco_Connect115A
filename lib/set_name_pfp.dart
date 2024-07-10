import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class SetNameAndPfpPage extends StatefulWidget {
  const SetNameAndPfpPage({super.key, required this.phone});
  final String phone; // Add phone parameter to accept phone number


  @override
  _SetNameAndPfpPageState createState() => _SetNameAndPfpPageState();
}


class _SetNameAndPfpPageState extends State<SetNameAndPfpPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;  // Variable to hold the selected image file


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);


    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);  // Update the state with the selected image file
      });
    }
  }


  Future<void> writeUserData(String phone, String name) async {
    final database = FirebaseDatabase.instance.ref();
    final userRef = database.child('users').child(phone); // Use phone as key


    try {
      await userRef.set({
        'phone': phone,
        'name': name,
      });
      print('User data updated successfully!');
    } on FirebaseException catch (e) {
      print('Error writing user data: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212), // Set the background color to dark grey.
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0), // Adjust padding to move elements higher
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to start to move them higher
          children: [
            GestureDetector(
              onTap: () {
                print('CircleAvatar tapped');
                _pickImage();
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              ),
            ),


            const SizedBox(height: 10),
            const Text(
              'Please set your name and profile picture',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 100), // Increase space between profile picture setup and name field
            SizedBox(
              width: 640, // Same width as the submit button
              height: 50, // Same height as the submit button
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  labelStyle: TextStyle(color: Color(0xFFB3B3B3)), // Hint text color
                  border: OutlineInputBorder(),
                  fillColor: Color(0xFF212121), // Background color
                  filled: true,
                ),
                style: const TextStyle(color: Color(0xFFB3B3B3)), // Input text color
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String name = _nameController.text.trim(); // Get the trimmed name from the input
                  if (name.isNotEmpty) {
                    writeUserData(widget.phone, name).then((_) {
                      // Optionally navigate to another screen or show a success message
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }).catchError((error) {
                      // Handle errors, e.g., show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update data: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  } else {
                    // Show error if the name field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your name'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
