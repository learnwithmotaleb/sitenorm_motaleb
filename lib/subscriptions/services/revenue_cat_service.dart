// lib/subscriptions/services/revenue_cat_service.dart
//
// RevenueCat integration — platform differences are handled internally by the SDK.
// Only Platform.isIOS / Platform.isAndroid is used for:
//   1. Selecting the correct API key (init)
//   2. Opening the correct subscription management URL (history_controller.dart)
// Everything else (purchase, restore, getOffering, entitlements) is cross-platform.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/entitlements.dart';

class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  // ─── 1. Initialization — only place Platform is used for keys ────────────
  Future<void> init(String userId) async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

    final PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(RevenueCatConfig.googleApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(RevenueCatConfig.appleApiKey);
    } else {
      throw UnsupportedError('Platform not supported');
    }

    configuration.appUserID = userId;
    await Purchases.configure(configuration);

    debugPrint(
      '✅ RevenueCat initialized for ${Platform.isIOS ? "iOS" : "Android"} | userId: $userId',
    );
  }

  // ─── 2. Get Offerings — no platform handling needed ──────────────────────
  // RevenueCat returns the correct products for each store automatically.
  Future<Offering?> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering =
          offerings.getOffering(RevenueCatConfig.offeringId) ??
          offerings.current;

      if (offering == null) {
        debugPrint(
          '❌ RC Offering is NULL — check RC dashboard offerings setup',
        );
      } else {
        debugPrint(
          '✅ RC Offering: ${offering.identifier} | packages: ${offering.availablePackages.length}',
        );
        for (final p in offering.availablePackages) {
          debugPrint(
            '  → ${p.identifier} | ${p.storeProduct.identifier} | ${p.storeProduct.priceString}',
          );
        }
      }

      return offering;
    } catch (e) {
      debugPrint('❌ RevenueCat getOffering error: $e');
      return null;
    }
  }

  // ─── 3. Purchase — no platform handling needed ───────────────────────────
  // RevenueCat opens Google Play Billing (Android) or Apple sheet (iOS) automatically.
  // ignore: deprecated_member_use
  Future<bool> purchase(Package package) async {
    try {
      // ignore: deprecated_member_use
      final result = await Purchases.purchasePackage(package);
      return _hasProEntitlement(result.customerInfo);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('ℹ️ Purchase cancelled by user');
        return false;
      }
      debugPrint('❌ Purchase error: $e');
      rethrow;
    }
  }

  // ─── 4. Restore Purchases — required by Apple, recommended on Android ────
  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      final hasPro = _hasProEntitlement(info);
      debugPrint(
        hasPro
            ? '✅ Restore successful — Pro active'
            : 'ℹ️ Restore complete — no active Pro',
      );
      return hasPro;
    } catch (e) {
      debugPrint('❌ Restore error: $e');
      return false;
    }
  }

  // ─── 5. Check Subscription — no platform handling needed ─────────────────
  Future<bool> isSubscribed() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return _hasProEntitlement(info);
    } catch (e) {
      debugPrint('❌ isSubscribed error: $e');
      return false;
    }
  }

  // ─── 6. Get CustomerInfo ─────────────────────────────────────────────────
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('❌ getCustomerInfo error: $e');
      return null;
    }
  }

  // ─── 7. Logout ───────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await Purchases.logOut();
      debugPrint('✅ RevenueCat logged out');
    } catch (e) {
      debugPrint('⚠️ RevenueCat logout error (ignored): $e');
    }
  }

  // ─── Helper ──────────────────────────────────────────────────────────────
  bool _hasProEntitlement(CustomerInfo info) {
    return info.entitlements.active.containsKey(Entitlements.pro);
  }
}
