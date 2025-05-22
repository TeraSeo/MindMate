import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class GenderSetupStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const GenderSetupStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<GenderSetupStep> createState() => _GenderSetupStepState();
}

class _GenderSetupStepState extends State<GenderSetupStep> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  static const List<Map<String, dynamic>> _genderOptions = [
    {
      'value': 'Male',
      'icon': Icons.male,
    },
    {
      'value': 'Female',
      'icon': Icons.female,
    },
    {
      'value': 'Non-binary',
      'icon': Icons.person,
    },
    {
      'value': 'Prefer not to say',
      'icon': Icons.person_outline,
    },
  ];

  String _getLocalizedGenderLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Male':
        return l10n.male;
      case 'Female':
        return l10n.female;
      case 'Non-binary':
        return l10n.nonBinary;
      case 'Prefer not to say':
        return l10n.preferNotToSay;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final titleFontSize = isSmallScreen ? FontSize.h2 : FontSize.h1;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h5;
    final optionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h6;
    final buttonFontSize = isSmallScreen ? FontSize.buttonMedium : FontSize.buttonLarge;
    final cardPadding = isSmallScreen ? BoxSize.cardPadding : BoxSize.cardPadding * 1.5;
    final iconSize = isSmallScreen ? BoxSize.iconMedium : BoxSize.iconLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.genderStepTitle,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
        Text(
          l10n.genderStepDescription,
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
        Expanded(
          child: ListView.separated(
            itemCount: _genderOptions.length,
            separatorBuilder: (_, __) => SizedBox(
              height: isSmallScreen ? BoxSize.spacingS : BoxSize.spacingM,
            ),
            itemBuilder: (context, index) {
              final option = _genderOptions[index];
              final isSelected = option['value'] == selectedGender;
              
              return Card(
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
                      selectedGender = option['value'];
                    });
                    widget.onUpdateData(option['value']);
                  },
                  borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'],
                          size: iconSize,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                        ),
                        SizedBox(width: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
                        Expanded(
                          child: Text(
                            _getLocalizedGenderLabel(option['value'], l10n),
                            style: TextStyle(
                              fontSize: optionFontSize,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: iconSize,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onPrevious,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? BoxSize.buttonPadding : BoxSize.buttonPadding * 1.5,
                  vertical: isSmallScreen ? BoxSize.buttonPadding : BoxSize.buttonPadding * 1.2,
                ),
              ),
              child: Text(
                l10n.back,
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),
            ElevatedButton(
              onPressed: selectedGender != null ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? BoxSize.buttonPadding * 2 : BoxSize.buttonPadding * 3,
                  vertical: isSmallScreen ? BoxSize.buttonPadding : BoxSize.buttonPadding * 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                ),
              ),
              child: Text(
                l10n.next,
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 