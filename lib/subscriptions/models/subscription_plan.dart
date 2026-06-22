// lib/core/models/subscription_plan.dart
class SubscriptionPlan {
  final String title;
  final String entitlement;
  final String monthlyPrice;
  final String yearlyPrice;
  final String monthlyProductId;
  final String yearlyProductId;
  final bool isPopular;

  const SubscriptionPlan({
    required this.title,
    required this.entitlement,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.monthlyProductId,
    required this.yearlyProductId,
    this.isPopular = false,
  });
}

// Your pricing from the screenshot:
const List<SubscriptionPlan> kPlans = [
  SubscriptionPlan(
    title: 'Basic',
    entitlement: 'basic',
    monthlyPrice: '\$19.99/mo',
    yearlyPrice: '\$199/yr',
    monthlyProductId: 'basic_monthly',
    yearlyProductId: 'basic_yearly',
  ),
  SubscriptionPlan(
    title: 'Premium',
    entitlement: 'premium',
    monthlyPrice: '\$29.99/mo',
    yearlyPrice: '\$299/yr',
    monthlyProductId: 'premium_monthly',
    yearlyProductId: 'premium_yearly',
    isPopular: true,
  ),
];