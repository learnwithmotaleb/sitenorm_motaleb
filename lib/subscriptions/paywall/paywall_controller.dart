import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weather_app/subscriptions/services/revenue_cat_service.dart';

import '../models/subscription_plan.dart';

class PaywallController extends GetxController {
  // ==========================
  // UI STATE
  // ==========================

  final selectedIndex = 0.obs; // 0 = Yearly, 1 = Monthly

  bool get isYearly => selectedIndex.value == 0;

  // ==========================
  // COLORS
  // ==========================

  final Color primaryColor = const Color(0xFF1677FF);
  final Color borderColor = const Color(0xFFE5E5E5);
  final Color textColor = const Color(0xFF222222);
  final Color subTitleColor = const Color(0xFF777777);
  final Color backgroundColor = Colors.white;

  // ==========================
  // FEATURES
  // ==========================

  final List<String> features = [
    'Remove all ads',
    'Daily new content',
    'Other cool features',
    'Follow for more tutorials',
  ];

  // ==========================
  // REVENUECAT
  // ==========================

  final loading = false.obs;
  final offering = Rxn<Offering>();

  @override
  void onInit() {
    super.onInit();
    loadOffering();
  }

  Future<void> loadOffering() async {
    final result = await RevenueCatService.instance.getOffering();
    offering.value = result;
  }

  void selectPlan(int index) {
    selectedIndex.value = index;
  }

  Package? get selectedPackage {
    if (offering.value == null) return null;

    final plan = kPlans.first;

    final productId = isYearly
        ? plan.yearlyProductId
        : plan.monthlyProductId;

    try {
      return offering.value!.availablePackages.firstWhere(
            (package) =>
        package.storeProduct.identifier == productId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> subscribe() async {
    final package = selectedPackage;

    if (package == null) return false;

    loading.value = true;

    final result =
    await RevenueCatService.instance.purchase(package);

    loading.value = false;

    return result;
  }

  Future<bool> restore() async {
    loading.value = true;

    final result =
    await RevenueCatService.instance.restore();

    loading.value = false;

    return result;
  }
}