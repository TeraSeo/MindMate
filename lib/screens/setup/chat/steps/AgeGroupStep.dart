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
      canProceed: selectedAgeGroup != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chooseAgeGroup,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: verticalSpacing),
          Text(
            l10n.selectAgeGroupDescription,
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
                  itemCount: _ageGroupOptions.length,
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
                              SizedBox(width: cardPadding),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _getLocalizedAgeGroupLabel(option['value'], l10n),
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
                                      _getLocalizedAgeGroupDescription(option['value'], l10n),
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

  String _getLocalizedAgeGroupLabel(String ageGroup, AppLocalizations l10n) {
    switch (ageGroup) {
      case 'Child (5-12)':
        return l10n.ageGroupChild;
      case 'Teen (13-19)':
        return l10n.ageGroupTeen;
      case 'Young Adult (20-29)':
        return l10n.ageGroupYoungAdult;
      case 'Adult (30-49)':
        return l10n.ageGroupAdult;
      case 'Senior (50+)':
        return l10n.ageGroupSenior;
      default:
        return ageGroup;
    }
  }

  String _getLocalizedAgeGroupDescription(String ageGroup, AppLocalizations l10n) {
    switch (ageGroup) {
      case 'Child (5-12)':
        return l10n.ageGroupChildDescription;
      case 'Teen (13-19)':
        return l10n.ageGroupTeenDescription;
      case 'Young Adult (20-29)':
        return l10n.ageGroupYoungAdultDescription;
      case 'Adult (30-49)':
        return l10n.ageGroupAdultDescription;
      case 'Senior (50+)':
        return l10n.ageGroupSeniorDescription;
      default:
        return ageGroup;
    }
  }
} 