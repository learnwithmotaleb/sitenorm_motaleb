import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'paywall_controller.dart';
import 'plan_card_widget.dart';

class PaywallScreen extends GetView<PaywallController> {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Top Icon
                CircleAvatar(
                  radius: 42,
                  backgroundColor: controller.primaryColor,
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                /// Title
                Text(
                  "Unlock Pro Access",
                  style: TextStyle(
                    color: controller.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Get access to all of our features",
                  style: TextStyle(
                    color: controller.subTitleColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                /// Features
                ...controller.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: controller.primaryColor,
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

                /// Yearly Plan
                PlanCardWidget(
                  title: "Yearly Subscription",
                  subtitle: "Get full access for just \$9.99",
                  selected: controller.selectedIndex.value == 0,
                  onTap: () => controller.selectPlan(0),
                ),

                const SizedBox(height: 10),

                /// Monthly Plan
                PlanCardWidget(
                  title: "Monthly Subscription",
                  subtitle: "Get full access for just \$1.99",
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
                      backgroundColor: controller.primaryColor,
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
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Purchase",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
                  child: Text(
                    "Restore Purchases",
                    style: TextStyle(
                      color: controller.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
