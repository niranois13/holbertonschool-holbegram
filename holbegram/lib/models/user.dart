import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uuid;
  String email;
  String username;
  String bio;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  List<dynamic> saved;
  String searchKey;

  Users({
    required this.uuid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  factory Users.fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Users(
      uuid: data['uuid'],
      email: data['email'],
      username: data['username'],
      bio: data['bio'],
      photoUrl: data['photoUrl'],
      followers: data['followers'] ?? [],
      following: data['following'] ?? [],
      posts: data['posts'] ?? [],
      saved: data['saved'] ?? [],
      searchKey: data['searchKey'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'email': email,
    'username': username,
    'bio': bio,
    'photoUrl': photoUrl,
    'followers': followers,
    'following': following,
    'posts': posts,
    'saved': saved,
    'searchKey': searchKey,
  };
}