import 'package:ai_chatter/controllers/ChatController.dart';
import 'package:ai_chatter/services/ChatSessionService.dart';
import 'package:ai_chatter/services/MessageService.dart';
import 'package:ai_chatter/services/UserService.dart';
import 'package:ai_chatter/widgets/chat/ChatInputBox.dart';
import 'package:ai_chatter/widgets/chat/ChatMessageList.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> character;

  const ChatPage({super.key, required this.character});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController _chatController;

  @override
  void initState() {
    super.initState();

    final scrollController = ScrollController();
    final messageController = TextEditingController();
    final focusNode = FocusNode();

    _chatController = ChatController(
      widget.character,
      UserService(),
      ChatSessionService(),
      MessageService(),
      scrollController,
      messageController,
      focusNode,
    );

    _chatController.initialize(widget.character['characterId']);
    _chatController.setupScrollListener(widget.character['characterId']);
  }

  @override
  void dispose() {
    _chatController.scrollController.dispose();
    _chatController.messageController.dispose();
    _chatController.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.character['name'] ?? 'Character';

    return ChangeNotifierProvider<ChatController>.value(
      value: _chatController,
      child: Scaffold(
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
          children: const [
            Expanded(child: ChatMessageList()),
            ChatInputBox(),
          ],
        ),
      ),
    );
  }
}