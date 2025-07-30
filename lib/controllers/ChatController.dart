import 'dart:async';
import 'dart:math';
import 'package:ai_chatter/constants/Dialogs.dart';
import 'package:ai_chatter/services/AdsService.dart';
import 'package:ai_chatter/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/ChatSessionService.dart';
import '../services/MessageService.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatController with ChangeNotifier {
  final BuildContext context;
  final Map<String, dynamic> _character;
  final UserService _userService;
  final ChatSessionService _chatSessionService;
  final MessageService _messageService;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final FocusNode focusNode;
  final Map<String, dynamic> _userInfo;

  final List<Map<String, dynamic>> messages = [];
  String? sessionId;
  DocumentSnapshot? lastLoadedDoc;
  bool hasMore = true;
  bool isLoading = false;
  bool isInitialLoading = true;
  bool isGenerating = false;
  bool isFetchingMore = false;
  final List<String> _sentBuffer = [];
  Timer? _typingTimer;
  int usedToken = 0;
  String chatSummary = "";
  final Uuid _uuid = const Uuid();
  final adsService = AdsService();

  ChatController(
    this.context,
    this._character,
    this._userService,
    this._chatSessionService,
    this._messageService,
    this.scrollController,
    this.messageController,
    this.focusNode,
    this._userInfo,
  );

  String get characterId => _character['characterId'];
  Timer? get typingTimer => _typingTimer;

  void setupScrollListener(String characterId) {
    scrollController.addListener(() {
      // 전체 스크롤 높이 대비 현재 위치의 비율
      final currentOffset = scrollController.offset;
      final maxExtent = scrollController.position.maxScrollExtent;
      const thresholdRatio = 0.35; // 상단 15% 근처면 로드

      if (currentOffset < maxExtent * thresholdRatio &&
          !isFetchingMore &&
          hasMore) {
        fetchMore(characterId);
      }
    });
  }

  Future<void> initialize(String characterId) async {
    sessionId = await _chatSessionService.initializeSession(characterId: characterId);
    await loadInitialMessages(characterId);
    usedToken = await loadUsedToken();
    chatSummary = _generateSummary();
    adsService.loadRewardedInterstitialAd();
  }

  Future<void> loadInitialMessages(String characterId) async {
    isInitialLoading = true;
    notifyListeners();

    final newMessages = await _messageService.loadMessages(
      characterId: characterId,
      sessionId: sessionId!,
    );

    if (newMessages.isNotEmpty) {
      lastLoadedDoc = newMessages.last['doc'];
    }

    messages.clear();
    messages.addAll(newMessages.reversed);
    isInitialLoading = false;
    notifyListeners();

    scrollToBottom();
  }

  Future<int> loadUsedToken() async {
    int usedToken = await _userService.getUsedToken();
    return usedToken;
  }

  Future<void> fetchMore(String characterId) async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    notifyListeners();

    final beforeScrollOffset = scrollController.offset;
    final beforeContentHeight = scrollController.position.maxScrollExtent;

    final moreMessages = await _messageService.loadMessages(
      characterId: characterId,
      sessionId: sessionId!,
      lastDoc: lastLoadedDoc,
    );

    if (moreMessages.isEmpty) {
      hasMore = false;
    } else {
      lastLoadedDoc = moreMessages.last['doc'];
      messages.insertAll(0, moreMessages.reversed);
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 10)); // layout build wait

      final afterContentHeight = scrollController.position.maxScrollExtent;
      final heightDifference = afterContentHeight - beforeContentHeight;

      scrollController.jumpTo(beforeScrollOffset + heightDifference);
    }

    isFetchingMore = false;
    notifyListeners();
  }

  void sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;
    String characterId = _character['characterId'];

    int messageLength = messageController.text.length;
    bool canChat = (usedToken + messageLength) <= 100; // chat limit check
    if (canChat) {
      messageController.clear();
      _sentBuffer.add(content);

      final messageId = _uuid.v4();

      messages.add({
        'messageId': messageId,
        'text': content,
        'isUser': true,
        'timestamp': DateTime.now()
      });
      notifyListeners();

      await _messageService.saveMessage(
        messageId: messageId,
        characterId: characterId,
        sessionId: sessionId!,
        content: content,
        role: 'user',
      );

      usedToken += messageLength;
      _userService.increaseUsedToken(messageLength);

      scrollToBottom();
      focusNode.unfocus();
    }
    else {
      // Dialogs.showSubscriptionRequiredDialog(context);
      final l10n = AppLocalizations.of(context)!;
      Dialogs.showWatchAdsRequiredDialog(context, () {
        adsService.showRewardedInterstitialAd(
          onUserEarnedReward: () {
            _userService.resetUserToken();
            usedToken = 0;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.rewardChat)),
            );
          },
          onAdNotReady: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.failChatLoad)),
            );
          },
        );
      });
    }
  }

  void handleTypingFinish(String characterId) {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () async {
      if (_sentBuffer.isEmpty) return;
      final combined = _sentBuffer.join('\n');
      _sentBuffer.clear();
      await generateAIResponse(characterId, combined);
      chatSummary = _generateSummary();
    });
  }

  Future<void> generateAIResponse(String characterId, String userMessage) async {
    if (isGenerating) return;

    isGenerating = true;
    notifyListeners();

    final replies = await _messageService.generateAIResponse(
      character: _character,
      userMessage: userMessage,
      conversationSummary: chatSummary,
      name: _userInfo['name'],
      ageGroup: _userInfo['ageGroup'],
      gender: _userInfo['gender']
    );

    final messageId = _uuid.v4();
    
    for (final message in replies) {
      messages.add({
        'messageId': messageId,
        'text': message,
        'isUser': false,
        'timestamp': DateTime.now(),
      });

      await _messageService.saveMessage(
        messageId: messageId,
        characterId: characterId,
        sessionId: sessionId!,
        content: message,
        role: 'assistant',
      );
    }

    isGenerating = false;
    notifyListeners();
    scrollToBottom();
  }

  String _generateSummary() {
    final recent = messages.reversed.take(10).toList().reversed;
    return recent.map((m) {
      final role = m['isUser'] ? 'user' : 'ai';
      return '$role: ${m['text']}';
    }).join('\n');
  }

  void scrollToBottom({int retry = 3}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;
    final target = position.maxScrollExtent;

    if ((position.pixels - target).abs() > 20 && retry > 0) {
      scrollController.jumpTo(target);
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToBottom(retry: retry - 1);
      });
    } else {
      scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}

}