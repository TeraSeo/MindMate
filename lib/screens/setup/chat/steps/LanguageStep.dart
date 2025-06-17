import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class LanguageStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const LanguageStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<LanguageStep> createState() => _LanguageStepState();
}

class _LanguageStepState extends State<LanguageStep> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.initialValue;
  }

  final List<Map<String, dynamic>> _languageOptions = [
    {
      'value': 'English',
      'icon': Icons.language,
      'description': 'Communicate in English with natural fluency.',
    },
    {
      'value': 'Spanish',
      'icon': Icons.language,
      'description': 'Communicate in Spanish with cultural understanding.',
    },
    {
      'value': 'French',
      'icon': Icons.language,
      'description': 'Communicate in French with proper nuances.',
    },
    {
      'value': 'German',
      'icon': Icons.language,
      'description': 'Communicate in German with grammatical accuracy.',
    },
    {
      'value': 'Japanese',
      'icon': Icons.language,
      'description': 'Communicate in Japanese with cultural context.',
    },
    {
      'value': 'Korean',
      'icon': Icons.language,
      'description': 'Communicate in Korean with proper honorifics.',
    },
    {
      'value': 'Chinese',
      'icon': Icons.language,
      'description': 'Communicate in Chinese with cultural sensitivity.',
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
      canProceed: selectedLanguage != null,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: BoxSize.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chooseLanguage,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              l10n.selectLanguageDescription,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Wrap(
              spacing: cardSpacing,
              runSpacing: cardSpacing,
              children: _languageOptions.map((option) {
                final isSelected = selectedLanguage == option['value'];

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
                          selectedLanguage = option['value'];
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
                                    _getLocalizedLanguageLabel(option['value'], l10n),
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
                                    _getLocalizedLanguageDescription(option['value'], l10n),
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

  String _getLocalizedLanguageLabel(String language, AppLocalizations l10n) {
    switch (language) {
      case 'English':
        return l10n.languageEnglish;
      case 'Spanish':
        return l10n.languageSpanish;
      case 'French':
        return l10n.languageFrench;
      case 'German':
        return l10n.languageGerman;
      case 'Japanese':
        return l10n.languageJapanese;
      case 'Korean':
        return l10n.languageKorean;
      case 'Chinese':
        return l10n.languageChinese;
      default:
        return language;
    }
  }

  String _getLocalizedLanguageDescription(String language, AppLocalizations l10n) {
    switch (language) {
      case 'English':
        return l10n.languageEnglishDescription;
      case 'Spanish':
        return l10n.languageSpanishDescription;
      case 'French':
        return l10n.languageFrenchDescription;
      case 'German':
        return l10n.languageGermanDescription;
      case 'Japanese':
        return l10n.languageJapaneseDescription;
      case 'Korean':
        return l10n.languageKoreanDescription;
      case 'Chinese':
        return l10n.languageChineseDescription;
      default:
        return language;
    }
  }
} 