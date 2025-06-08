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
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final messagesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatSessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('createdAt', descending: false);

    final messagesSnapshot = await messagesRef.get();

    return messagesSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'text': data['content'],
        'isUser': data['role'] == 'user',
        'timestamp': (data['createdAt'] as Timestamp).toDate(),
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
  }) async {

    print(conversationSummary);
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