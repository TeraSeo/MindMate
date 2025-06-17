import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class ChattingStyleStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const ChattingStyleStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<ChattingStyleStep> createState() => _ChattingStyleStepState();
}

class _ChattingStyleStepState extends State<ChattingStyleStep> {
  String? selectedStyle;

  @override
  void initState() {
    super.initState();
    selectedStyle = widget.initialValue;
  }

  final List<Map<String, dynamic>> _styleOptions = [
    {
      'value': 'Formal speech',
      'icon': Icons.business,
      'description': 'Professional and respectful communication with proper etiquette',
    },
    {
      'value': 'Casual speech',
      'icon': Icons.sentiment_satisfied,
      'description': 'Relaxed and friendly conversations with everyday language',
    },
    {
      'value': 'Mixed speech',
      'icon': Icons.swap_horiz,
      'description': 'Balanced mix of formal and casual communication styles',
    },
    {
      'value': 'Short and direct',
      'icon': Icons.format_align_left,
      'description': 'Concise and straightforward messages with clear points',
    },
    {
      'value': 'Long and expressive',
      'icon': Icons.format_align_justify,
      'description': 'Detailed and elaborate messages with rich descriptions',
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
      canProceed: selectedStyle != null,
      isLastStep: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: BoxSize.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chooseChattingStyle,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              l10n.selectChattingStyleDescription,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Wrap(
              spacing: cardSpacing,
              runSpacing: cardSpacing,
              children: _styleOptions.map((option) {
                final isSelected = selectedStyle == option['value'];

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
                          selectedStyle = option['value'];
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
                                    _getLocalizedStyleLabel(option['value'], l10n),
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
                                    _getLocalizedStyleDescription(option['value'], l10n),
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

  String _getLocalizedStyleLabel(String style, AppLocalizations l10n) {
    switch (style) {
      case 'Formal speech':
        return l10n.styleFormal;
      case 'Casual speech':
        return l10n.styleCasual;
      case 'Mixed speech':
        return l10n.styleMixed;
      case 'Short and direct':
        return l10n.styleShort;
      case 'Long and expressive':
        return l10n.styleLong;
      default:
        return style;
    }
  }

  String _getLocalizedStyleDescription(String style, AppLocalizations l10n) {
    switch (style) {
      case 'Formal speech':
        return l10n.styleFormalDescription;
      case 'Casual speech':
        return l10n.styleCasualDescription;
      case 'Mixed speech':
        return l10n.styleMixedDescription;
      case 'Short and direct':
        return l10n.styleShortDescription;
      case 'Long and expressive':
        return l10n.styleLongDescription;
      default:
        return style;
    }
  }
} 