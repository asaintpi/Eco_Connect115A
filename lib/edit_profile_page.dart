import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart'; // Import the path package
import 'dart:io';
import 'profile_page.dart'; // Import the profile page

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

  void _loadUserData() {
    // Simulate loading user data
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _nameController.text = 'John Doe';
        _bioController.text = 'This is a placeholder bio for John Doe.';
        _locationController.text = 'Santa Cruz, CA';
        _isLoading = false;
      });
    });
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = 'profile_image.png'; // Consistent file name
      final savedImage = await File(pickedFile.path).copy('$path/$fileName');

      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  void _saveChanges() {
    // Simulate saving changes
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context as BuildContext); // Go back to the profile page after saving
    });
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 48.0), // Adjust padding as needed
          child: Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF121212),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400],
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                onPressed: _pickImage,
              )
                  : null,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
                fillColor: Color(0xFF212121),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1DB954)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Color(0xFFD9D9D9)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
                fillColor: Color(0xFF212121),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1DB954)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Color(0xFFD9D9D9)),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
                fillColor: Color(0xFF212121),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1DB954)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Color(0xFFD9D9D9)),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save Changes',
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
    home: EditProfilePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
