import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class AgeGroupStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const AgeGroupStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<AgeGroupStep> createState() => _AgeGroupStepState();
}

class _AgeGroupStepState extends State<AgeGroupStep> {
  String? selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    selectedAgeGroup = widget.initialValue;
  }

  final List<Map<String, dynamic>> _ageGroupOptions = [
    {
      'value': 'Child (5-12)',
      'icon': Icons.child_care,
      'description': 'Simple language, playful tone, and age-appropriate topics.',
    },
    {
      'value': 'Teen (13-19)',
      'icon': Icons.school,
      'description': 'Relatable content, casual style, and youth-focused topics.',
    },
    {
      'value': 'Young Adult (20-29)',
      'icon': Icons.person_outline,
      'description': 'Balanced communication style for young professionals.',
    },
    {
      'value': 'Adult (30-49)',
      'icon': Icons.person,
      'description': 'Mature conversation style with professional insights.',
    },
    {
      'value': 'Senior (50+)',
      'icon': Icons.elderly,
      'description': 'Clear communication with respect for experience.',
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
      canProceed: selectedAgeGroup != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose AI Age Group',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            'Select the age group that best matches your preferences.',
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: _ageGroupOptions.length,
              separatorBuilder: (context, index) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = _ageGroupOptions[index];
                final isSelected = selectedAgeGroup == option['value'];

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
                        selectedAgeGroup = option['value'];
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
                                  option['value'],
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