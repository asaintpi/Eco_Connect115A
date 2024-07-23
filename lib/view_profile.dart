import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  final String otherUserPhone;

  ViewProfilePage({required this.otherUserPhone});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  double? userRating; // Nullable to handle loading or absence of data
  int? numberOfRatings; // Nullable to handle loading or absence of data

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0;
        return AlertDialog(
          title: Text('Rate ${widget.otherUserPhone}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rate this user:'),
              SizedBox(height: 10),
              RatingBar(
                initialRating: rating,
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // TODO: Implement logic to submit rating to backend
                setState(() {
                  userRating = rating;
                  numberOfRatings = (numberOfRatings ?? 0) + 1;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStarRating(double? rating) {
    if (rating == null) {
      return Text('Rating: N/A', style: TextStyle(color: Colors.white));
    }

    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) > 0.5;
    List<Widget> stars = [];

    // Full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }

    // Half star if applicable
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }

    // Empty stars to fill the row (if needed)
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow));
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        iconTheme: IconThemeData(color: const Color(0xFFB3B3B3)),
        title: Row(
          children: [
            Text(
              'Profile - ${widget.otherUserPhone}',
              style: TextStyle(color: const Color(0xFFB3B3B3)),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _reportUser(widget.otherUserPhone);
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.flag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/elogo.png'), // Placeholder image
            ),
            SizedBox(height: 20),
            Text(
              'Username: ${userRating != null ? 'Jane Doe' : 'Loading...'}', // Placeholder or loading text
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${widget.otherUserPhone}', // Display the user's phone number
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Rating: ',
                  style: TextStyle(color: Colors.white),
                ),
                _buildStarRating(userRating),
                SizedBox(width: 10),
                Text(
                  '(${numberOfRatings ?? 'Loading...'})', // Placeholder or loading text
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRatingDialog,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1DB954)),
              ),
              child: Text('Rate User'),
            ),
          ],
        ),
      ),
    );
  }

  void _reportUser(String userPhone) {
    // TODO: Implement user reporting functionality
    print('Reported user: $userPhone');
  }
}

class RatingBar extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;

  const RatingBar({
    Key? key,
    required this.initialRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rating = initialRating;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating.floor()
                ? Icons.star
                : index < rating.ceil() ? Icons.star_half : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onRatingUpdate(index + 1.0);
          },
        );
      }),
    );
  }
}
