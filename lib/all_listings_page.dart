import 'package:eco_connect/Pages/MakePost/makepost.dart';
import 'package:eco_connect/post_listing.dart';
import 'package:eco_connect/search_users.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'globalstate.dart';
import 'dm_page.dart';
import 'map_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _tagSelection = 0;
  bool _locationPermissionAsked = false; // State variable to track if the dialog has been shown
  Key _key = UniqueKey();
  final firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    bool locationPerm =
        Provider.of<LocationProvider>(context, listen: false).locationOn;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_locationPermissionAsked) {
        if (locationPerm == false) {
          _askLocationPermission();
        }
      }
    });
    requestNotifPermission();
    _notificationService.initialize();
    _notificationService.listenForMessages(context);
  }

  void requestNotifPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _askLocationPermission() {
    setState(() {
      _locationPermissionAsked = true; // Mark as asked
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text(
              'Do you allow us to access your location to show listings near you?'),
          actions: <Widget>[
            TextButton(
              child: Text('Allow'),
              onPressed: () {
                Provider.of<LocationProvider>(context, listen: false)
                    .changeLocationPermission(true);
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
    const buttonTitles = [
      "Add to a Service",
      "Members",
      "Babysitting",
      "Housecleaning",
      "Borrow",
      "Playdates",
      "News",
      "Events",
      "Lawn Care",
      "Carpool",
      "Other",
    ];

    final database = FirebaseDatabase.instance.ref().child('posts');

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                "Listings",
                style: TextStyle(
                  fontSize: 24, // Slightly larger text
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 300, // Adjust this height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(buttonTitles.length, (index) {
                    String backgroundImage = '';

                    // Assign background image based on button title
                    switch (buttonTitles[index]) {
                      case 'Add to a Service':
                        backgroundImage = 'assets/images/addlisting.jpg';
                        break;
                      case 'Members':
                        backgroundImage = 'assets/images/members.jpg';
                        break;
                      case 'Babysitting':
                        backgroundImage = 'assets/images/babysitting.jpg';
                        break;
                      case 'Housecleaning':
                        backgroundImage = 'assets/images/housecleaning.jpg';
                        break;
                      case 'Borrow':
                        backgroundImage = 'assets/images/borrow.jpg';
                        break;
                      case 'Playdates':
                        backgroundImage = 'assets/images/playdates.jpg';
                        break;
                      case 'News':
                        backgroundImage = 'assets/images/news.jpg';
                        break;
                      case 'Events':
                        backgroundImage = 'assets/images/events.jpg';
                        break;
                      case 'Lawn Care':
                        backgroundImage = 'assets/images/lawncare.jpg';
                        break;
                      case 'Carpool':
                        backgroundImage = 'assets/images/carpool.jpg';
                        break;
                      case 'Other':
                        backgroundImage = 'assets/images/addlisting.jpg';
                        break;
                      default:
                      // Default case, no background image
                        backgroundImage = '';
                    }

                    return Container(
                      width: 220,
                      height: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background image
                          if (backgroundImage.isNotEmpty)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  backgroundImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          // ElevatedButton with transparent background
                          ElevatedButton(
                            onPressed: () {
                              // Your existing onPressed logic here
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyMakePostPage(),
                                  ),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchUsersPage(),
                                  ),
                                );
                              }
                              print("${buttonTitles[index]} button pressed");
                              if (_tagSelection == index) {
                                // unselect category to show all
                                setState(() {
                                  _tagSelection = 0;
                                  _key = UniqueKey();
                                });
                              } else if (index != 0 && index != 1) {
                                setState(() {
                                  _tagSelection = index;
                                });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical: 20),
                              ),
                            ),
                            child: Text(
                              buttonTitles[index],
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Color(0xFF1DB954), // Green color for the button
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  // More rectangular, less rounded
                ),
              ),
              child: const Text(
                'Go to Map',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: FirebaseAnimatedList(
                query: database,
                key: _key,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String postKey = snapshot.key.toString();
                  Map post = snapshot.value as Map;
                  if (post['serviceType']
                      .toString()
                      .toLowerCase() ==
                      buttonTitles[_tagSelection]
                          .toString()
                          .toLowerCase()) {
                    return PostListing(
                      post: post,
                      postKey: postKey,
                    );
                  } else if (_tagSelection == 0) {
                    return PostListing(
                      post: post,
                      postKey: postKey,
                    );
                  } else {
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

final notificationsPlugin = FlutterLocalNotificationsPlugin();
final databaseReference = FirebaseDatabase.instance.reference();

void setupNotifications() {
  final settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  notificationsPlugin.initialize(settings);
}

void showNotification(String title, String body) async {
  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
    ),
  );
  await notificationsPlugin.show(0, title, body, details);
}

void setupDatabaseListener() {
  /*databaseReference.child('messages').onChildAdded.listen((event) {
    // Ensure that event.snapshot.value is of type Map<String, dynamic>
    final message = event.snapshot.value as Map<String, dynamic>?;

    if (message != null) {
      final title = message['title'] as String?;
      final body = message['body'] as String?;

      if (title != null && body != null) {
        showNotification(title, body);
      }
    }
  });
  */
}

void main() {
  setupNotifications();
  setupDatabaseListener();
  runApp(MaterialApp(home: AllListingsPage()));
}
