import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionCard extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onUpgrade;

  const SubscriptionCard({
    super.key,
    required this.isPremium,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BoxSize.cardRadius),
        side: BorderSide(
          color: isPremium ? Colors.amber : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(BoxSize.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPremium ? Icons.star : Icons.star_border,
                  color: isPremium ? Colors.amber : Colors.grey,
                  size: BoxSize.iconLarge,
                ),
                SizedBox(width: BoxSize.spacingM),
                Text(
                  l10n.subscription,
                  style: TextStyle(
                    fontSize: FontSize.h5,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: BoxSize.spacingM),
            Text(
              isPremium ? l10n.premiumPlan : l10n.freePlan,
              style: TextStyle(
                fontSize: FontSize.h6,
                color: isPremium ? Colors.amber : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: BoxSize.spacingS),
            Text(
              isPremium ? l10n.premiumDescription : l10n.freeDescription,
              style: TextStyle(
                fontSize: FontSize.bodyMedium,
                color: ConstantColor.textColor.withOpacity(0.7),
              ),
            ),
            if (!isPremium) ...[
              SizedBox(height: BoxSize.spacingM),
              SizedBox(
                width: double.infinity,
                height: BoxSize.buttonHeight,
                child: ElevatedButton(
                  onPressed: onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                    ),
                  ),
                  child: Text(
                    l10n.upgradeButton,
                    style: TextStyle(fontSize: FontSize.buttonMedium),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}