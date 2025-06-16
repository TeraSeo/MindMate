import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingBubble extends StatelessWidget {
  final Animation<double> animation;

  const LoadingBubble({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ConstantColor.primaryColor.withOpacity(0.1),
            child: Text(
              'AI',
              style: TextStyle(
                fontSize: FontSize.bodySmall,
                color: ConstantColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BoxSize.spacingM,
              vertical: BoxSize.spacingS,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(BoxSize.cardRadius),
                topRight: Radius.circular(BoxSize.cardRadius),
                bottomRight: Radius.circular(BoxSize.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.typing,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: FontSize.bodyMedium,
                  ),
                ),
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final dots = (3 * animation.value).floor();
                    return Text(
                      '.' * dots,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: FontSize.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}