import 'package:flutter/material.dart';
import 'profile_page.dart';  // Make sure to have the correct path for ProfilePage

class AllListingsPage extends StatefulWidget {
  @override
  _AllListingsPageState createState() => _AllListingsPageState();
}

class _AllListingsPageState extends State<AllListingsPage> {
  int _selectedIndex = 0;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_locationPermissionAsked) {
        _askLocationPermission();
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
          content: Text('Do you allow us to access your location to show listings near you?'),
          actions: <Widget>[
            TextButton(
              child: Text('Allow'),
              onPressed: () {
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
      "News", "Events", "Lawn Care"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      body: Center(
        child: _selectedIndex == 0 ? Column(
          children: [
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                children: List.generate(9, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      // Handle button press, could also navigate or update state
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
