import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MyListPostsPage extends StatefulWidget {
  const MyListPostsPage({super.key});

  @override
  State<MyListPostsPage> createState() => _MyListPostsPageState();
}

class _MyListPostsPageState extends State<MyListPostsPage> {


  final database = FirebaseDatabase.instance.ref().child('posts');


  Widget listItem({required Map post}) {
    return Container(
      child: Column(
        children: [
          Text(post['author']),
          Text(post['title']),
          Text(post['body'])
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (height: double.infinity,
      child: FirebaseAnimatedList(query: database,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          Map post = snapshot.value as Map;
          post['key'] = post.keys;
          return listItem(post: post);
        }
      )
      )

    );
  }

}