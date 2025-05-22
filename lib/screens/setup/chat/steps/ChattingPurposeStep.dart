import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class ChattingPurposeStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const ChattingPurposeStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<ChattingPurposeStep> createState() => _ChattingPurposeStepState();
}

class _ChattingPurposeStepState extends State<ChattingPurposeStep> {
  String? selectedPurpose;

  @override
  void initState() {
    super.initState();
    selectedPurpose = widget.initialValue;
  }

  final List<Map<String, dynamic>> _purposeOptions = [
    {
      'value': 'Social',
      'icon': Icons.people,
      'description': 'Casual conversations and social interaction for companionship.',
    },
    {
      'value': 'Learning',
      'icon': Icons.school,
      'description': 'Educational discussions and knowledge sharing.',
    },
    {
      'value': 'Professional',
      'icon': Icons.work,
      'description': 'Career development and professional networking.',
    },
    {
      'value': 'Creative',
      'icon': Icons.brush,
      'description': 'Artistic expression and creative collaboration.',
    },
    {
      'value': 'Therapeutic',
      'icon': Icons.psychology,
      'description': 'Emotional support and mental well-being.',
    },
    {
      'value': 'Entertainment',
      'icon': Icons.sports_esports,
      'description': 'Fun and engaging conversations for enjoyment.',
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
      canProceed: selectedPurpose != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Chatting Purpose',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            'Select the primary purpose for your conversations with the AI chat partner.',
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: _purposeOptions.length,
              separatorBuilder: (context, index) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = _purposeOptions[index];
                final isSelected = selectedPurpose == option['value'];

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
                        selectedPurpose = option['value'];
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