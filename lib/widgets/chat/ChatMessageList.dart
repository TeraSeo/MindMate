import 'package:ai_chatter/controllers/ChatController.dart';
import 'package:ai_chatter/widgets/chat/LoadingBubble.dart';
import 'package:ai_chatter/widgets/chat/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatController>(context);

    if (controller.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.messages.length + (controller.isGenerating ? 1 : 0),
      itemBuilder: (context, index) {
        if (controller.isFetchingMore && index == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        if (index == controller.messages.length && controller.isGenerating) {
          return const LoadingBubble(animation: AlwaysStoppedAnimation(1.0));
        }

        final message = controller.messages[index];
        return MessageBubble(
          text: message['text'],
          isUser: message['isUser'],
          timestamp: message['timestamp'],
        );
      },
    );
  }
}