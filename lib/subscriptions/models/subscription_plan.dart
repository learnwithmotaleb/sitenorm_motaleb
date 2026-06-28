// lib/core/models/subscription_plan.dart
import 'dart:io';

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

const String _monthlyAndroid = 'sitenorm_pro_monthly:monthly';
const String _monthlyIOS = 'basic_monthly';
const String _yearlyAndroid = 'sitenorm_pro_yearly:yearly';
const String _yearlyIOS = 'premium_yearly';

final List<SubscriptionPlan> kPlans = [
  SubscriptionPlan(
    title: 'Pro',
    entitlement: 'sitenorm Pro',
    monthlyProductId: Platform.isIOS ? _monthlyIOS : _monthlyAndroid,
    yearlyProductId: Platform.isIOS ? _yearlyIOS : _yearlyAndroid,
  ),
];
