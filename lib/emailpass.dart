import 'package:eco_connect/globalstate.dart';
import 'package:eco_connect/security_code_screen.dart';
import 'package:eco_connect/set_name_pfp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

//Email and Pass configured for new users
class SetupEmailPasswordPage extends StatefulWidget {
  final String phone;

  SetupEmailPasswordPage({required this.phone});

  @override
  _SetupEmailPasswordPageState createState() => _SetupEmailPasswordPageState();
}

class _SetupEmailPasswordPageState extends State<SetupEmailPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';

  // Phone number authentication
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
          Provider.of<UserState>(context, listen: false).setPhone(phone);
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

  // Email and pass data saved for a user
  Future<void> _registerWithEmailPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validate password length
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      email = _emailController.text;
      print('Email/Password Registration successful: ${userCredential.user}');
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SetNameAndPfpPage(phone: widget.phone, email: email)),
        );
      }
      // Navigate to another page or show success message

    } catch (e) {
      print('Email/Password Registration failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Up Email and Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await _registerWithEmailPassword();

                },
                child: Text('Register')

            ),
          ],
        ),
      ),
    );
  }
}