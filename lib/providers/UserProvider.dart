import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class User {
  final String? uid;
  final String? name;
  final String? age;
  final String? gender;
  final bool notificationsEnabled;
  final String? email;
  final String subscription;
  final bool isSetUp;

  User({
    this.uid,
    this.name,
    this.age,
    this.gender,
    this.notificationsEnabled = true,
    this.email,
    this.subscription = 'free',
    this.isSetUp = false,
  });

  User copyWith({
    String? uid,
    String? name,
    String? age,
    String? gender,
    bool? notificationsEnabled,
    String? email,
    String? subscription,
    bool? isSetUp,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      email: email ?? this.email,
      subscription: subscription ?? this.subscription,
      isSetUp: isSetUp ?? this.isSetUp,
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return User(
      uid: doc.id,
      name: data?['name'],
      age: data?['ageGroup'],
      gender: data?['gender'],
      notificationsEnabled: data?['notificationsEnabled'] ?? true,
      email: data?['email'],
      subscription: data?['subscription'] ?? 'free',
      isSetUp: data?['isUserSet'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'notificationsEnabled': notificationsEnabled,
      'email': email,
      'subscription': subscription,
      'isUserSet': isSetUp,
    };
  }
}

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  User? get user => _user;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserData();
  }

  void _loadUserData() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _userSubscription?.cancel();
      _userSubscription = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _user = User.fromFirestore(snapshot);
        } else {
          // If document doesn't exist, create it with default values
          _user = User(
            uid: currentUser.uid,
            email: currentUser.email,
            isSetUp: false,
          );
          _firestore.collection('users').doc(currentUser.uid).set(_user!.toMap());
        }
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? age,
    String? gender,
    bool? notificationsEnabled,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (age != null) updates['ageGroup'] = age;
    if (gender != null) updates['gender'] = gender;
    if (notificationsEnabled != null) {
      updates['notificationsEnabled'] = notificationsEnabled;
    }
    updates['isUserSet'] = true;  // Mark user as set up when profile is updated

    await _firestore.collection('users').doc(currentUser.uid).update(updates);
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
} 