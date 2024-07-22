import 'package:flutter/material.dart';
import 'chat.dart';

class DirectMessage {
  final String sender;
  final String message;

  DirectMessage({required this.sender, required this.message});
}

class DMPage extends StatelessWidget {
  final List<DirectMessage> dummyMessages = [
    DirectMessage(sender: 'User A', message: 'Hello, how are you?'),
    DirectMessage(sender: 'User B', message: 'Hi! I am doing well, thanks!'),
    DirectMessage(sender: 'User C', message: 'Hey there! What are you up to?'),
    // Add more dummy messages as needed
  ];

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
      body: ListView.builder(
        itemCount: dummyMessages.length,
        itemBuilder: (context, index) {
          final message = dummyMessages[index];

          return ListTile(
            title: Text(
              message.sender,
              style: TextStyle(color: const Color(0xFFB3B3B3)), // Sender text color
            ),
            subtitle: Text(
              message.message,
              style: TextStyle(color: Colors.white), // Message text color
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(otherUserPhone: message.sender),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
