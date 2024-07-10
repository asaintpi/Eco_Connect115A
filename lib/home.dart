import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'security_code_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneController = TextEditingController();  // Controller for the phone number input


  Future<void> verifyPhoneNumber(String phone) async {
    final FirebaseAuth auth = FirebaseAuth.instance; // Create an instance of FirebaseAuth

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Verification completed automatically (rare on most devices)
          await auth.signInWithCredential(credential);
          // Handle successful sign-in (navigate to a different screen, etc.)
          print('Verification completed automatically');
        },
        verificationFailed: (FirebaseAuthException e) {
          // Verification failed, handle error (invalid number, quota exceeded, etc.)
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Code sent successfully, navigate to verification code input screen
          print('Verification code sent: $verificationId');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecurityCodeScreen(
                verificationId: verificationId,
                phone: phone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Code retrieval timed out, handle timeout (optional)
          print('Verification timeout: $verificationId');
        },
      );
    } catch (e) {
      print('Failed to start phone verification: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212), // Set background color to dark grey
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ECO',
                    style: TextStyle(
                      fontSize: 100, // Adjust the size as needed
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1DB954), // Set text color
                    ),
                  ),
                  TextSpan(
                    text: 'CONNECT',
                    style: TextStyle(
                      fontSize: 100, // Adjust the size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set CONNECT text to white
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 640,
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',  // Display as a hint, not as a floating label
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
              )
            ),
            const SizedBox(height: 10),
            const Text(
              'We will send you a one time code to get started',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
              ),
            ),
            const SizedBox(height: 20),

    // backgroundColor: Color(0xFF1DB954),
    // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.circular(5.0),
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String phone = _phoneController.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters for pure number validation
                  if (phone.length == 10) {
                    String phoneWithCode = '+1$phone';
                    verifyPhoneNumber(phoneWithCode);
                    //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => SecurityCodeScreen(verificationId: '',)),
                    //);// If exactly 10 digits, proceed to write to Firebase
                  } else {
                    // Show an error if not 10 digits
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('The phone number must be 10 digits'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954), // Green color for the button
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // More rectangular, less rounded
                  ),
                ),



                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
