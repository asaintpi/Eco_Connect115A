import 'package:eco_connect/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

// Page for new users to set their name and profile settings
class SetNameAndPfpPage extends StatefulWidget {
  final String phone; // Add phone parameter to accept phone number
  final String email;
  const SetNameAndPfpPage({super.key, required this.phone, required this.email});

  @override
  _SetNameAndPfpPageState createState() => _SetNameAndPfpPageState();
}

class _SetNameAndPfpPageState extends State<SetNameAndPfpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image; // Variable to hold the selected image file
  Uint8List? _webImage;
  String? _extension;

  // Display profile image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        } else {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Write profile data to Firebase
  Future<void> writeUserData(String phone, String email, String name,
      String description) async {
    final database = FirebaseDatabase.instance.ref();
    final Map<String, dynamic> user = {
      'phone': phone,
      'email': email,
      'name': name,
      'description': description,
    };

    try {
      // Push data to the 'users' node with a unique key
      await database.child('users').push().set(user);
      // Show success message or perform other actions (optional)
      print('Phone number written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }

  }

  // Check if image file is null
  String _getFileExtension(String path) {
    return path.split('.').last; // Extract file extension
  }

  // Save profile image to Firebase
  Future<void> uploadImageToFirebase() async {
    try {
      if (_image == null && _webImage == null) {
        print('No image selected.');
        return;
      }

      // Get file extension
      String fileExtension = '';
      if (_image != null) {
        fileExtension = _getFileExtension(_image!.path);
      } else if (_webImage != null) {
        fileExtension = '.jpg'; // Default extension for web images
      }

      final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}$fileExtension');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = storageRef.putData(_webImage!);
      } else {
        uploadTask = storageRef.putFile(_image!);
      }

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      final downloadUrl = await storageRef.getDownloadURL();
      print('Download URL: $downloadUrl'); // Verify the URL is retrieved

      // Determine the user identifier (phone or email)
      String userKey = widget.phone;
      String phoneForEmailOnly = '1111111111';
      if (userKey == phoneForEmailOnly) {
        userKey = widget.email;
      }

      if (userKey.isEmpty) {
        print('No valid user identifier found.');
        return;
      }

      final databaseRef = FirebaseDatabase.instance.ref().child('users').orderByChild('email').equalTo(widget.email);
      final event = await databaseRef.once();
      final userSnapshot = event.snapshot;

      if (userSnapshot.value != null) {
        final userMap = Map<String, dynamic>.from(userSnapshot.value as Map);
        final userKey = userMap.keys.first; // Get the first user's key
        final userRef = FirebaseDatabase.instance.ref().child('users').child(userKey);

        await userRef.update({'profileImageUrl': downloadUrl});
        print('Image URL updated in database successfully');
      } else {
        print('No user found with the email: ${widget.email}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212),
        // Set the background color to dark grey.
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
                  backgroundImage: getBackgroundImage(),
                  child: _image == null ? const Icon(Icons.add_a_photo) : null,
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
                height: 200,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
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
                padding: EdgeInsets.symmetric(horizontal: 190),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              SizedBox(
                width: 640,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String description = _descriptionController.text.trim();
                    if (name.isNotEmpty) {
                      uploadImageToFirebase();
                      print("phone:  $widget.phone");
                      print("email:  $widget.email");
                      writeUserData(widget.phone, widget.email, name, description).then((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainNavigationPage()),
                        );

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
                        const SnackBar(
                          content: Text('Please enter your name'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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

  // Display image based on whether its web or mobile
  ImageProvider? getBackgroundImage() {
    if (_image != null || _webImage != null) {
      if (kIsWeb) {
        print("web");
        return MemoryImage(_webImage!); // Use NetworkImage for web

      } else {
        print("mobile");
        return FileImage(_image!); // Use FileImage for mobile

      }
    } else {
      return const AssetImage('assets/placeholder.png'); // Placeholder image
      //print("null");
      //return null;
    }
  }
}
void main() {
  runApp(MaterialApp(home: SetNameAndPfpPage(phone: '', email: '')));
}
