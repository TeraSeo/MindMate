import 'package:ai_chatter/widgets/subscription/SubscriptionPlanCard.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/SubscriptionPlans.dart';

class SubscriptionPlanDialog extends StatelessWidget {
  const SubscriptionPlanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...SubscriptionPlans.subscriptionPlans.map((plan) => SubscriptionPlanCard(plan: plan)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}