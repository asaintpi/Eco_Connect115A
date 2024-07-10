import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Index for 'Profile', assuming it's the fourth item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed, e.g., using Navigator to switch pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Set the background color to dark grey
      body: Padding(
        padding: EdgeInsets.only(top: 60), // Adjust the top padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400], // Set the circle color to a shade of grey
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Space between profile picture and name
            const Text(
              'John Doe', // Display the placeholder name
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 24, // Set font size
                fontWeight: FontWeight.bold, // Make text bold
              ),
            ),
            Divider(
              color: Colors.grey[700], // Set the color of the divider
              thickness: 1, // Set the thickness of the divider
              indent: 50, // Adjust the indent for a more balanced look
              endIndent: 50, // Adjust the end indent as well
            ),
            const SizedBox(height: 10), // Space between the divider and location
             Text(
              'Santa Cruz, CA', // Display the placeholder location
              style: TextStyle(
                color: Colors.grey[500], // Set the text color to a lighter grey
                fontSize: 18, // Set the font size
              ),
            ),
            const SizedBox(height: 20), // Space before the bio section
            Container(
              padding: EdgeInsets.all(16), // Padding inside the container for the text
              color: Color(0xFF212121), // Darker grey background for the bio section
              child: const Text(
                'Bio: Enthusiastic tech lover and coder. Excited about the future of AI and technology.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space before the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space elements evenly
              children: [
                Column(
                  children: <Widget>[
                    Text('Jobs', style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle Jobs Button Press
                      },
                      icon: Icon(Icons.work, color: Colors.white),
                      label: Text('Open', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF212121), // Button background color
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Requests', style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle Requests Button Press
                      },
                      icon: Icon(Icons.request_page, color: Colors.white),
                      label: Text('View', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF212121), // Button background color
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80), // Space before the new button
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add action for this button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954), // Custom green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
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
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFF212121),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
