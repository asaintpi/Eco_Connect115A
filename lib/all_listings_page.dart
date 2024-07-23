import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'dm_page.dart';
import 'globalstate.dart';
import 'map_screen.dart';
import 'notification.dart';
import 'post_listing.dart';
import 'search_users.dart';
import 'package:eco_connect/Pages/MakePost/makepost.dart';

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  final databaseReference = FirebaseDatabase.instance.reference().child('posts');
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  int _tagSelection = 0; // selected tag
  bool _locationPermissionAsked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLocationPermission();
    });
    _requestNotifPermission();
    _notificationService.initialize();
    _notificationService.listenForMessages(context);
  }

  void _requestNotifPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _handleLocationPermission() {
    bool locationPerm = Provider.of<LocationProvider>(context, listen: false).locationOn;
    if (!_locationPermissionAsked && !locationPerm) {
      _showLocationPermissionDialog();
    }
  }

  void _showLocationPermissionDialog() {
    setState(() {
      _locationPermissionAsked = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text('Do you allow us to access your location to show listings near you?'),
          actions: <Widget>[
            TextButton(
              child: Text('Allow'),
              onPressed: () {
                Provider.of<LocationProvider>(context, listen: false).changeLocationPermission(true);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Do Not Allow'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "0 Listings",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildCategoryButtons(),
            ElevatedButton( // map button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1DB954),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Go to Map',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList( // list of posts based on selected category
                query: databaseReference,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  String postKey = snapshot.key.toString();
                  Map post = snapshot.value as Map;
                  if (_isSelectedCategory(post)) {
                    return PostListing(post: post, postKey: postKey);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( // dm button
        onPressed: () {
          _notificationService.showNotification('title', 'body');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DMPage()),
          );
        },
        child: Icon(Icons.message),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryButtons() { // select tag and add service bar
    const buttonTitles = [
      "Add to a Service", "Members", "Babysitting",
      "Housecleaning", "Borrow", "Playdates",
      "News", "Events", "Lawn Care", "Garden", "Compost", "Carpool", "Other",
    ];

    return Container(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(buttonTitles.length, (index) {
            return _buildCategoryButton(index, buttonTitles[index]);
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(int index, String title) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () => _handleCategoryButtonPressed(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(index),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _handleCategoryButtonPressed(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyMakePostPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchUsersPage()),
      );
    }
    setState(() {
      _tagSelection = index == _tagSelection ? 0 : index;
    });
  }

  Color _getButtonColor(int index) {
    if (index == 0 || index == 1) {
      return Color(0xFF212121);
    } else {
      return _tagSelection == index ? Color(0xFF212121) : Color(0xFF1DB954);
    }
  }

  bool _isSelectedCategory(Map post) {
    if (_tagSelection == 0) {
      return true;
    } else {
      return post['serviceType'].toString().toLowerCase() == buttonTitles[_tagSelection].toLowerCase();
    }
  }
}

void setupNotifications() {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  notificationsPlugin.initialize(settings);
}

void setupDatabaseListener() {
  final databaseReference = FirebaseDatabase.instance.reference();
  /*databaseReference.child('messages').onChildAdded.listen((event) {
    final message = event.snapshot.value as Map<String, dynamic>?;

    if (message != null) {
      final title = message['title'] as String?;
      final body = message['body'] as String?;

      if (title != null && body != null) {
        showNotification(title, body);
      }
    }
  });*/
}

void main() {
  setupNotifications();
  setupDatabaseListener();
  runApp(MaterialApp(home: AllListingsPage()));
}
