import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class AIPersonalityStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const AIPersonalityStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<AIPersonalityStep> createState() => _AIPersonalityStepState();
}

class _AIPersonalityStepState extends State<AIPersonalityStep> {
  String? selectedPersonality;

  @override
  void initState() {
    super.initState();
    selectedPersonality = widget.initialValue;
  }

  final List<Map<String, dynamic>> _personalityOptions = [
    {
      'value': 'Friendly',
      'icon': Icons.sentiment_very_satisfied,
      'description': 'Warm and approachable with a positive attitude',
    },
    {
      'value': 'Professional',
      'icon': Icons.business,
      'description': 'Polite and formal with a business-like demeanor',
    },
    {
      'value': 'Creative',
      'icon': Icons.brush,
      'description': 'Imaginative and artistic with unique perspectives',
    },
    {
      'value': 'Witty',
      'icon': Icons.emoji_emotions,
      'description': 'Humorous and clever with quick responses',
    },
    {
      'value': 'Empathetic',
      'icon': Icons.favorite,
      'description': 'Understanding and supportive with emotional intelligence',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final isLargeScreen = size.width >= 1200;

    // Responsive font sizes
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

    // Responsive spacing
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
      canProceed: selectedPersonality != null,
      child: SingleChildScrollView(
  padding: EdgeInsets.only(bottom: BoxSize.spacingXL),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.choosePersonality,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: verticalSpacing),
          Text(
            l10n.selectPersonalityDescription,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: verticalSpacing * 2),
          Wrap(
            spacing: cardSpacing,
            runSpacing: cardSpacing,
            children: _personalityOptions.map((option) {
              final isSelected = selectedPersonality == option['value'];

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isSmallScreen ? double.infinity : (size.width - cardSpacing * 2) / 2,
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
                        selectedPersonality = option['value'];
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
                                  _getLocalizedPersonalityLabel(option['value'], l10n),
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
                                  _getLocalizedPersonalityDescription(option['value'], l10n),
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
      ),)
    );
  }

  String _getLocalizedPersonalityLabel(String personality, AppLocalizations l10n) {
    switch (personality) {
      case 'Friendly':
        return l10n.personalityFriendly;
      case 'Professional':
        return l10n.personalityProfessional;
      case 'Creative':
        return l10n.personalityCreative;
      case 'Witty':
        return l10n.personalityWitty;
      case 'Empathetic':
        return l10n.personalityEmpathetic;
      default:
        return personality;
    }
  }

  String _getLocalizedPersonalityDescription(String personality, AppLocalizations l10n) {
    switch (personality) {
      case 'Friendly':
        return l10n.personalityFriendlyDescription;
      case 'Professional':
        return l10n.personalityProfessionalDescription;
      case 'Creative':
        return l10n.personalityCreativeDescription;
      case 'Witty':
        return l10n.personalityWittyDescription;
      case 'Empathetic':
        return l10n.personalityEmpatheticDescription;
      default:
        return personality;
    }
  }
} 