import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> loadMessages({
    required String characterId,
    required String sessionId,
    DocumentSnapshot? lastDoc, // for pagination
    int limit = 50,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    Query query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatSessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('createdAt', descending: true) // recent first
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      return {
        'text': data['content'],
        'isUser': data['role'] == 'user',
        'timestamp': (data['createdAt'] as Timestamp).toDate(),
        'doc': doc, // for pagination
      };
    }).toList();
  }
  
  Future<void> saveMessage({
    required String characterId,
    required String sessionId,
    required String content,
    required String role,
  }) async {
    final Uuid _uuid = const Uuid();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final messageId = _uuid.v4();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatSessions')
        .doc(sessionId)
        .collection('messages')
        .doc(messageId)
        .set({
      'role': role,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> generateAIResponse({
    required Map<String, dynamic> character,
    required String userMessage,
    required String conversationSummary,
    required String name,
    required String ageGroup,
    required String gender
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final token = await user.getIdToken();

    final response = await http.post(
      Uri.parse('https://generategptresponse-ythjyxem5a-uc.a.run.app'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'personality': character['personality'],
        'relationship': character['relationship'],
        'chattingStyle': character['chattingStyle'],
        'gender': character['gender'],
        'ageGroup': character['ageGroup'],
        'replyLanguage': character['language'],
        'userMessage': userMessage,
        'conversationSummary': conversationSummary,
        'username': name,
        'userAge': ageGroup,
        'userGender': gender
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);
    final aiResponse = responseData['reply'] as String?;

    if (aiResponse == null) {
      throw Exception('Invalid response format from server');
    }

    return aiResponse
        .split('\\n')
        .map((msg) => msg.trim())
        .where((msg) => msg.isNotEmpty)
        .toList();
  }
}