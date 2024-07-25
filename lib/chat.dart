import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:eco_connect/globalstate.dart';
import 'view_profile.dart'; // Import the view profile page

// Chat page to allow users to DM each other
class ChatPage extends StatefulWidget {
  final String otherUserPhone;

  ChatPage({required this.otherUserPhone});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  String senderNumber = '';

  List<Map<String, dynamic>> _messages = [];
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    senderNumber = Provider.of<UserState>(context, listen: false).phone;
    _loadMessages();
  }

  // Messages saved in database are retrieved to be displayed
  void _loadMessages() {
    String chatId = _getChatId(senderNumber, widget.otherUserPhone);
    _database.child('chats/$chatId/messages').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _messages.add({
            'sender_phone': data['sender_phone'],
            'receiver_phone': data['receiver_phone'],
            'message': data['message'],
            'timestamp': data['timestamp'],
          });
        });
      }
    }).onError((error) {
      print('Error loading messages: $error');
    });
  }

  // Get ID of this specific chat between user1 and user2
  String _getChatId(String phone1, String phone2) {
    return phone1.compareTo(phone2) < 0 ? '${phone1}_$phone2' : '${phone2}_$phone1';
  }

  // Send message to database and to other user
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      String chatId = _getChatId(senderNumber, widget.otherUserPhone);
      DatabaseReference newMessageRef = _database.child('chats/$chatId/messages').push();
      newMessageRef.set({
        'sender_phone': senderNumber,
        'receiver_phone': widget.otherUserPhone,
        'message': _messageController.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        print('Message sent');
      }).catchError((error) {
        print('Error sending message: $error');
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121), // Updated AppBar color
        iconTheme: IconThemeData(color: const Color(0xFFB3B3B3)), // Set back arrow color
        title: Text(
          'Chat with ${widget.otherUserPhone}',
          style: TextStyle(color: const Color(0xFFB3B3B3)), // Set text color
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfilePage(otherUserPhone: widget.otherUserPhone),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender_phone'] == senderNumber;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF1DB954) : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      message['message'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Color(0xFFD9D9D9)), // Text color
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey), // Hint text color
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF1DB954), // Send button color
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
