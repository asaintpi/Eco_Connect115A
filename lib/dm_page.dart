import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'chat.dart';
import 'globalstate.dart'; // Import your ChatPage widget

class DMPage extends StatelessWidget {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  String currentUserPhone = ''; // replace with the current user's phone number

  void setNumber(BuildContext context) {
    currentUserPhone = Provider.of<UserState>(context, listen: false).phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121), // Updated AppBar color
        iconTheme: IconThemeData(color: const Color(0xFFB3B3B3)), // Set back arrow color
        title: Text(
          'Direct Messages',
          style: TextStyle(color: const Color(0xFFB3B3B3)), // Set text color
        ),
      ),
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseReference.child('chats').onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!.snapshot.value;

          if (data is Map<Object?, Object?>) {
            List<Map<String, dynamic>> messages = [];

            final map = data;
            map.forEach((key, value) {
              if (value is Map<Object?, Object?>) {
                final messageData = value['messages'];
                if (messageData is Map<Object?, Object?>) {
                  final messageMap = messageData;
                  setNumber(context);
                  messageMap.forEach((key, value) {
                    if (value is Map<Object?, dynamic> &&
                        value['receiver_phone'] == currentUserPhone) {
                      messages.add(value.cast<String, dynamic>());
                    }
                  });
                }
              }
            });

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return ListTile(
                  title: Text(
                    message['sender_phone'] ?? 'Unknown Sender',
                    style: TextStyle(color: const Color(0xFFB3B3B3)), // Sender text color
                  ),
                  subtitle: Text(
                    message['message'] ?? 'No message',
                    style: TextStyle(color: Colors.white), // Message text color
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(otherUserPhone: message['sender_phone'] ?? 'Unknown Sender'),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('Data format is incorrect'));
          }
        },
      ),
    );
  }
}
