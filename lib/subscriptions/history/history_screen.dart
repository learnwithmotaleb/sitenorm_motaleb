import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController controller = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSubscriptionHistory();
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          "My Subscription",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final info = controller.customerInfo.value;
        if (info == null) {
          return Center(
            child: Text(
              "No subscription information found.",
              style: context.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          );
        }

        final activeEntitlements = info.entitlements.active.values.toList();
        final allEntitlements = info.entitlements.all.values.toList();

        return RefreshIndicator(
          onRefresh: () => controller.fetchSubscriptionHistory(),
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Active Plans ─────────────────────────────────────────
                Text(
                  "Active Plans",
                  style: context.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12.h),

                if (activeEntitlements.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Text(
                      "You do not have any active Pro plan.",
                      style: context.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  )
                else
                  ...activeEntitlements.map(
                    (e) => _buildEntitlementCard(e, isActive: true),
                  ),

                Gap(24.h),

                // ─── Manage / Cancel Section ──────────────────────────────
                if (activeEntitlements.isNotEmpty) ...[
                  Text(
                    "Manage Subscription",
                    style: context.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(12.h),
                  _buildManagementCard(context),
                  Gap(24.h),
                ],

                // ─── History ──────────────────────────────────────────────
                Text(
                  "Entitlements History",
                  style: context.titleMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12.h),

                if (allEntitlements.isEmpty)
                  Text(
                    "No entitlement history found.",
                    style: context.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  )
                else
                  ...allEntitlements.map((entitlement) {
                    final isActive = activeEntitlements.any(
                      (e) => e.identifier == entitlement.identifier,
                    );
                    return _buildEntitlementCard(
                      entitlement,
                      isActive: isActive,
                    );
                  }),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Platform-specific manage / cancel card
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildManagementCard(BuildContext context) {
    final isIOS = Platform.isIOS;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform badge
          Row(
            children: [
              Icon(
                isIOS ? Icons.apple : Icons.android,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              Gap(8.w),
              Text(
                isIOS ? "App Store Subscription" : "Google Play Subscription",
                style: context.titleSmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Gap(12.h),

          // Policy-compliant instructions
          if (isIOS) ...[
            Text(
              "How to manage on iOS",
              style: context.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(8.h),
            _buildStep("1", "Open the Settings app on your iPhone or iPad."),
            _buildStep("2", "Tap your Apple ID at the top."),
            _buildStep("3", "Tap Subscriptions."),
            _buildStep("4", "Find SiteNorm and tap it to manage or cancel."),
            Gap(16.h),
            Text(
              "Per Apple guidelines, subscriptions must be cancelled through Apple's native settings.",
              style: context.bodySmall.copyWith(
                color: AppColors.hintTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else ...[
            Text(
              "How to manage on Android",
              style: context.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(8.h),
            _buildStep("1", "Open the Google Play Store app."),
            _buildStep("2", "Tap your profile icon at the top right."),
            _buildStep("3", "Tap Payments & subscriptions → Subscriptions."),
            _buildStep("4", "Find SiteNorm and tap Manage or Cancel."),
            Gap(16.h),
          ],

          Gap(4.h),

          // Open store button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => controller.openManagementUrl(),
              style: ElevatedButton.styleFrom(
                backgroundColor: isIOS
                    ? const Color(0xFF0071E3) // Apple blue
                    : const Color(0xFF01875F), // Google Play green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              icon: Icon(
                isIOS ? Icons.apple : Icons.shop_outlined,
                color: AppColors.white,
                size: 20.sp,
              ),
              label: Text(
                isIOS
                    ? "Open App Store Subscriptions"
                    : "Open Google Play Subscriptions",
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              text,
              style: context.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Entitlement card
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildEntitlementCard(
    EntitlementInfo entitlement, {
    required bool isActive,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive ? AppColors.primaryColor : AppColors.borderColor,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  entitlement.identifier,
                  style: context.titleMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryColor.withValues(alpha: 0.15)
                      : AppColors.borderColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isActive ? "Active" : "Expired",
                  style: TextStyle(
                    color: isActive
                        ? AppColors.primaryColor
                        : AppColors.secondaryText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          _buildInfoRow("Store", entitlement.store.name),
          _buildInfoRow(
            "Purchased",
            _formatDate(entitlement.latestPurchaseDate),
          ),
          if (entitlement.expirationDate != null)
            _buildInfoRow("Expires", _formatDate(entitlement.expirationDate)),
          _buildInfoRow("Auto Renew", entitlement.willRenew ? "Yes" : "No"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodyMedium.copyWith(color: AppColors.secondaryText),
          ),
          Flexible(
            child: Text(
              value,
              style: context.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
