import 'package:flutter/material.dart';

class SecurityCodeScreen extends StatefulWidget {
  const SecurityCodeScreen({super.key});

  @override
  _SecurityCodeScreenState createState() => _SecurityCodeScreenState();
}

class _SecurityCodeScreenState extends State<SecurityCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Code'),
        backgroundColor: Colors.black,  // Adjust the color as needed
      ),
      body: Container(
        color: Colors.black,  // Set a dark background for the screen
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Your Security Code',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,  // Set text color to white
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Security Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,  // Assuming numeric code
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // We'll implement the validation and processing here later
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Use a suitable color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
