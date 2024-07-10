import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyMakePostPage extends StatefulWidget {
  const MyMakePostPage({super.key});

  @override
  State<MyMakePostPage> createState() => _MyMakePostPageState();
}
final List<String> serviceTypes = ['Housecleaning', 'Babysitting', 'News', 'Events', 'Lawn Care']; // List of service options
String selectedService = serviceTypes[0]; // Initial selection

class _MyMakePostPageState extends State<MyMakePostPage> {

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


  final myAuthorController = TextEditingController();
  final myTitleController = TextEditingController();
  final myBodyController = TextEditingController();
  final myServiceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( children: [
        TextField(
            controller: myAuthorController
        ),
        TextField(
            controller: myTitleController
        ),
        DropdownButtonFormField<String>(
          value: selectedService, // Set initial value
          hint: Text('Select Service'), // Display text before selection
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
        TextField(
            controller: myBodyController
        ),
        ElevatedButton(onPressed: () => writePost(author: myAuthorController.text, title: myTitleController.text, body: myBodyController.text, service: selectedService), child: null,)
      ]
      ),
    );
  }

}