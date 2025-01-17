import 'package:eco_connect/globalstate.dart';
import 'package:eco_connect/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eco_connect/emailpass.dart';

// Security Screen used for SMS 6 digit code verification
class SecurityCodeScreen extends StatefulWidget {
  const SecurityCodeScreen({super.key, required this.verificationId, required this.phone});
  final String verificationId;
  final String phone;

  @override
  _SecurityCodeScreenState createState() => _SecurityCodeScreenState();
}

class _SecurityCodeScreenState extends State<SecurityCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  // Phone number saved to database
  Future<void> writeUserData(String phone) async {
    final database = FirebaseDatabase.instance.ref();
    final Map<String, dynamic> user = {
      'phone': phone,  // Using the phone number from the input
    };

    try {
      // Push data to the 'users' node with a unique key
      await database.child('users').push().set(user);
      // Show success message or perform other actions (optional)
      print('Phone number written successfully!');
    } on FirebaseException catch (e) {
      // Handle potential errors during data writing
      print('Error writing data: $e');
    }
  }

  // Checks if user already has an account
  Future<bool> checkIfUserExists(String phone) async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('users').orderByChild('phone').equalTo(phone).get();

    return snapshot.exists;
  }

  // 6 digit SMS verification
  Future<void> verifyCode() async {
    final String code = _codeController.text.trim();

    if (code.length == 6) {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );

      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        // Handle successful sign-in (navigate to a different screen, etc.)
        print(
            'Verification successful, user signed in: ${userCredential.user}');
              bool userExists = await checkIfUserExists(widget.phone);
              Provider.of<UserState>(context, listen: false).setPhone(widget.phone);
              if(userExists){
                print("User exists");
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainNavigationPage()));
              }
              else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SetupEmailPasswordPage(phone: widget.phone,)));

              }

        // Navigate to your desired screen
      } catch (e) {
        // Handle error (e.g., incorrect code)
        print('Error signing in with credential: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }}


  @override
  void initState() {
    super.initState();
    _codeController.addListener(_updateCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _updateCode() {
    if (_codeController.text.length > 6) {
      _codeController.text = _codeController.text.substring(0, 6);
    }
    setState(() {});
  }

  // Boxes built for digit entry
  Widget _buildDigitBoxes() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) => _buildSingleDigitBox(index)),
        ),
        Positioned.fill(
          child: TextField(
            controller: _codeController,
            autofocus: true,
            showCursor: false,
            cursorColor: Colors.white, // Set cursor color to white for visibility
            cursorWidth: 2.0, // Set cursor width to match your design
            cursorHeight: 30, // Adjust cursor height to fit within the digit boxes
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: const TextStyle(color: Colors.transparent, fontSize: 1), // Transparent text
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
              counterText: "",  // This hides the counter

            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }



  Widget _buildSingleDigitBox(int index) {
    bool hasFocus = _codeController.text.length == index;
    Color boxColor = hasFocus ? Colors.white : const Color(0xFF535353); // Highlight the current digit box

    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        _codeController.text.length > index ? _codeController.text[index] : '',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  // Main widget, page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color(0xFF121212), // Set the background color to dark grey.
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50), // Reduced vertical padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Security Code',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w300,  // Set font weight to light
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the 6 digit code sent to your number.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 175),
            _buildDigitBoxes(),

            const SizedBox(height: 50),
            SizedBox(
              width: 640,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_codeController.text.length == 6) {
                    // Implement validation and submission logic here
                    verifyCode();

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _codeController.text.length == 6 ? const Color(0xFF1DB954) : const Color(0xFF013714),  // Dynamically change color
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text(
                    'Submit',
                    style: TextStyle(
                        color: _codeController.text.length == 6 ? Colors.white : Color(0xFF1DB954),  // Text color based on state
                        fontSize: 16
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

