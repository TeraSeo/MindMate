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
      'value': 'Warm and caring',
      'icon': Icons.favorite,
      'description': 'A nurturing and empathetic personality that shows genuine care and concern.',
    },
    {
      'value': 'Cold and blunt',
      'icon': Icons.ac_unit,
      'description': 'A direct and straightforward personality that values honesty over tact.',
    },
    {
      'value': 'Playful and teasing',
      'icon': Icons.sentiment_very_satisfied,
      'description': 'A fun-loving personality that enjoys light-hearted banter and jokes.',
    },
    {
      'value': 'Logical and rational',
      'icon': Icons.psychology,
      'description': 'An analytical personality that focuses on facts and clear reasoning.',
    },
    {
      'value': 'Emotional and sensitive',
      'icon': Icons.mood,
      'description': 'A deeply empathetic personality that connects on an emotional level.',
    },
    {
      'value': 'Tsundere',
      'icon': Icons.volunteer_activism,
      'description': 'A tough exterior with a caring heart, showing affection indirectly.',
    },
    {
      'value': 'Quiet and serious',
      'icon': Icons.volume_off,
      'description': 'A reserved personality that communicates thoughtfully and deliberately.',
    },
    {
      'value': 'Encouraging and supportive',
      'icon': Icons.thumb_up,
      'description': 'A positive personality that motivates and uplifts others.',
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
      canProceed: selectedPersonality != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose AI Personality',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            'Select the personality type that best matches your preferences.',
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: _personalityOptions.length,
              separatorBuilder: (context, index) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = _personalityOptions[index];
                final isSelected = selectedPersonality == option['value'];

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
                        selectedPersonality = option['value'];
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