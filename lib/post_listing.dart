import 'package:flutter/material.dart';
import 'chat.dart';

class PostListing extends StatefulWidget {

  const PostListing({super.key, required Map this.post});
  final Map post;


  @override
  _PostListingState createState() => _PostListingState(post: post);
}

class _PostListingState extends State<PostListing> {
  _PostListingState({required Map this.post});
  Map post;
  final TextEditingController _replyController = TextEditingController();


  Future openReply() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Comment on Post'),
        titleTextStyle: TextStyle(color: Colors.grey),
        content: Container(
          height: 175,
          width: 200,
          color: const Color(0xFF121212),
          alignment: Alignment.center,
          child: Column(
            children: [
              TextField(
                controller: _replyController,
                maxLines: 4,
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
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_replyController.text.isNotEmpty) {
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
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

      )
  );

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(15),
      child: Card(
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
                height: 50,
                  width: 50,
                  child: new IconButton(highlightColor:Color(0xFFB3B3B3) ,
                      color: Color(0xFF1DB954),
                      icon: Icon(Icons.reply),
                      onPressed: () {
                        openReply();
                      }),),
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
    );
  }


  void _reportPost(Map post) {
    print('Reported post: ${post['key']}');
  }

}