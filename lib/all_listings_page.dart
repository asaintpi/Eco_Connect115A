import 'package:eco_connect/Pages/MakePost/makepost.dart';
import 'package:eco_connect/post_listing.dart';
import 'package:eco_connect/search_users.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'globalstate.dart';
import 'dm_page.dart';
import 'package:provider/provider.dart';

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _tagSelection = 0;
  bool _locationPermissionAsked = false; // State variable to track if the dialog has been shown



  @override
  void initState() {
    super.initState();
    bool locationPerm = Provider
        .of<LocationProvider>(context, listen: false)
        .locationOn;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_locationPermissionAsked) {
        if (locationPerm == false) {
          _askLocationPermission();
        }
      }
    });
    requestNotifPermission();
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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
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
      "Add to a Service", "Members", "Babysitting",
      "Housecleaning", "Borrow", "Playdates",
      "News", "Events", "Lawn Care", "Garden", "Compost", "Carpool", "Other",
    ];


    final database = FirebaseDatabase.instance.ref().child('posts');

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                "0 Listings",
                style: TextStyle(
                  fontSize: 24, // Slightly larger text
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(buttonTitles.length, (index) {
                    return Container(
                      width: 150,
                      // Set a fixed width for the buttons
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      // Add some margin between buttons
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press, could also navigate or update state
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyMakePostPage()),
                            );
                          }
                          else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  SearchUsersPage(),
                            )
                            );
                          }
                          print("${buttonTitles[index]} button pressed");
                          if(_tagSelection == index) {//unselect category to show all
                            setState(() {
                              _tagSelection = 0;
                            });
                          }
                          else if (index != 0 && index != 1) {
                            setState(() {
                              _tagSelection = index;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: index == 0
                              ? Color(0xFF212121)
                          : _tagSelection == index
                            ? Color(0xFF212121)
                              : const Color(0xFF1DB954), // Conditional color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20), // Adjust padding for larger buttons
                        ),
                        child: Text(
                          buttonTitles[index],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          // Ensure text color contrasts well with the button color
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: database,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map post = snapshot.value as Map;
                    if(post['serviceType'].toString().toLowerCase() == buttonTitles[_tagSelection].toString().toLowerCase()){
                      return PostListing(post: post);
                    }
                    else if (_tagSelection == 0) {
                      return PostListing(post: post);
                    }
                    else {
                      return Container();
                    }
                  }
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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


}

void main() {
  runApp(MaterialApp(home: AllListingsPage()));
}
