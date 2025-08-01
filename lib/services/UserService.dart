import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<void> createUser(UserCredential userCredential, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'subscription': 'free',
      'isUserSet': false,
      'usedToken': 0,
    });
  }

  Future<void> updateUser(String name, String ageGroup, String gender, bool _notificationsEnabled) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
        'ageGroup': ageGroup,
        'gender': gender,
        '_notificationsEnabled': _notificationsEnabled,
        'isUserSet': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
  }

  Future<void> updateLastLoginAndResetIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    final data = snapshot.data();
    if (data == null) return;

    final lastLoginAt = (data['lastLoginAt'] as Timestamp?)?.toDate();
    final now = DateTime.now();

    bool shouldResetUsedToken = false;

    if (lastLoginAt != null) {
      final today = DateTime(now.year, now.month, now.day);
      final lastLoginDay = DateTime(lastLoginAt.year, lastLoginAt.month, lastLoginAt.day);
      if (lastLoginDay.isBefore(today)) {
        shouldResetUsedToken = true;
      }
    }

    await userRef.update({
      'lastLoginAt': FieldValue.serverTimestamp(),
      if (shouldResetUsedToken) 'usedToken': 0,
    });
  }

  Future<int> getUsedToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    final data = snapshot.data();
    if (data == null) return 0;

    final usedToken = data['usedToken'] ?? 0;
    return usedToken;
  }

  Future<void> increaseUsedToken(int addedCount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    final data = snapshot.data();
    if (data == null) return;

    final currentUsedToken = data['usedToken'] ?? 0;
    final updatedUsedToken = currentUsedToken + addedCount;

    await userRef.update({'usedToken': updatedUsedToken});
  }

  Future<void> resetUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    final data = snapshot.data();
    if (data == null) return;

    await userRef.update({'usedToken': 0});
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return snapshot.data();
  }

  Future<void> removeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. Firestore에서 사용자 문서 삭제
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // 2. Firebase Authentication에서 사용자 삭제
      await user.delete();
    } catch (e) {
      rethrow; // 호출하는 쪽에서 에러를 처리하도록 던짐
    }
  }
}