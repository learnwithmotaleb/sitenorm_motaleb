// lib/widgets/subscription_badge_widget.dart
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/entitlements.dart';
import '../../utils/color/app_colors.dart';

class SubscriptionBadgeWidget extends StatelessWidget {
  final CustomerInfo customerInfo;

  const SubscriptionBadgeWidget({
    super.key,
    required this.customerInfo,
  });

  bool get isPro =>
      customerInfo.entitlements.active.containsKey(Entitlements.pro);

  @override
  Widget build(BuildContext context) {
    if (!isPro) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield, color: AppColors.white, size: 14),
          SizedBox(width: 4),
          Text(
            "Pro",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SmartSubscriptionBadge extends StatelessWidget {
  const SmartSubscriptionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerInfo>(
      future: Purchases.getCustomerInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return SubscriptionBadgeWidget(
          customerInfo: snapshot.data!,
        );
      },
    );
  }
}