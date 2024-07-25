import 'package:flutter/material.dart';

// Comments displayed in this page
class CommentListing extends StatefulWidget {

  const CommentListing({super.key, required Map this.post, required Map this.comment});
  final Map post;
  final Map comment;


  @override
  _CommentListingState createState() => _CommentListingState(post: post, comment: comment);
}

// Current Post and comment are required to be passed into this class
class _CommentListingState  extends State<CommentListing> {
  _CommentListingState({required Map this.post, required Map this.comment});

  Map post;
  Map comment;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(15),
        child: Card (
          color: Color(0xFF212121),

          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                      children: [
                          const SizedBox(width: 15,),
                        comment['profileImageUrl'] != null?
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: NetworkImage(comment['profileImageUrl']),
                        ):
                        const CircleAvatar (
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                          SizedBox(width: 10,),
                          Text(comment['author'],
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),),
                          ),

                      ],
                  ),
                  SizedBox(height: 10,),
                  Text(comment['contents'],
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),),
                  ),
                  const SizedBox(height: 20, width: 20),
                ],
              ),
            ],
          ),
        ),

    );
  }
}