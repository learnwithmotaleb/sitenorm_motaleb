import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color/app_colors.dart';
import 'paywall_controller.dart';
import 'plan_card_widget.dart';

class PaywallScreen extends GetView<PaywallController> {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Obx(
              () => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// Top Icon
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

                /// Title
                const Text(
                  "Unlock Pro Access",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Get access to all SiteNorm Pro features",
                  style: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                /// Features
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
                        Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Yearly Plan
                PlanCardWidget(
                  title: "Yearly Subscription",
                  subtitle: controller.yearlyPrice.isNotEmpty
                      ? "${controller.yearlyPrice}/year"
                      : "Loading...",
                  selected: controller.selectedIndex.value == 0,
                  onTap: () => controller.selectPlan(0),
                ),

                /// Monthly Plan
                PlanCardWidget(
                  title: "Monthly Subscription",
                  subtitle: controller.monthlyPrice.isNotEmpty
                      ? "${controller.monthlyPrice}/month"
                      : "Loading...",
                  selected: controller.selectedIndex.value == 1,
                  onTap: () => controller.selectPlan(1),
                ),

                const SizedBox(height: 10),

                /// Purchase Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.loading.value
                        ? null
                        : () async {
                      final success = await controller.subscribe();
                      if (success) {
                        Get.offAllNamed('/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
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
                      "Purchase",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Restore
                TextButton(
                  onPressed: controller.loading.value
                      ? null
                      : () async {
                    await controller.restore();
                  },
                  child: const Text(
                    "Restore Purchases",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}