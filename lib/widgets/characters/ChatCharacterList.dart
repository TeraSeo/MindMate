import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/providers/UserProvider.dart';
import 'package:ai_chatter/services/CharacterService.dart';
import 'package:ai_chatter/widgets/characters/ChatCharacterBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatCharacterList extends StatefulWidget {
  final User user;
  const ChatCharacterList({super.key, required this.user});

  @override
  State<ChatCharacterList> createState() => _ChatCharacterListState();
}

class _ChatCharacterListState extends State<ChatCharacterList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CharacterService().fetchUserCharacters(widget.user.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.welcomeMessage,
              style: TextStyle(
                fontSize: FontSize.h4,
                color: ConstantColor.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        final characters = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return ChatCharacterBox(character: character, userId: widget.user.uid!);
          },
        );
      },
    );
  }
}