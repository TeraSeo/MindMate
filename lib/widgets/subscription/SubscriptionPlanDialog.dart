import 'package:ai_chatter/widgets/subscription/SubscriptionPlanCard.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatter/constants/SubscriptionPlans.dart';
import 'package:ai_chatter/constants/Colors.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class SubscriptionPlanDialog extends StatelessWidget {
  const SubscriptionPlanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width > 700 ? 700.0 : size.width * 0.9;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BoxSize.cardRadius),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(BoxSize.spacingL),
              decoration: BoxDecoration(
                color: ConstantColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(BoxSize.cardRadius),
                  topRight: Radius.circular(BoxSize.cardRadius),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      fontSize: FontSize.h4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(BoxSize.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All plans include:',
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
                        children: SubscriptionPlans.featuers.map((f) => Padding(
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
                      'Select a plan:',
                      style: TextStyle(
                        fontSize: FontSize.h5,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.primaryColor,
                      ),
                    ),
                    const SizedBox(height: BoxSize.spacingM),
                    ...SubscriptionPlans.subscriptionPlans.map(
                      (plan) => Padding(
                        padding: const EdgeInsets.only(bottom: BoxSize.spacingM),
                        child: SubscriptionPlanCard(plan: plan),
                      ),
                    ),
                    const SizedBox(height: BoxSize.spacingL),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: BoxSize.spacingM),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: ConstantColor.primaryColor,
                            fontSize: FontSize.bodyLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}