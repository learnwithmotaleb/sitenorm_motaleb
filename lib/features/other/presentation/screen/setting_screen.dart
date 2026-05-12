import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/profile/presentation/screen/widgets/profile_menu_item.dart';
import 'package:weather_app/share/widgets/custom_buttom_sheet/custom_buttom_sheet.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:get/get.dart';
import 'package:weather_app/features/profile/controller/profile_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.accountSettings.tr),

        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(20.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.lock_reset_outlined,
                    title: AppStrings.changePassword.tr,
                    onTap: () {
                      context.pushNamed(RoutePath.changePasswordScreen);
                    },
                    iconColor: AppColors.successColor,
                  ),
                  ProfileMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    onTap: () {
                      showYesNoModal(
                        context,
                        title: 'Delete Account'.tr,
                        message:
                            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.'
                                .tr,
                        confirmButtonText: 'Delete'.tr,
                        onConfirm: () {
                          profileController.deleteAccount();
                        },
                      );
                    },
                    showDivider: false,
                    textColor: AppColors.errorColor,
                    iconColor: AppColors.errorColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
