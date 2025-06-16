import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this
import 'package:ai_chatter/models/SubscriptionPlan.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: BoxSize.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BoxSize.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BoxSize.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Name and Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getLocalizedPlanName(loc),
                  style: TextStyle(
                    fontSize: FontSize.h5,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.primaryColor,
                  ),
                ),
                if (plan.discount != '–')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BoxSize.spacingS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ConstantColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                    ),
                    child: Text(
                      '${plan.discount} ${loc.off}',
                      style: TextStyle(
                        color: ConstantColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.bodySmall,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: BoxSize.spacingM),

            // Price + Period
            Text(
              '\$${plan.price.toStringAsFixed(2)} / ${_getLocalizedPeriod(loc)}',
              style: TextStyle(
                fontSize: FontSize.h4,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            // Monthly price
            if (plan.monthlyPrice != plan.price) ...[
              const SizedBox(height: 4),
              Text(
                '~ \$${plan.monthlyPrice.toStringAsFixed(2)}/${loc.month}',
                style: TextStyle(
                  fontSize: FontSize.bodyMedium,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const SizedBox(height: BoxSize.spacingS),

            // Description
            Text(
              _getLocalizedPlanDescription(loc),
              style: TextStyle(
                fontSize: FontSize.bodyMedium,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: BoxSize.spacingL),

            // Upgrade Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement subscription purchase
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColor.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: BoxSize.spacingS,
                        horizontal: BoxSize.spacingL,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      loc.upgradeNow,
                      style: TextStyle(
                        fontSize: FontSize.bodyMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedPlanName(AppLocalizations loc) {
    switch (plan.name) {
      case 'Basic Plan':
        return loc.basicPlanName;
      case 'Standard Plan':
        return loc.standardPlanName;
      case 'Premium Plan':
        return loc.premiumPlanName;
      default:
        return plan.name;
    }
  }

  String _getLocalizedPlanDescription(AppLocalizations loc) {
    switch (plan.name) {
      case 'Basic Plan':
        return loc.basicPlanDescription;
      case 'Standard Plan':
        return loc.standardPlanDescription;
      case 'Premium Plan':
        return loc.premiumPlanDescription;
      default:
        return plan.description;
    }
  }

  String _getLocalizedPeriod(AppLocalizations loc) {
    switch (plan.period) {
      case '1 month':
        return loc.period1Month;
      case '3 months':
        return loc.period3Months;
      case '1 year':
        return loc.period1Year;
      default:
        return plan.period;
    }
  }
}