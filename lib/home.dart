import 'package:eco_connect/all_listings_page.dart';
import 'package:eco_connect/globalstate.dart';
import 'package:eco_connect/main_navigation.dart';
import 'package:eco_connect/set_name_pfp.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'security_code_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneController =
  TextEditingController(); // Controller for the phone number input
  bool emailsuccess = false;
  late RecaptchaVerifier recaptchaVerifier;

  @override
  void initState() {
    super.initState();
    recaptchaVerifier = RecaptchaVerifier(
      auth: FirebaseAuthPlatform.instance,
      container: null,
      size: RecaptchaVerifierSize.normal,
      theme: RecaptchaVerifierTheme.light,
      onSuccess: () {
        print('reCAPTCHA completed successfully at ${DateTime.now()}');
      },
      onError: (error) {
        print('reCAPTCHA encountered an error at ${DateTime.now()}: $error');
      },
      onExpired: () {
        print('reCAPTCHA expired at ${DateTime.now()}');
      },
    );
  }



  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await signInWithEmailAndPassword(
          email, password);
      print('Email/Password Sign-In successful: ${userCredential.user}');
      emailsuccess = true;
      //_promptForPhoneVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEmailPasswordSignInDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _emailController = TextEditingController();
        final TextEditingController _passwordController =
        TextEditingController();

        return AlertDialog(
          title: Text('Sign In with Email/Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                await _signInWithEmailAndPassword(email, password);
                Navigator.of(context).pop();
                if (emailsuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainNavigationPage()),
                  );
                }
              },
              child: Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      User? user = userCredential.user;

      if (user != null) {
        String? email = user.email;
        print('Google Sign-In successful: ${user.uid}');
        print('User email: $email');

        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllListingsPage(),
          ),
        );
         */
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
  }

  Future<void> _signInWithGoogleWeb(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;

    try {
      googleUser = await googleSignIn.signInSilently();
      googleUser ??= await googleSignIn.signIn();
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String? email = user.email;
        bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
        Provider.of<UserState>(context, listen: false).setEmail(email!);
        if (isNewUser) {
          print('Google Sign-In successful: ${user.uid}');
          print('User email: $email');
          print('Welcome, new user!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetNameAndPfpPage(phone: '1111111111', email: email),
            ),
          );
          // Handle new user logic, such as displaying a welcome message
          print("nav");
        } else {
          print('Google Sign-In successful: ${user.uid}');
          print('User email: $email');
          print('Welcome back, existing user!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllListingsPage(),
            ),
          );
          // Handle existing user logic, such as redirecting to the main app page
        }


      }
    }
  }


  Future<void> verifyPhoneNumber(String phone) async {
    /*final FirebaseAuth auth = FirebaseAuth.instance; // Create an instance of FirebaseAuth

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Verification completed automatically (rare on most devices)
          await auth.signInWithCredential(credential);
          // Handle successful sign-in (navigate to a different screen, etc.)
          print('Verification completed automatically');
          Provider.of<UserState>(context, listen: false).setPhone(phone);
          Provider.of<UserState>(context, listen: false)
              .setSignInTime(DateTime.now());
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

     */
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      print('Starting reCAPTCHA verification at ${DateTime.now()}');
      String recaptchaToken = await recaptchaVerifier.verify();
      print('reCAPTCHA token received at ${DateTime.now()}: $recaptchaToken');

      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          print('Verification completed automatically at ${DateTime.now()}');
          Provider.of<UserState>(context, listen: false).setPhone(phone);
          Provider.of<UserState>(context, listen: false).setSignInTime(DateTime.now());
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed at ${DateTime.now()}: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent at ${DateTime.now()}: $verificationId');
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
          print('Verification timeout at ${DateTime.now()}: $verificationId');
        },
      );
    } catch (e) {
      print('Failed to start phone verification at ${DateTime.now()}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the blur intensity as needed
              child: Container(
                color: Colors.black.withOpacity(0.3), // Adjust the opacity as needed
              ),
            ),
          ),
          // Main content
          Container(
            color: Colors.transparent, // Make the background transparent
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/title.png',
                  height: 200,
                  width: 600,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 640,
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number', // Display as a hint, not as a floating label
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We will send you a one-time code to get started',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 640,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String phone = _phoneController.text
                          .replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters for pure number validation
                      if (phone.length == 10) {
                        String phoneWithCode = '+1$phone';
                        verifyPhoneNumber(phoneWithCode);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => SecurityCodeScreen(verificationId: '',)),
                        // ); If exactly 10 digits, proceed to write to Firebase
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 640,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        await _signInWithGoogleWeb(context);
                      } else {
                        await _signInWithGoogle(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainNavigationPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1DB954), // Green color for the button
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // More rectangular, less rounded
                      ),
                    ),
                    child: const Text(
                      'Sign In with Google',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showEmailPasswordSignInDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1DB954), // Green color for the button
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // More rectangular, less rounded
                    ),
                  ),
                  child: const Text(
                    'Sign In with Email/Password',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}