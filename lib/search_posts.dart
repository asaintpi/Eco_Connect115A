import 'package:eco_connect/post_listing.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Page to search for other posts
class SearchPostsPage extends StatefulWidget {
  @override
  _SearchPostsPageState createState() => _SearchPostsPageState();
}


class _SearchPostsPageState extends State<SearchPostsPage> {
  final _searchController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('posts');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Color(0xFFB3B3B3)),
              onChanged: (String value) {
                setState(() {});
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: database,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String postKey = snapshot.key.toString();
                  Map Post = snapshot.value as Map;
                  String title = Post['title'].toString();
                  String body = Post['body'].toString();
                  String author = Post['author'].toString();
                  if (title.toLowerCase()
                      .contains(_searchController.text.toLowerCase().toString())
                  || body.toLowerCase()
                          .contains(_searchController.text.toLowerCase().toString())
                  || author.toLowerCase()
                  .contains(_searchController.text.toLowerCase().toString())) {
                    return PostListing(post: Post, postKey: postKey,);
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),

      ),


    );
  }
}

