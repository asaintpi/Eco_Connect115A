import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'chat.dart';
import 'globalstate.dart';

// Page for Direct Messages Displayed
class DMPage extends StatelessWidget {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  String currentUserPhone = ''; // replace with the current user's phone number

  void setNumber(BuildContext context) {
    currentUserPhone = Provider.of<UserState>(context, listen: false).phone;
  }

  // User data is retireved by phone number as the key
  Future<String> getNameByPhone(String phone) async {
    final snapshot = await databaseReference.child('users').orderByChild('phone').equalTo(phone).get();
    if (snapshot.exists && snapshot.value is Map) {
      final userMap = Map<String, dynamic>.from(snapshot.value as Map);
      if (userMap.isNotEmpty) {
        final userKey = userMap.keys.first; // Get the first user's key
        final userData = userMap[userKey] as Map;
        return userData['name'] ?? 'Unknown Sender';
      }
    }
    return 'Unknown Sender';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        iconTheme: IconThemeData(color: const Color(0xFFB3B3B3)),
        title: Text(
          'Direct Messages',
          style: TextStyle(color: const Color(0xFFB3B3B3)),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
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

                AssetImage placeholderImage = AssetImage('assets/images/elogo.png');

                // Convert integer timestamp to DateTime object
                DateTime sentTime = DateTime.fromMillisecondsSinceEpoch(message['timestamp']); // Assuming 'timestamp' is an integer timestamp

                return FutureBuilder<String>(
                  future: getNameByPhone(message['sender_phone'] ?? 'Unknown Sender'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          backgroundImage: placeholderImage,
                        ),
                        title: Text('Loading...', style: TextStyle(color: const Color(0xFFB3B3B3))),
                      );
                    }

                    if (snapshot.hasError) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          backgroundImage: placeholderImage,
                        ),
                        title: Text('Error', style: TextStyle(color: const Color(0xFFB3B3B3))),
                      );
                    }

                    final senderName = snapshot.data ?? 'Unknown Sender';

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: CircleAvatar(
                        backgroundImage: placeholderImage,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            senderName,
                            style: TextStyle(color: const Color(0xFFB3B3B3)), // Sender text color
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  message['message'] ?? 'No message',
                                  style: TextStyle(color: Colors.white), // Message text color
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${sentTime.hour}:${sentTime.minute}',
                                style: TextStyle(color: Colors.grey), // Time text color
                              ),
                            ],
                          ),
                        ],
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

