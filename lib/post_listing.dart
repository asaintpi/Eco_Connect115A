import 'package:eco_connect/view_post.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class PostListing extends StatefulWidget {
  const PostListing({Key? key, required this.post, required this.postKey}) : super(key: key);

  final Map post;
  final String postKey;

  @override
  _PostListingState createState() => _PostListingState();
}

class _PostListingState extends State<PostListing> {
  late Map post;
  late String postKey;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postKey = widget.postKey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPost(post: post, postKey: postKey),
            ),
          );
        },
        child: Card(
          color: const Color(0xFF212121),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[400],
                        child: const Icon(
                          Icons.person,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        post['author'],
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          post['title'] + '\n',
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    post['body'],
                    style: const TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                  const SizedBox(height: 30),
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
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 60, // Adjust the position as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          otherUserPhone: post['personal id'],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF1DB954),
                    child: const Icon(
                      Icons.message,
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
