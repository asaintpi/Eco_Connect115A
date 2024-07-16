import 'home.dart';
import 'routegenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'firebase_options.dart'; // Import the generated file
import 'package:geolocator/geolocator.dart';
=======
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eco_connect/globalstate.dart';
import 'package:provider/provider.dart';
>>>>>>> c4c3dd625d7b6cfc333e94c5765ebd789a6169b0
import 'package:permission_handler/permission_handler.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoConnect',
        home: MyHomePage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

}

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle case when location permissions are denied
      print('Location permissions are denied.');
    }
  } else if (permission == LocationPermission.deniedForever) {
    // Handle case when location permissions are permanently denied
    print('Location permissions are permanently denied.');
  }
}

Future<void> _determinePosition() async {
  await requestLocationPermission();

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Handle case when location services are disabled
    print('Location services are disabled.');
  }

  Position? position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  if (position != null) {
    print('Current Location: ${position.latitude}, ${position.longitude}');
    // Handle location here, e.g., save to Firebase database
  } else {
    print('Failed to get current location.');
  }
}

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle case when location permissions are denied
      print('Location permissions are denied.');
    }
  } else if (permission == LocationPermission.deniedForever) {
    // Handle case when location permissions are permanently denied
    print('Location permissions are permanently denied.');
  }
}

Future<void> _determinePosition() async {
  await requestLocationPermission();

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Handle case when location services are disabled
    print('Location services are disabled.');
  }

  Position? position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  if (position != null) {
    print('Current Location: ${position.latitude}, ${position.longitude}');
    // Handle location here, e.g., save to Firebase database
  } else {
    print('Failed to get current location.');
  }
}

