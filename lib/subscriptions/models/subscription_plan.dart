// lib/core/models/subscription_plan.dart
class SubscriptionPlan {
  final String title;
  final String entitlement;
  final String monthlyProductId;
  final String yearlyProductId;

  const SubscriptionPlan({
    required this.title,
    required this.entitlement,
    required this.monthlyProductId,
    required this.yearlyProductId,
  });
}

const List<SubscriptionPlan> kPlans = [
  SubscriptionPlan(
    title: 'Pro',
    entitlement: 'sitenorm Pro',
    monthlyProductId: 'sitenorm_pro_monthly:monthly',
    yearlyProductId: 'sitenorm_pro_yearly:yearly',
  ),
];