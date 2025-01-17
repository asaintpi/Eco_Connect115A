import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat.dart';

// Page to search for other users
class SearchUsersPage extends StatefulWidget {
  @override
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final _searchController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('users');

  Widget UserItem ({required Map User}){
    return Container(
      height:200,
        padding: const EdgeInsets.all(15),
        child: Card(
        color: Color(0xFF212121),
            child: Column(
              children: [
                const SizedBox(width: 20, height: 20,),
                Container (
                  child: Row(
                    children: [
                      const SizedBox(width: 20, height: 20,),
                      User['profileImageUrl'] != null?
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: NetworkImage(User['profileImageUrl']),
                      ):
                      const CircleAvatar (
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20, height: 20,),
                      Text(User['name'].toString(),
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10, height: 10,),
                Container(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ChatPage(
                              otherUserPhone: User['phone'],)),
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
              ]
            )
    ),

    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Search Users',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
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
                  Map User = snapshot.value as Map;
                  String name = User['name'].toString();
                  if (_searchController.text.isEmpty) {
                    return UserItem(User: User);
                  }
                  else if (name.toLowerCase()
                      .contains(_searchController.text.toLowerCase().toString())) {
                    return UserItem(User: User);
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

