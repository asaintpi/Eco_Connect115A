import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyMakePostPage extends StatefulWidget {
  const MyMakePostPage({super.key});

  @override
  State<MyMakePostPage> createState() => _MyMakePostPageState();
}

class _MyMakePostPageState extends State<MyMakePostPage> {

  Future<void> writePost({required String author, required String title, required String body}) async {
    final database = FirebaseDatabase.instance.ref();
    final Map<String, dynamic> post = {
      'author': author,
      'title' : title,
      'body' : body,
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
        TextField(
            controller: myBodyController
        ),
        ElevatedButton(onPressed: () => writePost(author: myAuthorController.text, title: myTitleController.text, body: myBodyController.text), child: null,)
      ]
      ),
    );
  }

}