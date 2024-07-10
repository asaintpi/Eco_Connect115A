import 'home.dart';
import 'routegenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Import the generated file
import 'package:flutter/material.dart';
import 'main_app.dart';  // Import MainApp


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Realtime Database Demo',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,

    );
  }
}

