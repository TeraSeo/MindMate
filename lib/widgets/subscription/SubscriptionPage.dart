import 'package:flutter/material.dart';
import 'package:ai_chatter/widgets/subscription/SubscriptionPlanCard.dart';
import 'package:ai_chatter/constants/SubscriptionPlans.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.choosePlan,
          style: TextStyle(
            fontSize: FontSize.h6,
            color: Colors.white,
          ),
        ),
        backgroundColor: ConstantColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BoxSize.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.allPlansInclude,
              style: TextStyle(
                fontSize: FontSize.h5,
                fontWeight: FontWeight.bold,
                color: ConstantColor.primaryColor,
              ),
            ),
            const SizedBox(height: BoxSize.spacingM),
            Container(
              padding: const EdgeInsets.all(BoxSize.spacingL),
              decoration: BoxDecoration(
                color: ConstantColor.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(BoxSize.cardRadius),
                border: Border.all(
                  color: ConstantColor.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: SubscriptionPlans.getLocalizedFeatures(context).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: BoxSize.spacingM),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: ConstantColor.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 20,
                          color: ConstantColor.primaryColor,
                        ),
                      ),
                      const SizedBox(width: BoxSize.spacingM),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: FontSize.bodyLarge,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: BoxSize.spacingXL),
            Text(
              l10n.selectPlan,
              style: TextStyle(
                fontSize: FontSize.h5,
                fontWeight: FontWeight.bold,
                color: ConstantColor.primaryColor,
              ),
            ),
            const SizedBox(height: BoxSize.spacingM),
            ...SubscriptionPlans.getLocalizedPlans(context).map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: BoxSize.spacingM),
                child: SubscriptionPlanCard(plan: plan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}