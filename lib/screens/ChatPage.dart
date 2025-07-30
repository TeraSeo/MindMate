import 'package:ai_chatter/constants/Dialogs.dart';
import 'package:ai_chatter/controllers/ChatController.dart';
import 'package:ai_chatter/services/AdsService.dart';
import 'package:ai_chatter/services/ChatSessionService.dart';
import 'package:ai_chatter/services/MessageService.dart';
import 'package:ai_chatter/services/ReviewService.dart';
import 'package:ai_chatter/services/UserService.dart';
import 'package:ai_chatter/widgets/chat/ChatInputBox.dart';
import 'package:ai_chatter/widgets/chat/ChatMessageList.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> character;

  const ChatPage({super.key, required this.character});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController? _chatController;
  final ReviewService reviewService = ReviewService();

  @override
  void initState() {
    super.initState();
    _initializeChatPage();
  }

  void _initializeChatPage() async {
    final scrollController = ScrollController();
    final messageController = TextEditingController();
    final focusNode = FocusNode();
    final userInfo = await UserService().getUserInfo();

    if (!mounted) return;

    setState(() {
      _chatController = ChatController(
        context,
        widget.character,
        UserService(),
        ChatSessionService(),
        MessageService(),
        scrollController,
        messageController,
        focusNode,
        userInfo ?? {},
      );
    });

  _chatController!.initialize(widget.character['characterId']);
  _chatController!.setupScrollListener(widget.character['characterId']);
}

  @override
  void dispose() {
    _chatController!.scrollController.dispose();
    _chatController!.messageController.dispose();
    _chatController!.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.character['name'] ?? 'Character';

    if (_chatController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider<ChatController>.value(
      value: _chatController!,
      child: WillPopScope(
        onWillPop: () async {
          final prefs = await SharedPreferences.getInstance();
          final hasRequestedReview = prefs.getBool('has_requested_review') ?? false;

          if (!hasRequestedReview && _chatController != null && _chatController!.messages.length > 3) {
            final confirmed = await Dialogs.showReviewDialog(context);
            if (confirmed) {
              await reviewService.requestReview();
            }
            await prefs.setBool('has_requested_review', true);
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
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
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque, 
            child: Column(
              children: const [
                Expanded(child: ChatMessageList()),
                ChatInputBox(),
              ],
            )
          )
        )
      )
    );
  }
}