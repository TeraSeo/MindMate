import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/screens/setup/BaseStep.dart';

class ChattingStyleStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdateData;
  final String initialValue;

  const ChattingStyleStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdateData,
    required this.initialValue,
  });

  @override
  State<ChattingStyleStep> createState() => _ChattingStyleStepState();
}

class _ChattingStyleStepState extends State<ChattingStyleStep> {
  String? selectedStyle;

  @override
  void initState() {
    super.initState();
    selectedStyle = widget.initialValue;
  }

  final List<Map<String, dynamic>> _styleOptions = [
    {
      'value': 'Casual',
      'icon': Icons.chat_bubble_outline,
      'description': 'Relaxed and informal conversations with everyday language.',
    },
    {
      'value': 'Formal',
      'icon': Icons.business,
      'description': 'Professional and structured communication with proper etiquette.',
    },
    {
      'value': 'Creative',
      'icon': Icons.brush,
      'description': 'Expressive and imaginative discussions with artistic flair.',
    },
    {
      'value': 'Academic',
      'icon': Icons.school,
      'description': 'Intellectual and research-oriented conversations.',
    },
    {
      'value': 'Technical',
      'icon': Icons.code,
      'description': 'Precise and detailed discussions with technical terminology.',
    },
    {
      'value': 'Poetic',
      'icon': Icons.format_quote,
      'description': 'Elegant and metaphorical language with literary elements.',
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
      canProceed: selectedStyle != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Chatting Style',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
          Text(
            'Select the communication style that best suits your preferences.',
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
          Expanded(
            child: ListView.separated(
              itemCount: _styleOptions.length,
              separatorBuilder: (context, index) => SizedBox(
                height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
              ),
              itemBuilder: (context, index) {
                final option = _styleOptions[index];
                final isSelected = selectedStyle == option['value'];

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
                        selectedStyle = option['value'];
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