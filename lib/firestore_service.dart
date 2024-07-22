import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost({
    required String userId,
    required String title,
    required String description,
    required GeoPoint location,
    required String category,
    required double price,
    required List<String> images,
  }) async {
    await _db.collection('posts').add({
      'userId': userId,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
      'images': images,
      'status': 'active',
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _db.collection('posts').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updatePostStatus(String postId, String status) async {
    await _db.collection('posts').doc(postId).update({'status': status});
  }
}
