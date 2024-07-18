import 'package:eco_connect/Pages/MakePost/makepost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'globalstate.dart';
import 'dm_page.dart';
import 'profile_page.dart';
import 'package:provider/provider.dart';

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _selectedIndex = 0;
  int _tagSelection = 0;
  bool _locationPermissionAsked = false; // State variable to track if the dialog has been shown


  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Search Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Jobs Page', style: TextStyle(fontSize: 35, color: Colors.white)),
    Text('Profile Page', style: TextStyle(fontSize: 35, color: Colors.white)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 3) { // Assuming 'Profile' is the fourth item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

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

    Widget PostList({required Map Post}) {
      return  Container(
        padding: const EdgeInsets.all(15),
        child: Card(
          color: Color(0xFF212121),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                      children: [
                        const SizedBox(width: 25,),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[400],
                          // Set the circle color to a shade of grey
                          child: const Icon(
                            Icons.person,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20, height: 20,),
                        Text(Post['author'],
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),),
                          textAlign: TextAlign.left,
                        ),
                      ]
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(height: 20, width: 20),
                      Text(Post['title'] + '\n',
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),),
                      ),
                    ],
                  ),
                  Text(Post['body'],
                    style: const TextStyle(color: Color(0xFFB3B3B3),),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  ChatPage(
                                    otherUserPhone: Post['personal id'],)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DB954),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20, width: 20),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    _reportPost(Post);
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final database = FirebaseDatabase.instance.ref().child('posts');

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: _selectedIndex == 0
            ? Column(
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
                    //post['key'] = snapshot.key;
                    if(post['serviceType'].toString().toLowerCase() == buttonTitles[_tagSelection].toString().toLowerCase()){
                      return PostList(Post: post);
                    }
                    else if (_tagSelection == 0) {
                      return PostList(Post: post);
                    }
                    else {
                      return Container();
                    }
                  }
              ),
            ),
          ],
        )
            : _widgetOptions.elementAt(_selectedIndex),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_center), label: 'Jobs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1DB954),
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[850],
        // Darker grey for contrast
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType
            .fixed, // Fixed type for better UI consistency
      ),
    );
  }

  void _reportPost(Map post) {
    print('Reported post: ${post['key']}');
  }
}

void main() {
  runApp(MaterialApp(home: AllListingsPage()));
}
