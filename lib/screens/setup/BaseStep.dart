import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';

class BaseStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool canProceed;
  final Widget child;
  final bool isLastStep;

  const BaseStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.canProceed,
    required this.child,
    this.isLastStep = false,
  });

  @override
  State<BaseStep> createState() => _BaseStepState();
}

class _BaseStepState extends State<BaseStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final buttonFontSize = isSmallScreen ? FontSize.buttonMedium : FontSize.buttonLarge;

    return Column(
      children: [
        Expanded(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: widget.child,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? BoxSize.spacingL : BoxSize.spacingXL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onPrevious,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? BoxSize.spacingL : BoxSize.spacingXL,
                  vertical: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
                ),
              ),
              child: Text(
                l10n.back,
                style: TextStyle(
                  fontSize: buttonFontSize,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: widget.canProceed ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? BoxSize.spacingL : BoxSize.spacingXL,
                  vertical: isSmallScreen ? BoxSize.spacingM : BoxSize.spacingL,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.isLastStep ? l10n.completeSetup : l10n.next,
                style: TextStyle( 
                  fontSize: buttonFontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 