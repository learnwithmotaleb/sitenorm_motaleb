import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/features/profile/presentation/screen/widgets/profile_header_card.dart';
import 'package:weather_app/features/profile/presentation/screen/widgets/profile_menu_item.dart';
import 'package:weather_app/share/widgets/custom_buttom_sheet/custom_buttom_sheet.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.settings.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_profileController.profileLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Gap(20.h),
                const ProfileHeaderCard(),
                Gap(24.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFF2C2C2E)),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: AppStrings.accountSettings.tr,
                        onTap: () {
                          context.pushNamed(RoutePath.settingScreen);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.bookmark_outline,
                        title: "Saved",
                        onTap: () {
                          context.pushNamed(RoutePath.saveScreen);
                        },
                        iconColor: AppColors.successColor,
                      ),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: AppStrings.contactSupport.tr,
                        onTap: () {
                          context.pushNamed(RoutePath.contactSupportScreen);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.description_outlined,
                        title: AppStrings.termsCondition.tr,
                        onTap: () {
                          context.pushNamed(RoutePath.termsAndConditionScreen);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: AppStrings.privacyPolicy.tr,
                        onTap: () {
                          context.pushNamed(RoutePath.privacyPolicyScreen);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.book_outlined,
                        title: "Reference",
                        onTap: () {
                          context.pushNamed(RoutePath.referenceScreen);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.logout,
                        title: AppStrings.logout.tr,
                        onTap: () {
                          showYesNoModal(
                            context,
                            title: 'Hey!'.tr,
                            message:
                                'Are you sure you want to Logout your account?'
                                    .tr,
                            confirmButtonText: AppStrings.logout.tr,
                            onConfirm: () {
                              _profileController.logout();
                            },
                          );
                        },
                        showDivider: false,
                        textColor: Colors.white,
                        iconColor: AppColors.errorColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
