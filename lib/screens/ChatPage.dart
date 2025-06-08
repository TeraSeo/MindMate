import 'dart:async';
import 'package:ai_chatter/services/ChatSessionService.dart';
import 'package:ai_chatter/services/MessageService.dart';
import 'package:ai_chatter/widgets/chat/LoadingBubble.dart';
import 'package:ai_chatter/widgets/chat/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> character;
  const ChatPage({super.key, required this.character});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final ChatSessionService _chatSessionService = ChatSessionService();
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late AnimationController _dotAnimationController;
  late Animation<double> _dotAnimation;
  String? _sessionId;
  bool _isInitialLoading = true;
  List<String> _sentMessagesBuffer = [];
  Timer? _typingTimer;
  bool _isGeneratingResponse = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
    _dotAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _dotAnimation = Tween<double>(begin: 0, end: 1).animate(_dotAnimationController);

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _dotAnimationController.dispose();
    _typingTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _sentMessagesBuffer.isNotEmpty) {
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (!_focusNode.hasFocus && _sentMessagesBuffer.isNotEmpty) {
          final combinedMessage = _sentMessagesBuffer.join('\\n');
          _sentMessagesBuffer.clear();
          _generateAIResponse(combinedMessage);
        }
      });
    } else {
      _typingTimer?.cancel();
    }
  }

  Future<void> _initializeChatSession() async {
    final characterId = widget.character['characterId'];
    _sessionId = await _chatSessionService.initializeSession(characterId: characterId);
    await _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_sessionId == null) return;
    setState(() => _isInitialLoading = true);

    try {
      final characterId = widget.character['characterId'];
      final messages = await _messageService.loadMessages(
        characterId: characterId,
        sessionId: _sessionId!,
      );

      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _isInitialLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      print('Error loading messages: $e');
      setState(() => _isInitialLoading = false);
    }
  }

  Future<void> _saveMessage(String content, String role) async {
    await _messageService.saveMessage(
      characterId: widget.character['characterId'],
      sessionId: _sessionId!,
      content: content,
      role: role,
    );
  }

  Future<void> _generateAIResponse(String userMessage) async {
    if (_isGeneratingResponse || userMessage.trim().isEmpty) return;
    _isGeneratingResponse = true;

    setState(() {
      _isLoading = true;
    });

    try {
      final replies = await _messageService.generateAIResponse(
        character: widget.character,
        userMessage: userMessage,
        conversationSummary: _generateConversationSummary(),
      );

      setState(() {
        for (final message in replies) {
          _messages.add({
            'text': message,
            'isUser': false,
            'timestamp': DateTime.now(),
          });
        }
      });

      for (final message in replies) {
        await _messageService.saveMessage(
          characterId: widget.character['characterId'],
          sessionId: _sessionId!,
          content: message,
          role: 'assistant',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isGeneratingResponse = false;
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  String _generateConversationSummary() {
    if (_messages.isEmpty) {
      return "This is the start of the conversation.";
    }

    final int count = _messages.length;
    final int start = count > 10 ? count - 10 : 0;
    final recentMessages = _messages.sublist(start, count);

    return recentMessages.map((m) {
      final role = m['isUser'] == true ? 'user' : 'ai';
      final text = m['text'] ?? '';
      return '$role: $text';
    }).join('\n');
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();
    _sentMessagesBuffer.add(userMessage);

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
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: _isInitialLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ConstantColor.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading messages...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: FontSize.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(BoxSize.spacingM),
                            itemCount: _messages.length + (_isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isLoading) {
                                return LoadingBubble(animation: _dotAnimation);
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
                              focusNode: _focusNode,
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
                            )
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
      )
    );
  }
}