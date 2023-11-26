import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/data%20classes/UserInfo.dart';

class Auth_Provider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
   final DatabaseReference _database = FirebaseDatabase.instance.ref();
  User? _user;
  UsersInfo? _usersInfo;

  User? get user => _user;
  UsersInfo? get usersInfo => _usersInfo;

  // Check if the user is already signed in on app start
  Future<void> checkCurrentUser() async {
    _user = _auth.currentUser;
    if (_user != null) {      
      await _fetchUserInfo(_user!.uid);
    }
    notifyListeners();
  }
// Fetch user info from Firebase Realtime Database
  Future<void> _fetchUserInfo(String userId) async {
   try {
    _database.child('users/$userId/userinfo').once().then((snapshot) {
      DataSnapshot dataSnapshot = snapshot.snapshot; // Access snapshot property
      if (dataSnapshot.value != null) {
        // Handle the received DataSnapshot
        Map<String, dynamic>? userData = dataSnapshot.value as Map<String, dynamic>?;

        if (userData != null) {
          _usersInfo = UsersInfo.fromJson(userData);
          notifyListeners();
        }
      }
    }).catchError((error) {
      print('Error fetching user info: $error');
    });
  } catch (e) {
    print('Error fetching user info: $e');
  }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );      
      _user = userCredential.user;
      if (_user != null) {
        await _fetchUserInfo(_user!.uid);
      }
      notifyListeners();
    } catch (e) {
      // Handle sign-in errors
      print('Sign in error: $e');
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(String email, String password, UsersInfo usersInfo) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        // Save additional user info to Firebase Realtime Database
        _database.child('users/${userCredential.user!.uid}/userinfo').set(usersInfo.toJson());
      }
      _user = userCredential.user;
      if (_user != null) {
        await _fetchUserInfo(_user!.uid);
      }
      notifyListeners();
    } catch (e) {
      // Handle registration errors
      print('Registration error: $e');
    }
  }
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      // Handle sign-out errors
      print('Sign out error: $e');
    }
  }
}
