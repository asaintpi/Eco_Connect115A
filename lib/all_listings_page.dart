import 'package:eco_connect/Pages/MakePost/makepost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'globalstate.dart';
import 'profile_page.dart';  // Make sure to have the correct path for ProfilePage
import 'package:provider/provider.dart';


class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _selectedIndex = 0;

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
    if (_selectedIndex == 3) {  // Assuming 'Profile' is the fourth item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    bool locationPerm = Provider.of<LocationProvider>(context, listen: false).locationOn;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(locationPerm == false) {
        _askLocationPermission();
      }
    });
  }

  void _askLocationPermission() {

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button!
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
                // Enable location sharing functionality or set a state
              },
            ),
            TextButton(
              child: Text('Do Not Allow'),
              onPressed: () {
                Navigator.of(context).pop();
                // Proceed without enabling location sharing
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



    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: _selectedIndex == 0 ? Column(
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
                child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(20),
                children: List.generate(buttonTitles.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      // Handle button press, could also navigate or update state
                      if(index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyMakePostPage()),
                        );
                      }
                      print("${buttonTitles[index]} button pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 0 ? Color(0xFF212121) : const Color(0xFF1DB954), // Conditional color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Adjust padding for larger buttons
                    ),
                    child: Text(buttonTitles[index],
                      style: TextStyle(fontSize: 16, color: Colors.white), // Ensure text color contrasts well with the button color
                    ),
                  );
                }),
              ),
            ),
          ],

        ) : _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.business_center), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1DB954),
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[850], // Darker grey for contrast
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Fixed type for better UI consistency
      ),
    );
  }




}

void main() {
  runApp(MaterialApp(home: AllListingsPage()));
}
