import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'chat.dart';
import 'globalstate.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      //iOS: IOSInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void listenForMessages(BuildContext context) {
    String currentUserPhone = Provider.of<UserState>(context, listen: false).phone;
    DateTime signInTime = Provider.of<UserState>(context, listen: false).signInTime;

    _databaseReference.child('chats').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map<Object?, Object?>) {
        final map = data;
        map.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            final messageData = value['messages'];
            if (messageData is Map<Object?, Object?>) {
              final messageMap = messageData;
              messageMap.forEach((key, value) {
                if (value is Map<dynamic, dynamic> &&
                    value['receiver_phone'] == currentUserPhone) {

                  // Check if message timestamp is after the sign-in time
                  try {
                    int messageTimestamp = value['timestamp'];
                    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(messageTimestamp);
                    if (messageTime.isAfter(signInTime)) {
                      print('notif');
                      _showSnackBar(context, Map<String, dynamic>.from(value));
                      //_showNotification(Map<String, dynamic>.from(value));
                    }
                  } catch (e) {
                    print("Error parsing timestamp: $e");
                  }
                }
              });
            } else {
              print("messageData is not of type Map<Object?, Object?>");
            }
          } else {
            print("value is not of type Map<Object?, Object?>");
          }
        });
      } else {
        print("data is not of type Map<Object?, Object?>");
      }
    });
  }

  void _showSnackBar(BuildContext context, Map<String, dynamic> message) {
    final snackBar = SnackBar(
      content: Text(
        '${message['sender_phone']}: ${message['message']}',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'View',
        onPressed: () {
          // Navigate to the chat page or perform any other action
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(otherUserPhone: message['sender_phone']),
            ),
          );
        },
      ),
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showNotification(Map<String, dynamic> message) {
    _flutterLocalNotificationsPlugin.show(
      0,
      message['sender_phone'] ?? 'Unknown Sender',
      message['message'] ?? 'No message',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'message_notifications', // Custom channel ID
          'Message Notifications', // Custom channel name
          channelDescription: 'Notifications for new messages received', // Custom channel description
          importance: Importance.max,
          priority: Priority.high,
        ),
        //iOS: IOSNotificationDetails(), // Add this if you are targeting iOS as well
      ),
    );
  }
}
