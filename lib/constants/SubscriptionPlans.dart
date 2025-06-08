import 'package:ai_chatter/models/SubscriptionPlan.dart';

class SubscriptionPlans {
  static const List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      name: 'Basic Plan',
      period: '1 month',
      price: 3.99,
      monthlyPrice: 3.99,
      discount: '–',
      description: 'Trial / Short-term subscription',
      features: [
        'Smarter, more emotional AI replies',
        'Chat limit: Unlimited messages per day',
        'More options to character creation',
        'Faster response time',
      ],
    ),
    SubscriptionPlan(
      name: 'Standard Plan',
      period: '3 months',
      price: 9.99,
      monthlyPrice: 3.33,
      discount: '16%',
      description: 'Mid-term subscription with discount',
      features: [
        'Smarter, more emotional AI replies',
        'Chat limit: Unlimited messages per day',
        'More options to character creation',
        'Faster response time',
      ],
    ),
    SubscriptionPlan(
      name: 'Premium Plan',
      period: '1 year',
      price: 29.99,
      monthlyPrice: 2.50,
      discount: '37%',
      description: 'Long-term subscription, best value',
      features: [
        'Smarter, more emotional AI replies',
        'Chat limit: Unlimited messages per day',
        'More options to character creation',
        'Faster response time',
      ],
    ),
  ];
}