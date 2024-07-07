import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyCemw9rgEEtsJf6b9RQfPXqsfnt0lQkCUk",
        authDomain: "ecoconnect-d26ca.firebaseapp.com",
        databaseURL: "https://ecoconnect-d26ca-default-rtdb.firebaseio.com",
        projectId: "ecoconnect-d26ca",
        storageBucket: "ecoconnect-d26ca.appspot.com",
        messagingSenderId: "752638362026",
        appId: "1:752638362026:android:bc3a0c383cac409e5b6bd3",
        measurementId: "G-9B9ZFXEX1G",
      );
    } else {
      // Use Android options
      return const FirebaseOptions(
        apiKey: "AIzaSyCemw9rgEEtsJf6b9RQfPXqsfnt0lQkCUk",
        authDomain: "ecoconnect-d26ca.firebaseapp.com",
        databaseURL: "https://ecoconnect-d26ca-default-rtdb.firebaseio.com",
        projectId: "ecoconnect-d26ca",
        storageBucket: "ecoconnect-d26ca.appspot.com",
        messagingSenderId: "752638362026",
        appId: "1:752638362026:android:bc3a0c383cac409e5b6bd3",
        measurementId: "G-9B9ZFXEX1G",
      );
    }
  }
}
