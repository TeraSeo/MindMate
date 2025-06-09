import 'package:ai_chatter/controllers/ChatController.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatController>(context);
    final characterId = controller.sessionId != null ? controller.sessionId! : '';

    return Container(
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
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: controller.messageController,
                focusNode: controller.focusNode,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: BoxSize.spacingM,
                    vertical: BoxSize.spacingS,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(characterId),
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
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => controller.sendMessage(characterId),
            ),
          ),
        ],
      ),
    );
  }
}
