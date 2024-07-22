import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List posts = [];
  String _selectedDistance = '5km';
  late Position userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _controller?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(userPosition.latitude, userPosition.longitude),
      ),
    );
    _loadPosts(userPosition);
  }

  Future<void> _loadPosts(Position position) async {
    // Replace with your API endpoint
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
        _updateMarkers();
      });
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers = posts.where((post) {
        final distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          post['latitude'],
          post['longitude'],
        );
        return distance <= _getSelectedDistance();
      }).map((post) {
        return Marker(
          markerId: MarkerId(post['id'].toString()),
          position: LatLng(post['latitude'], post['longitude']),
          infoWindow: InfoWindow(
            title: post['title'],
            snippet: post['description'],
          ),
        );
      }).toSet();
    });
  }

  double _getSelectedDistance() {
    switch (_selectedDistance) {
      case '5km':
        return 5000;
      case '10km':
        return 10000;
      case '20km':
        return 20000;
      default:
        return 5000;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
        actions: [
          DropdownButton<String>(
            value: _selectedDistance,
            items: <String>['5km', '10km', '20km']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDistance = newValue!;
                _updateMarkers();
              });
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}