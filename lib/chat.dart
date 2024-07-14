import 'package:eco_connect/globalstate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String otherUserPhone;

  ChatPage({required this.otherUserPhone});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  User? _user;
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String senderNumber = '';

  @override
  void initState() {
    super.initState();
    senderNumber = Provider.of<UserState>(context, listen: false).phone;
    _loadMessages();
  }

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

  String _getChatId(String phone1, String phone2) {
    return phone1.compareTo(phone2) < 0 ? '${phone1}_$phone2' : '${phone2}_$phone1';
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      print('Sending message: ${_messageController.text}');
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
        title: Text('Chat with ${widget.otherUserPhone}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]['message']),
                  subtitle: Text(_messages[index]['sender_phone'] == senderNumber ? 'You' : widget.otherUserPhone),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
