import 'package:flutter/material.dart';
import 'package:ai_chatter/models/SubscriptionPlan.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionPlans {
  static List<String> getLocalizedFeatures(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return [
      loc.feature1,
      loc.feature2,
      loc.feature3,
      loc.feature4,
      loc.feature5,
    ];
  }

  static List<SubscriptionPlan> getLocalizedPlans(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return [
      SubscriptionPlan(
        name: loc.basicPlanName,
        period: loc.period1Month,
        price: 3.99,
        monthlyPrice: 3.99,
        discount: '–',
        description: loc.basicPlanDescription,
      ),
      SubscriptionPlan(
        name: loc.standardPlanName,
        period: loc.period3Months,
        price: 9.99,
        monthlyPrice: 3.33,
        discount: '16%',
        description: loc.standardPlanDescription,
      ),
      SubscriptionPlan(
        name: loc.premiumPlanName,
        period: loc.period1Year,
        price: 29.99,
        monthlyPrice: 2.50,
        discount: '37%',
        description: loc.premiumPlanDescription,
      ),
    ];
  }
}