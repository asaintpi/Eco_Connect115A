import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

// Map configurations for page
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  Map<MarkerId, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchUserLocations();
  }

  // Locations of all users grabbed
  void _fetchUserLocations() {
    _usersRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> users = snapshot.snapshot.value as Map<dynamic, dynamic>;
        users.forEach((userId, userData) {
          double latitude = userData['location']['latitude'];
          double longitude = userData['location']['longitude'];
          String name = userData['name'] ?? 'No Name';

          MarkerId markerId = MarkerId(userId);
          Marker marker = Marker(
            markerId: markerId,
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: name),
          );

          setState(() {
            _markers[markerId] = marker;
          });
        });
      }
    }).catchError((error) {
      print('Failed to fetch user locations: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Locations')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 10,
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}
