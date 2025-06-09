class SubscriptionPlan {
  final String name;
  final String period;
  final double price;
  final double monthlyPrice;
  final String discount;
  final String description;

  const SubscriptionPlan({
    required this.name,
    required this.period,
    required this.price,
    required this.monthlyPrice,
    required this.discount,
    required this.description,
  });
}