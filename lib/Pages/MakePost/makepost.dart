import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyMakePostPage extends StatefulWidget {
  const MyMakePostPage({super.key});

  @override
  State<MyMakePostPage> createState() => _MyMakePostPageState();
}
final List<String> serviceTypes = ['Housecleaning', 'Babysitting', 'News', 'Events', 'Lawn Care', 'Garden', 'Compost', 'Carpool', 'Other']; // List of service options
String selectedService = serviceTypes[0]; // Initial selection

class _MyMakePostPageState extends State<MyMakePostPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  Future<void> writePost({required String author, required String title, required String body, required String service}) async {
    final database = FirebaseDatabase.instance.ref();
    final Map<String, dynamic> post = {
      'author': author,
      'title' : title,
      'body' : body,
      'serviceType' : service,
    };

    try {
      // Push data to the 'users' node with a unique key
      await database.child('posts').push().set(post);
      // Show success message or perform other actions (optional)
      print('Phone number written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }
  }


  @override
  void dispose() {
    //releases memory
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        color: const Color(0xFF121212),
        // Set the background color to dark grey.
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      "Create a Listing",
                      style: TextStyle(
                        fontSize: 24, // Slightly larger text
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 50),
          Container(
            width: 640,
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
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
                    width: 640,
                    color: Color(0xFF212121),

                    child: DropdownButtonFormField<String>(
                      value: selectedService, // Set initial value
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
                      focusColor: Color(0xFF212121),

                      items: serviceTypes.map((serviceType) => DropdownMenuItem<String>(
                        value: serviceType,
                        child: Text(serviceType),
                      )).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService = newValue!; // Update selectedService
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 30),
                  Container(
                    width: 640,
                    child: ElevatedButton(
                      onPressed: () => writePost(
                          author: 'temp',
                          title: _titleController.text,
                          body: _bodyController.text,
                          service: selectedService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                  )
                ],
            ),
            )
    )

    );

  }

}