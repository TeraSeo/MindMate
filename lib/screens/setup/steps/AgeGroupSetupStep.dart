import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class AgeGroupSetupStep extends StatefulWidget {
  final Function(String) onAgeGroupChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String? initialValue;

  const AgeGroupSetupStep({
    super.key,
    required this.onAgeGroupChanged,
    required this.onNext,
    required this.onBack,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ageGroups = ['18-24', '25-34', '35-44', '45-54', '55+'];
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final titleFontSize = isSmallScreen ? FontSize.h2 : FontSize.h1;
    final descriptionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h5;
    final optionFontSize = isSmallScreen ? FontSize.bodyLarge : FontSize.h6;
    final buttonFontSize = isSmallScreen ? FontSize.buttonMedium : FontSize.buttonLarge;
    final cardPadding = isSmallScreen ? BoxSize.cardPadding : BoxSize.cardPadding * 1.5;

    return Column(
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
            itemCount: ageGroups.length,
            separatorBuilder: (_, __) => SizedBox(
              height: isSmallScreen ? BoxSize.spacingS : BoxSize.spacingM,
            ),
            itemBuilder: (context, index) {
              final ageGroup = ageGroups[index];
              final isSelected = selectedAgeGroup == ageGroup;
              
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                  side: BorderSide(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedAgeGroup = ageGroup;
                    });
                    widget.onAgeGroupChanged(ageGroup);
                  },
                  borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ageGroup,
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
                            size: isSmallScreen ? BoxSize.iconMedium : BoxSize.iconLarge,
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
              onPressed: widget.onBack,
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
              onPressed: selectedAgeGroup != null ? widget.onNext : null,
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