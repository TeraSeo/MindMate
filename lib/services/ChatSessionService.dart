import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<String> initializeSession({
    required String characterId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final sessionsRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatSessions');

    final activeSession = await sessionsRef
        .orderBy('lastActiveAt', descending: true)
        .limit(1)
        .get();

    if (activeSession.docs.isNotEmpty) {
      final sessionId = activeSession.docs.first.id;
      await sessionsRef.doc(sessionId).update({
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
      return sessionId;
    } else {
      final sessionId = _uuid.v4();
      await sessionsRef.doc(sessionId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp()
      });
      return sessionId;
    }
  }
}