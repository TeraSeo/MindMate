import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class RelationshipStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const RelationshipStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<RelationshipStep> createState() => _RelationshipStepState();
}

class _RelationshipStepState extends State<RelationshipStep> {
  String? selectedRelationship;

  @override
  void initState() {
    super.initState();
    selectedRelationship = widget.initialValue;
  }

  final List<Map<String, dynamic>> _relationshipOptions = [
    {
      'value': 'Romantic partner',
      'icon': Icons.favorite,
      'description': 'A loving and intimate relationship with deep emotional connection',
    },
    {
      'value': 'Dating',
      'icon': Icons.favorite_border,
      'description': 'Someone you\'re dating but not in an official relationship yet',
    },
    {
      'value': 'Longtime friend',
      'icon': Icons.people,
      'description': 'A close, trusted friend with years of shared experiences',
    },
    {
      'value': 'Listener / advisor',
      'icon': Icons.hearing,
      'description': 'Someone who listens attentively and provides thoughtful advice',
    },
    {
      'value': 'Ideal type',
      'icon': Icons.star,
      'description': 'Your perfect match with qualities you admire and desire',
    },
    {
      'value': 'Mentor / senior',
      'icon': Icons.school,
      'description': 'A wise guide who helps you grow and develop',
    },
    {
      'value': 'Secret companion',
      'icon': Icons.visibility_off,
      'description': 'A private confidant for your most personal thoughts',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;

    final titleFontSize = isSmallScreen
        ? FontSize.h5
        : isMediumScreen
            ? FontSize.h4
            : FontSize.h3;

    final descriptionFontSize = isSmallScreen
        ? FontSize.bodyMedium
        : isMediumScreen
            ? FontSize.bodyLarge
            : FontSize.h6;

    final optionFontSize = isSmallScreen
        ? FontSize.bodyMedium
        : isMediumScreen
            ? FontSize.bodyLarge
            : FontSize.h6;

    final verticalSpacing = isSmallScreen
        ? BoxSize.spacingM
        : isMediumScreen
            ? BoxSize.spacingL
            : BoxSize.spacingXL;

    final cardPadding = isSmallScreen
        ? BoxSize.spacingM
        : isMediumScreen
            ? BoxSize.spacingL
            : BoxSize.spacingXL;

    final iconSize = isSmallScreen
        ? BoxSize.iconMedium
        : isMediumScreen
            ? BoxSize.iconLarge
            : BoxSize.iconLarge * 1.2;

    final cardSpacing = isSmallScreen
        ? BoxSize.spacingM
        : isMediumScreen
            ? BoxSize.spacingL
            : BoxSize.spacingXL;

    return BaseStep(
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      canProceed: selectedRelationship != null,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: BoxSize.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.setRelationshipRole,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              l10n.setRelationshipDescription,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Wrap(
              spacing: cardSpacing,
              runSpacing: cardSpacing,
              children: _relationshipOptions.map((option) {
                final isSelected = selectedRelationship == option['value'];

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen
                        ? double.infinity
                        : (size.width - cardSpacing * 2) / 2,
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedRelationship = option['value'];
                        });
                        widget.onUpdateData(option['value']);
                      },
                      borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                      child: Padding(
                        padding: EdgeInsets.all(cardPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              option['icon'],
                              size: iconSize,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[600],
                            ),
                            SizedBox(width: cardPadding),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getLocalizedRelationshipLabel(option['value'], l10n),
                                    style: TextStyle(
                                      fontSize: optionFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: BoxSize.spacingS),
                                  Text(
                                    _getLocalizedRelationshipDescription(option['value'], l10n),
                                    style: TextStyle(
                                      fontSize: optionFontSize * 0.9,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  size: iconSize,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedRelationshipLabel(String relationship, AppLocalizations l10n) {
    switch (relationship) {
      case 'Romantic partner':
        return l10n.relationshipRomantic;
      case 'Dating':
        return l10n.relationshipDating;
      case 'Longtime friend':
        return l10n.relationshipFriend;
      case 'Listener / advisor':
        return l10n.relationshipAdvisor;
      case 'Ideal type':
        return l10n.relationshipIdeal;
      case 'Mentor / senior':
        return l10n.relationshipMentor;
      case 'Secret companion':
        return l10n.relationshipSecret;
      default:
        return relationship;
    }
  }

  String _getLocalizedRelationshipDescription(String relationship, AppLocalizations l10n) {
    switch (relationship) {
      case 'Romantic partner':
        return l10n.relationshipRomanticDescription;
      case 'Dating':
        return l10n.relationshipDatingDescription;
      case 'Longtime friend':
        return l10n.relationshipFriendDescription;
      case 'Listener / advisor':
        return l10n.relationshipAdvisorDescription;
      case 'Ideal type':
        return l10n.relationshipIdealDescription;
      case 'Mentor / senior':
        return l10n.relationshipMentorDescription;
      case 'Secret companion':
        return l10n.relationshipSecretDescription;
      default:
        return relationship;
    }
  }
} 