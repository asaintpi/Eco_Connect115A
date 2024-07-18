import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:eco_connect/globalstate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  String? fcmToken;
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String senderNumber = '';

  Future<void> _getFcmToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');

    // You can store the token in your database or send it to your server for future use.
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
    } else {
      print('User declined permission for notifications');
    }
  }

  String _getChatId(String phone1, String phone2) {
    return phone1.compareTo(phone2) < 0 ? '${phone1}_$phone2' : '${phone2}_$phone1';
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

  @override
  void initState() {
    super.initState();
    senderNumber = Provider.of<UserState>(context, listen: false).phone;
    //_setupFCM();
    _loadMessages();
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
        //_sendNotification(widget.otherUserPhone, _messageController.text);
      }).catchError((error) {
        print('Error sending message: $error');
      });
      _messageController.clear();
    }
  }

  Future<void> _sendFCMMessage(String token, String message) async {
    final serverKey = 'YOUR_SERVER_KEY';
    final url = 'https://fcm.googleapis.com/fcm/send';

    await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'notification': {
          'title': 'New Message',
          'body': message,
        },
        'priority': 'high',
        'to': token,
      }),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121), // Updated AppBar color
        iconTheme: IconThemeData(color: const Color(0xFFB3B3B3)), // Set back arrow color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Chat with ${widget.otherUserPhone}',
                  style: TextStyle(color: const Color(0xFFB3B3B3)), // Set text color
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
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

void main() {
  runApp(MaterialApp(home: ChatPage(otherUserPhone: '123-456-7890')));
}
