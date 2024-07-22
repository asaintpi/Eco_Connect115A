import 'package:eco_connect/view_post.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class PostListing extends StatefulWidget {

  const PostListing({super.key, required Map this.post, required String this.postKey});
  final Map post;
  final String postKey;


  @override
  _PostListingState createState() => _PostListingState(post: post, postKey: postKey);
}

class _PostListingState extends State<PostListing> {
  _PostListingState({required Map this.post, required String this.postKey});
  Map post;
  String postKey;



  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  ViewPost(post: post, postKey: postKey),
              )
          );
        },
        child: Card (
          color: Color(0xFF212121),

          child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                    children: [
                      const SizedBox(width: 25,),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[400],
                        // Set the circle color to a shade of grey
                        child: const Icon(
                          Icons.person,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20, height: 20,),
                      Text(post['author'],
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),),
                        textAlign: TextAlign.left,
                      ),
                    ]
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(height: 20, width: 20),
                    Text(post['title'] + '\n',
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),),
                    ),
                  ],
                ),
                Text(post['body'],
                  style: const TextStyle(color: Color(0xFFB3B3B3),),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ChatPage(
                                  otherUserPhone: post['personal id'],)),
                          );
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
                          'Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20, width: 20),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  _reportPost(post);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 20,
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


  void _reportPost(Map post) {
    print('Reported post: ${post['key']}');
  }

}