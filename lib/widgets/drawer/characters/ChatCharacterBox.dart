import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatCharacterBox extends StatelessWidget {
  final Map<String, dynamic> character;

  const ChatCharacterBox({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final name = character['name'] ?? 'Unnamed';
    final personality = character['personality'] ?? '';
    final relationship = character['relationship'] ?? '';
    final chattingStyle = character['chattingStyle'] ?? '';
    final gender = character['gender'] ?? '';
    final ageGroup = character['ageGroup'] ?? '';

    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        // TODO: Navigate to ChatPage with character info
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: ConstantColor.primaryColor.withOpacity(0.1),
              child: Text(
                name[0],
                style: TextStyle(
                  fontSize: FontSize.h5,
                  color: ConstantColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: FontSize.h6,
                      fontWeight: FontWeight.w600,
                      color: ConstantColor.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_localized(context, personality)} • ${_localized(context, relationship)}',
                    style: TextStyle(
                      fontSize: FontSize.bodySmall,
                      color: ConstantColor.textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildTag(_localized(context, gender)),
                      _buildTag(_localized(context, ageGroup)),
                      _buildTag(_localized(context, chattingStyle)),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _localized(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      // Gender
      case 'Male': return l10n.genderMale;
      case 'Female': return l10n.genderFemale;
      case 'Unspecified': return l10n.genderUnspecified;

      // Age Group
      case 'Child (5-12)': return l10n.ageGroupChild;
      case 'Teen (13-19)': return l10n.ageGroupTeen;
      case 'Young Adult (20-29)': return l10n.ageGroupYoungAdult;
      case 'Adult (30-49)': return l10n.ageGroupAdult;
      case 'Senior (50+)': return l10n.ageGroupSenior;

      // Chatting Style
      case 'Formal speech': return l10n.styleFormal;
      case 'Casual speech': return l10n.styleCasual;
      case 'Mixed speech': return l10n.styleMixed;
      case 'Short and direct': return l10n.styleShort;
      case 'Long and expressive': return l10n.styleLong;

      // Personality
      case 'Friendly': return l10n.personalityFriendly;
      case 'Professional': return l10n.personalityProfessional;
      case 'Creative': return l10n.personalityCreative;
      case 'Witty': return l10n.personalityWitty;
      case 'Empathetic': return l10n.personalityEmpathetic;

      // Relationship
      case 'Romantic partner': return l10n.relationshipRomantic;
      case 'Dating': return l10n.relationshipDating;
      case 'Longtime friend': return l10n.relationshipFriend;
      case 'Listener / advisor': return l10n.relationshipAdvisor;
      case 'Ideal type': return l10n.relationshipIdeal;
      case 'Mentor / senior': return l10n.relationshipMentor;
      case 'Secret companion': return l10n.relationshipSecret;

      default: return key;
    }
  }

  Widget _buildTag(String text) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ConstantColor.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: FontSize.bodySmall,
          color: ConstantColor.primaryColor,
        ),
      ),
    );
  }
}
