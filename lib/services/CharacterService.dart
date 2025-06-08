import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CharacterService {
  static final CharacterService _instance = CharacterService._internal();
  factory CharacterService() => _instance;
  CharacterService._internal();

  Future<List<Map<String, dynamic>>> fetchUserCharacters(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('characters')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> createCharacter(String uid, Map<String, String> setupData) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Uuid _uuid = const Uuid();

    final characterId = _uuid.v4();
    final characterRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('characters')
        .doc(characterId);

    await characterRef.set({
      'characterId': characterId,
      'name': setupData['name'],
      'personality': setupData['personality'],
      'ageGroup': setupData['ageGroup'],
      'gender': setupData['gender'],
      'language': setupData['language'],
      'relationship': setupData['relationship'],
      'chattingStyle': setupData['chattingStyle'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}