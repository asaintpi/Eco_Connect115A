import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SetNameAndPfpPage extends StatefulWidget {
  final String phone; // Add phone parameter to accept phone number

  const SetNameAndPfpPage({super.key, required this.phone});

  @override
  _SetNameAndPfpPageState createState() => _SetNameAndPfpPageState();
}

class _SetNameAndPfpPageState extends State<SetNameAndPfpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image; // Variable to hold the selected image file

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the state with the selected image file
      });
    }
  }

  Future<void> writeUserData(String phone, String name, String description) async {
    final database = FirebaseDatabase.instance.ref();
    final userRef = database.child('users').child(phone); // Use phone as key

    try {
      await userRef.set({
        'phone': phone,
        'name': name,
        'description': description,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
        child: SingleChildScrollView( // Add SingleChildScrollView to handle overflow when keyboard appears
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  child: _image == null ? const Icon(Icons.camera_alt, color: Colors.white) : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please set your name and profile picture',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 50),
              Container(
                width: 640,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your name',
                    labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
                    border: OutlineInputBorder(),
                    fillColor: Color(0xFF212121),
                    filled: true,
                  ),
                  style: const TextStyle(color: Color(0xFFB3B3B3)),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 640,
                height: 200,  // Increased height from your initial setting
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 8,  // Set to an arbitrary number to utilize the height
                  decoration: InputDecoration(
                    alignLabelWithHint: true,  // Ensures the label (hint text) starts at the top left
                    hintText: 'Enter a description for your profile',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(),
                    fillColor: Color(0xFF212121),
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 190), // Adjust the padding value to suit your needs
                child: Divider(
                  color: Colors.grey, // Specify the color if needed
                  thickness: 1, // Specify the thickness if needed
                ),
              ),              SizedBox(
                width: 640,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String description = _descriptionController.text.trim();
                    if (name.isNotEmpty) {
                      writeUserData(widget.phone, name, description).then((_) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update data: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    } else {
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
                    'Setup Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
               Text(
                'Members in your neighborhood will be able to see your name, profile picture, and service listings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(home: SetNameAndPfpPage(phone: '',)));
}