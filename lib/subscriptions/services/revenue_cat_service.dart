// lib/core/services/revenue_cat_service.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/entitlements.dart';

class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  Future<void> init(String userId) async {
    await Purchases.setLogLevel(LogLevel.debug);

    final config = PurchasesConfiguration(
      Platform.isIOS
          ? RevenueCatConfig.appleApiKey
          : RevenueCatConfig.googleApiKey,
    )..appUserID = userId;

    await Purchases.configure(config);
  }

  Future<Offering?> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.getOffering(RevenueCatConfig.offeringId)
          ?? offerings.current;
    } catch (e) {
      return null;
    }
  }

  Future<bool> purchase(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      return _hasProEntitlement(purchaseResult.customerInfo);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return _hasProEntitlement(info);
    } catch (_) {
      return false;
    }
  }

  Future<bool> isSubscribed() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return _hasProEntitlement(info);
    } catch (_) {
      return false;
    }
  }

  bool _hasProEntitlement(CustomerInfo info) {
    return info.entitlements.active.containsKey(Entitlements.pro);
  }
}