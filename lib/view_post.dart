import 'package:eco_connect/post_listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_listing.dart';
import 'globalstate.dart';

class ViewPost extends StatefulWidget {

  const ViewPost({super.key, required Map this.post, required String this.postKey});
  final Map post;
  final String postKey;



  @override
  _ViewPostState createState() => _ViewPostState (post: post, postKey: postKey);
}

class _ViewPostState extends State<ViewPost> {
  _ViewPostState({required Map this.post, required String this.postKey});

  Map post;
  String postKey;
  Key _key = UniqueKey();
  final TextEditingController _replyController = TextEditingController();

  Future<void> writeComment({required String reply, }) async {
    String name = '';
    String? profileUrl;
    final commentDatabase = FirebaseDatabase.instance.ref('posts/'+postKey);

    final String phoneNumber = Provider.of<UserState>(context, listen: false).phone;
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('users').orderByChild('phone').equalTo(phoneNumber).get();
    if (snapshot.exists) {
      final userData = snapshot.value as Map<dynamic, dynamic>;
      final userKey = userData.keys.first;
      final user = userData[userKey];
      name = user['name'] ?? 'No name';
      profileUrl = user['profileImageUrl'];
    } else {
      name = 'No user found';
    }

    final Map<String, dynamic> comment = {
      'author': name,
      'postID': post['time'],
      'contents': reply,
      'profileImageUrl': profileUrl,
    };
    try {
      // Push data to the 'comments' node with a unique key
      await commentDatabase.child('comments').push().update(comment);
      // Show success message or perform other actions (optional)
      print('comment written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref('posts/$postKey').child('comments');

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
              'Listing',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                child: PostListing(post: post, postKey: postKey),

              ),
              Expanded(
                child: new FirebaseAnimatedList(
                    query: database,
                    key: _key,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      if(snapshot.exists) {
                        Map comment = snapshot.value as Map;
                        return CommentListing(comment: comment, post: post,);
                      }
                      else {
                        return Container();
                      }
                    }
                ),
              ),
              Container(
                child: TextField(
                  controller: _replyController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Comment..',
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
              SizedBox(height: 10),
              Container(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_replyController.text.isNotEmpty) {
                        writeComment(
                            reply: _replyController.text);
                        _replyController.clear();
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
                      'Comment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

            ],
          )
      ),

    );


  }


}