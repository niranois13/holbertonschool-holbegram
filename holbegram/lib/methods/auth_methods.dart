import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/models/user.dart';
import 'dart:typed_data';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<String> login({required String email,required String password,}) async {
    if (email.isEmpty || password.isEmpty) {
      return ('Please fill all the fields');
    }

    try {
      var userCredentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredentials.user;
      if (user == null) {
        return ('error');
      }
      return ('success');
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
    }) async {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return ('Please fill all the fields');
      }

      try {
        var userCredentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredentials.user;

        Users users = Users(
          email: email,
          username: username,
          uuid: user!.uid,
          bio: '',
          photoUrl: '',
          followers: [],
          following: [],
          posts: [],
          saved: [],
          searchKey: '',
        );

        await _firestore.collection("users").doc(user.uid).set(users.toJson());
        return ('success');
      } catch (error) {
        return (error.toString());
      }
  }

  Future<Users?> getUserDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        final user = Users.fromSnap(snapshot);
        return user;
      }
    } catch (error) {
      print(error.toString());
    }
    
    return null;
  }

  Future<String> logOut() async {
    try {
        await _auth.signOut();
        return('success');
    } catch (error) {
        return(error.toString());
    }
  }

  
}