// lib/widgets/subscription_badge_widget.dart
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/router/route_path.dart';
import '../../core/router/routes.dart';
import '../constants/entitlements.dart';
import '../../utils/color/app_colors.dart';

class SubscriptionBadgeWidget extends StatelessWidget {
  final CustomerInfo customerInfo;

  const SubscriptionBadgeWidget({super.key, required this.customerInfo});

  bool get isPro =>
      customerInfo.entitlements.active.containsKey(Entitlements.pro);

  @override
  Widget build(BuildContext context) {
    if (!isPro) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        AppRouter.route.pushNamed(RoutePath.historyScreen);
      },
      child: Container(
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
      ),
    );
  }
}

class SmartSubscriptionBadge extends StatefulWidget {
  const SmartSubscriptionBadge({super.key});

  @override
  State<SmartSubscriptionBadge> createState() => _SmartSubscriptionBadgeState();
}

class _SmartSubscriptionBadgeState extends State<SmartSubscriptionBadge> {
  CustomerInfo? _customerInfo;

  @override
  void initState() {
    super.initState();
    // Fetch current info immediately
    Purchases.getCustomerInfo()
        .then((info) {
          if (mounted) setState(() => _customerInfo = info);
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    if (_customerInfo == null) return const SizedBox.shrink();
    return SubscriptionBadgeWidget(customerInfo: _customerInfo!);
  }
}
