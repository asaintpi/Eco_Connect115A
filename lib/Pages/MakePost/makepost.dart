import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../globalstate.dart';
import '../../main.dart';

class MyMakePostPage extends StatefulWidget {
  const MyMakePostPage({Key? key}) : super(key: key);

  @override
  State<MyMakePostPage> createState() => _MyMakePostPageState();
}

final List<String> serviceTypes = [
  'Housecleaning',
  'Babysitting',
  'News',
  'Events',
  'Lawn Care',
  'Garden',
  'Compost',
  'Carpool',
  'Other'
]; // List of service options
String selectedService = serviceTypes[0]; // Initial selection

class _MyMakePostPageState extends State<MyMakePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  File? _image;
  Uint8List? _webImage;
  String? _imagePath;
  String name = "";


  void initState() {
    super.initState();
    fetchUserData();
  }


  void fetchUserData() async {
    final String phoneNumber = Provider.of<UserState>(context, listen: false).phone;
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('users').orderByChild('phone').equalTo(phoneNumber).get();
    if (snapshot.exists) {
      final userData = snapshot.value as Map<dynamic, dynamic>;
      final userKey = userData.keys.first;
      final user = userData[userKey];
      setState(() {
        name = user['name'] ?? 'No name';
      });
    } else {
      setState(() {
        name = 'No user found';
      });
    }
  }



  Future<void> writePost({required String author, required String title, required String body,
    required String service}) async {
    // get post location
    List position = await determinePosition();
    // gets the UTC time and date at the moment of post
    final now = DateTime.now();

    double longitude = position[0];
    double latitude = position[1];

    final database = await FirebaseDatabase.instance.ref();
    final Map<String, dynamic> post = {
      'author': author,
      'personal id': Provider.of<UserState>(context, listen: false).phone,
      'title' : title,
      'body' : body,
      'time' : now.toString(),
      'serviceType' : service,
      'longitude': longitude,
      'latitude': latitude,
    };
    try {
      // Push data to the 'posts' node with a unique key
      await database.child('posts').push().set(post);
      // Show success message or perform other actions (optional)
      print('Post written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }
  }

  // Method to handle image selection
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _image = null; // Reset _image if previously set
            _imagePath = null; // Reset _imagePath if previously set
          });
        } else {
          setState(() {
            _image = File(pickedFile.path);
            _webImage = null; // Reset _webImage if previously set
          });
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212121),
        iconTheme: IconThemeData(color: Color(0xFFB3B3B3)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 48.0), // Adjust padding as needed
          child: Center(
            child: Text(
              'Create Listing',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF121212),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select an image for your post',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _image != null || _webImage != null
                  ? Image.memory(
                _webImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[800],
                child: Center(
                  child: Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Color(0xFF212121),
                    filled: true,
                  ),
                  style: const TextStyle(color: Color(0xFFB3B3B3)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _bodyController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Share with your community',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(),
                    fillColor: Color(0xFF212121),
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                color: Color(0xFF212121),
                child: DropdownButtonFormField<String>(
                  value: selectedService,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
                    hintText: '',
                    fillColor: Color(0xFF212121),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                  ),
                  dropdownColor: Color(0xFF212121),
                  items: serviceTypes
                      .map((serviceType) => DropdownMenuItem<String>(
                    value: serviceType,
                    child: Text(serviceType),
                  ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedService = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty &&
                        _bodyController.text.isNotEmpty) {
                      await writePost(
                          author: name,
                          title: _titleController.text,
                          body: _bodyController.text,
                          service: selectedService,
                      );
                      Navigator.pop(context);
                      }
                      else if (_imagePath != null) {
                        print('Image path: $_imagePath');

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fill in all fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Post',
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
      ),
    );
  }

}

void main() {
  runApp(MaterialApp(home: MyMakePostPage()));
}
