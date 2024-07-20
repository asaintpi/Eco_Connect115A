import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'chat.dart';

class SearchPostsPage extends StatefulWidget {
  @override
  _SearchPostsPageState createState() => _SearchPostsPageState();
}


class _SearchPostsPageState extends State<SearchPostsPage> {
  final _searchController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('posts');



  Widget PostItem ({required Map Post}){
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
                      Text(Post['author'],
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
                    Text(Post['title'] + '\n',
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),),
                    ),
                  ],
                ),
                Text(Post['body'],
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
                                  otherUserPhone: Post['personal id'],)),
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
                  _reportPost(Post);
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
                    return PostItem(Post: Post);
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

  void _reportPost(Map post) {
    print('Reported post: ${post['key']}');
  }
}

