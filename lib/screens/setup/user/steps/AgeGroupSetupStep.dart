import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class AgeGroupSetupStep extends StatefulWidget {
  final Function(String) onAgeGroupChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final String? initialValue;

  const AgeGroupSetupStep({
    super.key,
    required this.onAgeGroupChanged,
    required this.onNext,
    required this.onPrevious,
    this.initialValue,
  });

  @override
  State<AgeGroupSetupStep> createState() => _AgeGroupSetupStepState();
}

class _AgeGroupSetupStepState extends State<AgeGroupSetupStep> {
  String? selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    selectedAgeGroup = widget.initialValue;
  }

  List<Map<String, dynamic>> _getAgeGroupOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'value': l10n.ageGroupUnder18,
        'icon': Icons.child_care,
        'description': l10n.ageGroupUnder18Description,
      },
      {
        'value': l10n.ageGroup18to24,
        'icon': Icons.school,
        'description': l10n.ageGroup18to24Description,
      },
      {
        'value': l10n.ageGroup25to34,
        'icon': Icons.work,
        'description': l10n.ageGroup25to34Description,
      },
      {
        'value': l10n.ageGroup35to44,
        'icon': Icons.person,
        'description': l10n.ageGroup35to44Description,
      },
      {
        'value': l10n.ageGroup45to54,
        'icon': Icons.person_outline,
        'description': l10n.ageGroup45to54Description,
      },
      {
        'value': l10n.ageGroup55Plus,
        'icon': Icons.elderly,
        'description': l10n.ageGroup55PlusDescription,
      },
    ];
  }

  void _handleAgeGroupSelection(String value) {
    setState(() {
      selectedAgeGroup = value;
    });
    widget.onAgeGroupChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final titleFontSize = isSmallScreen ? FontSize.h2 : FontSize.h1;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h5;
    final optionFontSize = isSmallScreen ? FontSize.bodyMedium : FontSize.bodyLarge;
    final cardPadding = isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL;
    final iconSize = isSmallScreen ? BoxSize.iconMedium : BoxSize.iconLarge;

    final ageGroupOptions = _getAgeGroupOptions(context);

    return BaseStep(
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      canProceed: selectedAgeGroup != "" && selectedAgeGroup != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ageGroupStepTitle,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            l10n.ageGroupStepDescription,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: ageGroupOptions.length,
              separatorBuilder: (_, __) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = ageGroupOptions[index];
                final isSelected = option['value'] == selectedAgeGroup;
                
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
                    onTap: () => _handleAgeGroupSelection(option['value']),
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
                                SizedBox(height: BoxSize.spacingXS),
                                Text(
                                  option['description'],
                                  style: TextStyle(
                                    fontSize: optionFontSize * 0.9,
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