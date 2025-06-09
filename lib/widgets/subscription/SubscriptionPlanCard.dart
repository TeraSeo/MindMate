import 'package:flutter/material.dart';
import 'package:ai_chatter/models/SubscriptionPlan.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
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
                      '${plan.discount} OFF',
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
            Text(
              '\$${plan.price.toStringAsFixed(2)} / ${plan.period}',
              style: TextStyle(
                fontSize: FontSize.h4,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            if (plan.monthlyPrice != plan.price) ...[
              const SizedBox(height: 4),
              Text(
                '~ \$${plan.monthlyPrice.toStringAsFixed(2)}/month',
                style: TextStyle(
                  fontSize: FontSize.bodyMedium,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: BoxSize.spacingS),
            Text(
              plan.description,
              style: TextStyle(
                fontSize: FontSize.bodyMedium,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: BoxSize.spacingL),
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
                      'Upgrade Now',
                      style: TextStyle(
                        fontSize: FontSize.bodyMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}