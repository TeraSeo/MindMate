import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class BaseStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool canProceed;
  final Widget child;

  const BaseStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.canProceed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final buttonFontSize = isSmallScreen ? FontSize.buttonMedium : FontSize.buttonLarge;

    return Column(
      children: [
        Expanded(child: child),
        SizedBox(height: isSmallScreen ? BoxSize.spacingXL : BoxSize.spacingXXL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onPrevious,
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
              onPressed: onNext,
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