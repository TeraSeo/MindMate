import 'package:ai_chatter/screens/ChatPage.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/services/CharacterService.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatCharacterBox extends StatefulWidget {
  final Map<String, dynamic> character;
  final String userId;

  const ChatCharacterBox({
    super.key, 
    required this.character,
    required this.userId,
  });

  @override
  State<ChatCharacterBox> createState() => _ChatCharacterBoxState();
}

class _ChatCharacterBoxState extends State<ChatCharacterBox> {
  final GlobalKey _containerKey = GlobalKey();
  double _dragOffset = 0;
  bool _isDeleteVisible = false;

  void deleteCharacter() async {
    try {
      await CharacterService().deleteCharacter(widget.userId, widget.character['characterId']);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete character: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.character['name'] ?? 'Unnamed';
    final personality = widget.character['personality'] ?? '';
    final relationship = widget.character['relationship'] ?? '';
    final chattingStyle = widget.character['chattingStyle'] ?? '';
    final gender = widget.character['gender'] ?? '';
    final ageGroup = widget.character['ageGroup'] ?? '';

    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          // Allow both left and right swipes
          _dragOffset = (_dragOffset + details.delta.dx).clamp(-80, 0);
          _isDeleteVisible = _dragOffset < -20;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset < -40) {
          setState(() {
            _dragOffset = -80;
            _isDeleteVisible = true;
          });
        } else {
          setState(() {
            _dragOffset = 0;
            _isDeleteVisible = false;
          });
        }
      },
      child: Stack(
        children: [
          // Delete button
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _isDeleteVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Character'),
                        content: Text('Are you sure you want to delete $name?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteCharacter();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Main content
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(character: widget.character),
                  ),
                );
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
                  border: _isDeleteVisible 
                    ? Border(
                        right: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      )
                    : null,
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
            ),
          ),
        ],
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
