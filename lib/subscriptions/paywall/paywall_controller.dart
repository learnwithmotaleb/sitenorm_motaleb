import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../models/subscription_plan.dart';
import '../services/revenue_cat_service.dart';

class PaywallController extends GetxController {
  // ==========================
  // UI STATE
  // ==========================

  final selectedIndex = 0.obs; // 0 = Yearly, 1 = Monthly

  bool get isYearly => selectedIndex.value == 0;

  // ==========================
  // FEATURES
  // ==========================

  final List<String> features = [
    'Unlimited site monitoring',
    'Real-time notifications',
    'Advanced analytics',
    'Priority support',
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

  // Price from RevenueCat (never hardcoded)
  String get yearlyPrice {
    try {
      return offering.value!.availablePackages
          .firstWhere((p) =>
      p.storeProduct.identifier == kPlans.first.yearlyProductId)
          .storeProduct
          .priceString;
    } catch (_) {
      return '';
    }
  }

  String get monthlyPrice {
    try {
      return offering.value!.availablePackages
          .firstWhere((p) =>
      p.storeProduct.identifier == kPlans.first.monthlyProductId)
          .storeProduct
          .priceString;
    } catch (_) {
      return '';
    }
  }

  Package? get selectedPackage {
    if (offering.value == null) return null;

    final productId = isYearly
        ? kPlans.first.yearlyProductId
        : kPlans.first.monthlyProductId;

    try {
      return offering.value!.availablePackages.firstWhere(
            (package) => package.storeProduct.identifier == productId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> subscribe() async {
    final package = selectedPackage;
    if (package == null) return false;

    loading.value = true;
    final result = await RevenueCatService.instance.purchase(package);
    loading.value = false;

    return result;
  }

  Future<bool> restore() async {
    loading.value = true;
    final result = await RevenueCatService.instance.restore();
    loading.value = false;

    return result;
  }
}