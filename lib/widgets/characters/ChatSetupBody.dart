import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class ChatSetupBody extends StatelessWidget {
  final int currentStep;
  final double maxWidth;
  final double horizontalPadding;
  final Widget Function() buildStep;

  const ChatSetupBody({
    super.key,
    required this.currentStep,
    required this.maxWidth,
    required this.horizontalPadding,
    required this.buildStep,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: BoxSize.pagePadding,
          ),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentStep + 1) / 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL),
              Expanded(child: buildStep()),
            ],
          ),
        ),
      ),
    );
  }
}