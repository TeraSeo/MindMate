import 'package:ai_chatter/controllers/ChatController.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({super.key});

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  late ChatController controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller = Provider.of<ChatController>(context, listen: false);
      controller.focusNode.addListener(() {
        if (!controller.focusNode.hasFocus) {
          controller.handleTypingFinish(controller.characterId);
        } else {
          controller.typingTimer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    controller = Provider.of<ChatController>(context);

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
                decoration: InputDecoration(
                  hintText: l10n.typeAMessage,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: BoxSize.spacingM,
                    vertical: BoxSize.spacingS,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
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
              onPressed: () => controller.sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}