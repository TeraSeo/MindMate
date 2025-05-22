import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class GenderStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const GenderStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  String _getLocalizedGenderLabel(String gender, AppLocalizations l10n) {
    switch (gender) {
      case 'Male':
        return l10n.male;
      case 'Female':
        return l10n.female;
      case 'Unspecified':
        return 'Unspecified (gender-neutral)';
      default:
        return gender;
    }
  }

  final List<Map<String, dynamic>> _genderOptions = [
    {
      'value': 'Male',
      'icon': Icons.male,
      'description': 'Uses masculine pronouns and communication style.',
    },
    {
      'value': 'Female',
      'icon': Icons.female,
      'description': 'Uses feminine pronouns and communication style.',
    },
    {
      'value': 'Unspecified',
      'icon': Icons.person,
      'description': 'Uses gender-neutral pronouns and balanced communication style.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final titleFontSize = isSmallScreen ? FontSize.h5 : FontSize.h4;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyMedium : FontSize.bodyLarge;
    final optionFontSize = isSmallScreen ? FontSize.bodyMedium : FontSize.bodyLarge;
    final cardPadding = isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL;
    final iconSize = isSmallScreen ? BoxSize.iconMedium : BoxSize.iconLarge;

    return BaseStep(
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      canProceed: selectedGender != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose AI Gender',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            'Select the gender that best matches your preferences.',
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: _genderOptions.length,
              separatorBuilder: (context, index) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = _genderOptions[index];
                final isSelected = selectedGender == option['value'];

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getLocalizedGenderLabel(option['value'], l10n),
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
                                  option['description'],
                                  style: TextStyle(
                                    fontSize: FontSize.bodySmall,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
} 