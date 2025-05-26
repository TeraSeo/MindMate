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
        return l10n.genderMale;
      case 'Female':
        return l10n.genderFemale;
      case 'Unspecified':
        return l10n.genderUnspecified;
      default:
        return gender;
    }
  }

  String _getLocalizedGenderDescription(String gender, AppLocalizations l10n) {
    switch (gender) {
      case 'Male':
        return l10n.genderMaleDescription;
      case 'Female':
        return l10n.genderFemaleDescription;
      case 'Unspecified':
        return l10n.genderUnspecifiedDescription;
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

    return BaseStep(
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      canProceed: selectedGender != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chooseGender,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: verticalSpacing),
          Text(
            l10n.selectGenderDescription,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: verticalSpacing * 2),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isSmallScreen 
                    ? 1 
                    : isMediumScreen 
                        ? 2 
                        : 3;

                final cardSpacing = isSmallScreen 
                    ? BoxSize.spacingM 
                    : isMediumScreen 
                        ? BoxSize.spacingL 
                        : BoxSize.spacingXL;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: isSmallScreen ? 3 : 2.5,
                    crossAxisSpacing: cardSpacing,
                    mainAxisSpacing: cardSpacing,
                  ),
                  itemCount: _genderOptions.length,
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
                              SizedBox(width: cardPadding),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      _getLocalizedGenderDescription(option['value'], l10n),
                                      style: TextStyle(
                                        fontSize: optionFontSize * 0.9,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 