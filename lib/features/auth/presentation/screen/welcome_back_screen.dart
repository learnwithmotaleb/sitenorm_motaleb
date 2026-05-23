import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/custom_assets/assets.gen.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class WelcomeBackScreen extends StatelessWidget {
  const WelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading:
            const SizedBox(), // No back button needed usually for success screens, but can add if requested
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    // SvgPicture.asset(
                    //   'assets/images/welcomeimage.svg',
                    //   height: 250.h,
                    // ),
                    Assets.icons.welcomeimage.svg(height: 250.h, width: 250.w),
                    Gap(40.h),

                    /// ---------- TITLE ----------
                    Text(
                      AppStrings.welcomeBack.tr,
                      style: context.headlineMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(12.h),

                    /// ---------- SUBTITLE ----------
                    Text(
                      AppStrings.passwordChangedContinueLogin.tr,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium.copyWith(
                        color: isDarkMode
                            ? Colors.white
                            : AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),

              /// ---------- CONTINUE BUTTON ----------
              CustomButton(
                text: AppStrings.continueText.tr,
                isLoading: false,
                onTap: () {
                  context.goNamed(RoutePath.loginScreen);
                },
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
