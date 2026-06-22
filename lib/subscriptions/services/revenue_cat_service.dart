// lib/core/services/revenue_cat_service.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/entitlements.dart';

class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  // Call once in main.dart after Firebase/auth init
  Future<void> init(String userId) async {
    await Purchases.setLogLevel(LogLevel.debug);

    final config = PurchasesConfiguration(
      Platform.isIOS
          ? RevenueCatConfig.appleApiKey
          : RevenueCatConfig.googleApiKey,
    )..appUserID = userId;

    await Purchases.configure(config);
  }

  // Fetch current offering packages
  Future<Offering?> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.getOffering(RevenueCatConfig.offeringId)
          ?? offerings.current;
    } catch (e) {
      return null;
    }
  }

  // Purchase a package, returns true on success
  // NOTE: purchases_flutter v10 throws PlatformException — use PurchasesErrorHelper
  Future<bool> purchase(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      final info = purchaseResult.customerInfo;
      return _hasAnyEntitlement(info);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  // Restore purchases
  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return _hasAnyEntitlement(info);
    } catch (_) {
      return false;
    }
  }

  // Check if user has ANY active entitlement
  Future<bool> isSubscribed() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return _hasAnyEntitlement(info);
    } catch (_) {
      return false;
    }
  }

  bool _hasAnyEntitlement(CustomerInfo info) {
    final active = info.entitlements.active;
    return active.containsKey(Entitlements.basic)
        || active.containsKey(Entitlements.premium)
        || active.containsKey(Entitlements.firmPack);
  }
}