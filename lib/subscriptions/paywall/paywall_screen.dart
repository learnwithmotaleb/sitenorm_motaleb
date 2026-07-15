import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../../core/router/route_path.dart';
import '../../core/router/routes.dart';
import '../../utils/color/app_colors.dart';
import 'paywall_controller.dart';
import 'plan_card_widget.dart';

class PaywallScreen extends GetView<PaywallController> {
  const PaywallScreen({super.key});

  static String _legalNote() {
    final store = Platform.isIOS ? 'Apple ID' : 'Google Play';
    return 'Subscriptions auto-renew at the stated price unless cancelled at least '
        '24 hours before the end of the current period. You can manage or cancel '
        'your subscription anytime from your device store settings. Payment will be '
        'charged to your $store account at confirmation of purchase.';
  }

  Future<void> _openPrivacyPolicy() async {
    const url = 'https://api.sitenorm.com/api/v1/manage/view-privacy-policy';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _openTerms() async {
    const url = 'https://api.sitenorm.com/api/v1/manage/view-terms-conditions';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Subscription Required'),
        content: const Text(
          'SiteNorm requires an active subscription to access all features. '
              'Subscribe now to unlock full access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              SystemNavigator.pop();
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  Widget _termRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12, color: Colors.black87)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.offering.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [

                // ── Close Button ─────────────────────────────────────────
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    color: AppColors.hintTextColor,
                    onPressed: () => _showExitDialog(context),
                  ),
                ),
                const SizedBox(height: 4),

                // ── Top Icon ─────────────────────────────────────────────
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.primaryColor,
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Title ────────────────────────────────────────────────
                const Text(
                  'Unlock Pro Access',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Get access to all SiteNorm Pro features',
                  style: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Features ─────────────────────────────────────────────
                ...controller.features.map(
                      (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Plans ────────────────────────────────────────────────
                PlanCardWidget(
                  title: 'Yearly Subscription',
                  subtitle: controller.yearlyPrice.isNotEmpty
                      ? '${controller.yearlyPrice} billed once per year'
                      : 'Loading...',
                  selected: controller.selectedIndex.value == 0,
                  onTap: () => controller.selectPlan(0),
                ),

                PlanCardWidget(
                  title: 'Monthly Subscription',
                  subtitle: controller.monthlyPrice.isNotEmpty
                      ? '${controller.monthlyPrice} billed every month'
                      : 'Loading...',
                  selected: controller.selectedIndex.value == 1,
                  onTap: () => controller.selectPlan(1),
                ),

                const SizedBox(height: 12),

                // ── Subscription Terms (Google Play + Apple required) ──────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subscription Terms',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _termRow(
                        'Yearly Plan',
                        '${controller.yearlyPrice} charged once per year (auto-renews annually)',
                      ),
                      _termRow(
                        'Monthly Plan',
                        '${controller.monthlyPrice} charged every month (auto-renews monthly)',
                      ),
                      _termRow(
                        'Auto-renewal',
                        'Subscription automatically renews unless cancelled at least 24 hours before the renewal date',
                      ),
                      _termRow(
                        'Cancel anytime',
                        'Manage or cancel in your ${Platform.isIOS ? "App Store" : "Google Play"} account settings',
                      ),
                      _termRow(
                        'Required',
                        'A subscription is required to access all features of this app',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Purchase Button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.loading.value ||
                        controller.selectedPackage == null
                        ? null
                        : () async {
                      final success = await controller.subscribe();
                      if (success) {
                        AppRouter.route.goNamed(RoutePath.homeScreen);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.loading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                        : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Restore Purchases ─────────────────────────────────────
                TextButton(
                  onPressed: controller.loading.value
                      ? null
                      : () async {
                    final restored = await controller.restore();
                    if (restored) {
                      AppRouter.route.goNamed(RoutePath.homeScreen);
                    } else {
                      Get.snackbar(
                        'Restore',
                        'No active subscription found.',
                        backgroundColor: AppColors.darkSurface,
                        colorText: AppColors.white,
                      );
                    }
                  },
                  child: const Text(
                    'Restore Purchases',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Legal Note ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _legalNote(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.hintTextColor,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Privacy Policy & Terms ────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _openPrivacyPolicy,
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _openTerms,
                      child: const Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }
}