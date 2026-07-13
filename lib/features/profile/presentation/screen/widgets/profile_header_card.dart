import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/share/widgets/network_image/custom_network_image.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/profile/controller/profile_controller.dart';
import 'package:weather_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:weather_app/subscriptions/paywall/subscription_badge_widget.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController _profileController = Get.find<ProfileController>();

    return Obx(() {
      final user = _profileController.profile.value.data;
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkSurface, // Dark surface
              Color(0xFF18301E), // Dark Green tint
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Placeholder
                CustomNetworkImage(
                  imageUrl: user?.avatar ?? AppConfig.defaultProfile,
                  height: 80.h,
                  width: 70.w,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(8.h),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user?.name ?? "User Name",
                              style: context.titleLarge.copyWith(
                                color: AppColors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(15.w),
                          const SmartSubscriptionBadge(),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        user?.email ?? "user@mail.com",
                        style: context.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
