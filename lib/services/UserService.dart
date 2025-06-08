import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<void> updateUser(String name, String ageGroup, String gender, Map<String, bool> notificationPreferences) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
        'ageGroup': ageGroup,
        'gender': gender,
        'notificationPreferences': notificationPreferences,
        'isUserSet': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
  }
}