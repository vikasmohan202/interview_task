import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;

  final String username;

  final String postUrl;

  const Post({
    required this.description,
    required this.username,
    required this.postUrl,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "username": username,
        'postUrl': postUrl,
      };
}
