import 'package:ai_chatter/widgets/chat/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> character;
  const ChatPage({super.key, required this.character});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late AnimationController _dotAnimationController;
  late Animation<double> _dotAnimation;
  String? _sessionId;
  final _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
    _dotAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _dotAnimation = Tween<double>(begin: 0, end: 1).animate(_dotAnimationController);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _dotAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeChatSession() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final characterId = widget.character['characterId'];
    final sessionsRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatsessions');

    // Check for existing active session
    final activeSession = await sessionsRef
        .orderBy('lastActiveAt', descending: true)
        .limit(1)
        .get();

    if (activeSession.docs.isNotEmpty) {
      _sessionId = activeSession.docs.first.id;
      await sessionsRef.doc(_sessionId).update({
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
      
      // Load existing messages
      await _loadMessages();
    } else {
      // Create new session
      _sessionId = _uuid.v4();
      await sessionsRef.doc(_sessionId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
        'summary': '대화가 시작되었습니다.',
      });
    }
  }

  Future<void> _loadMessages() async {
    if (_sessionId == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final characterId = widget.character['characterId'];
    final messagesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatsessions')
        .doc(_sessionId)
        .collection('messages')
        .orderBy('createdAt', descending: false);

    try {
      final messagesSnapshot = await messagesRef.get();
      
      setState(() {
        _messages.clear();
        for (var doc in messagesSnapshot.docs) {
          final data = doc.data();
          _messages.add({
            'text': data['content'],
            'isUser': data['role'] == 'user',
            'timestamp': (data['createdAt'] as Timestamp).toDate(),
          });
        }
      });

      _scrollToBottom();
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  Future<void> _saveMessage(String content, String role) async {
    if (_sessionId == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final characterId = widget.character['characterId'];
    final messageId = _uuid.v4();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatsessions')
        .doc(_sessionId)
        .collection('messages')
        .doc(messageId)
        .set({
      'role': role,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _generateAIResponse(String userMessage) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final token = await user.getIdToken();
      final response = await http.post(
        Uri.parse('https://generategptresponse-ythjyxem5a-uc.a.run.app'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'personality': widget.character['personality'],
          'relationship': widget.character['relationship'],
          'chattingStyle': widget.character['chattingStyle'],
          'gender': widget.character['gender'],
          'ageGroup': widget.character['ageGroup'],
          'replyLanguage': widget.character['language'],
          'userMessage': userMessage,
          'conversationSummary': _generateConversationSummary(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final aiResponse = responseData['reply'] as String?;
        
        if (aiResponse == null) {
          throw Exception('Invalid response format from server');
        }

        final messages = aiResponse
            .split('\\n')
            .map((msg) => msg.trim())
            .where((msg) => msg.isNotEmpty);
        
        setState(() {
          for (final message in messages) {
            _messages.add({
              'text': message,
              'isUser': false,
              'timestamp': DateTime.now(),
            });
            // Save AI message to Firestore
            _saveMessage(message, 'assistant');
          }
        });

        // Update session summary
        await _updateSessionSummary();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  String _generateConversationSummary() {
    // Generate a simple summary of the conversation
    if (_messages.isEmpty) {
      return "This is the start of the conversation.";
    }
    
    final recentMessages = _messages.take(5).toList();
    return recentMessages.map((m) => m['text']).join(' ');
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    // Save user message to Firestore
    await _saveMessage(userMessage, 'user');

    _scrollToBottom();
    await _generateAIResponse(userMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _updateSessionSummary() async {
    if (_sessionId == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final characterId = widget.character['characterId'];
    final summary = _generateConversationSummary();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(characterId)
        .collection('chatSessions')
        .doc(_sessionId)
        .update({
      'summary': summary,
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ConstantColor.primaryColor.withOpacity(0.1),
            child: Text(
              'AI',
              style: TextStyle(
                fontSize: FontSize.bodySmall,
                color: ConstantColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BoxSize.spacingM,
              vertical: BoxSize.spacingS,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(BoxSize.cardRadius),
                topRight: Radius.circular(BoxSize.cardRadius),
                bottomRight: Radius.circular(BoxSize.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Typing...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: FontSize.bodyMedium,
                  ),
                ),
                AnimatedBuilder(
                  animation: _dotAnimation,
                  builder: (context, child) {
                    final dots = (3 * _dotAnimation.value).floor();
                    return Text(
                      '.' * dots,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: FontSize.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final name = character['name'] ?? 'Unnamed';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: ConstantColor.primaryColor.withOpacity(0.1),
              child: Text(
                name[0],
                style: TextStyle(
                  fontSize: FontSize.h6,
                  color: ConstantColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: FontSize.h6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/chat_background.png'),
                      opacity: 0.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(BoxSize.spacingM),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return _buildLoadingBubble();
                      }
                      final message = _messages[index];
                      return MessageBubble(
                        text: message['text'],
                        isUser: message['isUser'],
                        timestamp: message['timestamp'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(BoxSize.spacingM),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(BoxSize.inputRadius),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: BoxSize.spacingM,
                                vertical: BoxSize.spacingS,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Implement emoji picker
                          },
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: BoxSize.spacingM),
                Container(
                  decoration: BoxDecoration(
                    color: ConstantColor.primaryColor,
                    borderRadius: BorderRadius.circular(BoxSize.inputRadius),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}