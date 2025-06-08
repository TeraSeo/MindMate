import 'package:flutter/material.dart';
import 'package:ai_chatter/models/SubscriptionPlan.dart';
import 'package:ai_chatter/constants/Colors.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: handle subscription
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(plan.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (plan.discount != '–')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ConstantColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${plan.discount} OFF', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('\$${plan.price.toStringAsFixed(2)} / ${plan.period}'),
              if (plan.monthlyPrice != plan.price)
                Text('~ \$${plan.monthlyPrice.toStringAsFixed(2)}/month', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(plan.description, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              ...plan.features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: ConstantColor.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(child: Text(f)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}