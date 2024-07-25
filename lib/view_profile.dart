import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globalstate.dart';

// View another users' profile
class ViewProfilePage extends StatefulWidget {
  final String otherUserPhone;

  ViewProfilePage({required this.otherUserPhone});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  String userName = 'Loading...';
  String userPhone = 'Loading...';
  double? userRating;
  int? numberOfRatings;
  String userEmail = 'Loading...';
  String profileImageUrl = '';
  String phoneForEmailOnly = '1111111111';

  @override
  void initState() {
    super.initState();
    if (widget.otherUserPhone == phoneForEmailOnly) {
      getUserDataByEmail();
    } else {
      getUserDataByPhone();
    }
  }

  // Retrieve user instance by email
  Future<void> getUserDataByEmail() async {
    final database = FirebaseDatabase.instance.ref();
    final email = Provider.of<UserState>(context, listen: false).email;

    try {
      if (email.isNotEmpty) {
        final event = await database.child('users')
            .orderByChild('email')
            .equalTo(email)
            .once();

        final snapshot = event.snapshot;

        if (snapshot.value != null) {
          final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);

          userData.forEach((key, value) {
            final user = Map<String, dynamic>.from(value);
            print('User found: $user');
            setState(() {
              userName = user['name'];
              profileImageUrl = user['profileImageUrl'];
              userRating = user['rating']?.toDouble() ?? 0.0;
              numberOfRatings = user['numberOfRatings']?.toInt() ?? 0;
            });
          });
        } else {
          print('No user found with the email: $email');
        }
      } else {
        print('Email is not available or empty.');
      }
    } on FirebaseException catch (e) {
      print('Error retrieving data: $e');
    }
  }

  // Retrieve user instance by phone
  Future<void> getUserDataByPhone() async {
    final database = FirebaseDatabase.instance.ref();
    final phone = widget.otherUserPhone;

    try {
      final event = await database.child('users')
          .orderByChild('phone')
          .equalTo(phone)
          .once();

      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
        userData.forEach((key, value) {
          final user = Map<String, dynamic>.from(value);
          print('User found: $user');
          setState(() {
            userName = user['name'];
            userPhone = user['phone'];
            userEmail = user['email'];
            profileImageUrl = user['profileImageUrl'];
            userRating = user['rating']?.toDouble() ?? 0.0;
            numberOfRatings = user['numberOfRatings']?.toInt() ?? 0;
          });
        });
      } else {
        print('No user found with the phone number: $phone');
        if (phone == phoneForEmailOnly) {
          getUserDataByEmail();
        }
      }
    } on FirebaseException catch (e) {
      print('Error retrieving data: $e');
    }
  }

  // Save rating of user to Firebase
  Future<void> saveRating(double rating) async {
    final database = FirebaseDatabase.instance.ref();
    final phone = widget.otherUserPhone;

    try {
      final event = await database.child('users').orderByChild('phone').equalTo(phone).once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final userData = Map<String, dynamic>.from(snapshot.value as Map);
        userData.forEach((key, value) async {
          final user = Map<String, dynamic>.from(value);
          final currentRating = user['rating']?.toDouble() ?? 0.0;
          final currentNumberOfRatings = user['numberOfRatings']?.toInt() ?? 0;

          final newRating = (currentRating * currentNumberOfRatings + rating) / (currentNumberOfRatings + 1);
          final newNumberOfRatings = currentNumberOfRatings + 1;

          await database.child('users/$key').update({
            'rating': newRating,
            'numberOfRatings': newNumberOfRatings,
          });

          setState(() {
            userRating = newRating;
            numberOfRatings = newNumberOfRatings;
          });
        });
      }
    } on FirebaseException catch (e) {
      print('Error saving rating: $e');
    }
  }

  // Display 5 stars for rating
  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0;
        return AlertDialog(
          title: Text('Rate $userName'),
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
                saveRating(rating);
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

  // Change User rating
  Future<void> updateUserRating(double rating) async {
    final database = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot;
    if (widget.otherUserPhone == phoneForEmailOnly) {
      final email = Provider.of<UserState>(context, listen: false).email;
      final query = database.child('users').orderByChild('email').equalTo(email).limitToFirst(1);
      final result = await query.once();
      snapshot = result.snapshot;
    } else {
      final query = database.child('users').orderByChild('phone').equalTo(widget.otherUserPhone).limitToFirst(1);
      final result = await query.once();
      snapshot = result.snapshot;
    }

    if (snapshot.value != null) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      int currentRatings = userData['numberOfRatings'] ?? 0;
      double currentRating = userData['rating']?.toDouble() ?? 0.0;

      double newRating = ((currentRating * currentRatings) + rating) / (currentRatings + 1);
      int newNumberOfRatings = currentRatings + 1;

      database.child('users').child(snapshot.key!).update({
        'rating': newRating,
        'numberOfRatings': newNumberOfRatings,
      });

      setState(() {
        userRating = newRating;
        numberOfRatings = newNumberOfRatings;
      });
    }
  }

  // UI for star rating
  Widget _buildStarRating(double? rating) {
    if (rating == null) {
      return Text('Rating: N/A', style: TextStyle(color: Colors.white));
    }

    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) > 0.5;
    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }

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
        title: Text(
          'Profile - $userName',
          style: TextStyle(color: const Color(0xFFB3B3B3)),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _reportUser(userPhone);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.flag,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl) as ImageProvider<Object>
                    : AssetImage('assets/images/elogo.png') as ImageProvider<Object>, // Placeholder image
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Username: $userName',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rating: ',
                  style: TextStyle(color: Colors.white),
                ),
                _buildStarRating(userRating),
                SizedBox(width: 10),
                Text(
                  '(${numberOfRatings ?? 'Loading...'})',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showRatingDialog,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF1E88E5)),
                ),
                child: Text('Rate User'),
              ),
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
