
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eco_connect/globalstate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
        create: (context) => UserState()),
        ChangeNotifierProvider(
        create: (context) => LocationProvider()),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoConnect',
        home: MyHomePage(),
      ),
    );
  }

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
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