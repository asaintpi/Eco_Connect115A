import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(37.7749, -122.4194); // Default to San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('center'),
                position: _center,
                infoWindow: InfoWindow(
                  title: 'San Francisco',
                ),
              ),
            );
          });
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
