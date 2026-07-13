import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';

class HistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<CustomerInfo> customerInfo = Rxn<CustomerInfo>();

  // Platform-specific deep links for subscription management
  static const String _androidManageUrl =
      'https://play.google.com/store/account/subscriptions';
  static const String _iosManageUrl =
      'https://apps.apple.com/account/subscriptions';

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  String get platformManageUrl => isIOS ? _iosManageUrl : _androidManageUrl;

  String get cancelInstructions => isIOS
      ? 'Open Settings → Apple ID → Subscriptions and cancel from there.'
      : 'Open Google Play Store → Subscriptions and cancel from there.';

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionHistory();
  }

  Future<void> fetchSubscriptionHistory() async {
    isLoading.value = true;
    try {
      final info = await Purchases.getCustomerInfo();
      customerInfo.value = info;
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
      AppToast.error(message: 'Failed to load subscription details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openManagementUrl() async {
    final info = await Purchases.getCustomerInfo();
    final managementUrl = info.managementURL;

    if (managementUrl != null && managementUrl.isNotEmpty) {
      // Prevent opening Apple URLs on Android devices (and vice versa)
      // This commonly happens during testing if the same RevenueCat user ID 
      // was used to purchase an iOS subscription previously.
      final isAppleUrlOnAndroid = Platform.isAndroid && managementUrl.contains('apple.com');
      final isGoogleUrlOnIOS = Platform.isIOS && managementUrl.contains('google.com');

      if (!isAppleUrlOnAndroid && !isGoogleUrlOnIOS) {
        await launchUrl(
          Uri.parse(managementUrl),
          mode: LaunchMode.externalApplication,
        );
        return;
      }
    }

    // fallback native store URLs
    if (Platform.isAndroid) {
      await launchUrl(
        Uri.parse("https://play.google.com/store/account/subscriptions"),
        mode: LaunchMode.externalApplication,
      );
    } else if (Platform.isIOS) {
      await launchUrl(
        Uri.parse("https://apps.apple.com/account/subscriptions"),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> openStorePage() async {
    await _launchUrl(platformManageUrl);
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      // Try external application mode first
      bool launched = false;
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}

      // Fallback to in-app browser or default handling
      if (!launched) {
        try {
          launched = await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
        } catch (_) {}
      }

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Launch URL error: $e');
      AppToast.error(message: 'Could not open subscription settings. Please manage from your device Settings.');
    }
  }
}