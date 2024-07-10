import 'package:flutter/material.dart';

class SecurityCodeScreen extends StatefulWidget {
  const SecurityCodeScreen({super.key, required String verificationId});

  @override
  _SecurityCodeScreenState createState() => _SecurityCodeScreenState();
}

class _SecurityCodeScreenState extends State<SecurityCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final String _code = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color(0xFF121212), // Set the background color to dark grey.
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 200), // Reduced vertical padding
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Next page not designed yet lol.'),
                        backgroundColor: Colors.red,
                      ),
                    );
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

