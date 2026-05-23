import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/custom_assets/assets.gen.dart';
import 'package:weather_app/features/auth/controller/auth_controller.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/text_field/otp_text_field.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class ActiveOtpScreen extends StatefulWidget {
  final String email;
  const ActiveOtpScreen({super.key, required this.email});

  @override
  State<ActiveOtpScreen> createState() => _ActiveOtpScreenState();
}

class _ActiveOtpScreenState extends State<ActiveOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController verifyOtp = .new();
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    verifyOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: BackButton(color: AppColors.white),
        title: Text(
          AppStrings.agroClima.tr,
          style: context.headlineSmall.copyWith(color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(20.h),

                /// ---------- MAIN TITLE ----------
                Text(
                  AppStrings.enter6DigitCode.tr, // Or similar title
                  textAlign: TextAlign.center,
                  style: context.headlineSmall.copyWith(color: AppColors.white),
                ),
                Gap(12.h),

                /// ---------- SUBTITLE ----------
                Text(
                  AppStrings.enterCodeSentToMail.tr,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
                const Gap(28),
                // Icon
                Assets.icons.otpicon.svg(),

                const Gap(32),

                /// ---------- OTP INPUT ----------
                Align(
                  alignment: Alignment.center,
                  child: OtpTextField(controller: verifyOtp),
                ),

                Gap(28.h),

                /// ---------- CONFIRM BUTTON ----------
                Obx(
                  () => CustomButton(
                    text: AppStrings.continueText.tr,
                    isLoading: _authController.activeOtpLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _authController.activeOtp(
                          email: widget.email,
                          otp: verifyOtp.text,
                        );
                        print("OTP Verified: ${verifyOtp.text}");
                      }
                    },
                  ),
                ),
                Gap(28.h),

                /// ---------- DON'T GET CODE TEXT ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.haventReceivedOtp.tr,
                      style: context.titleMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Gap(8.h),

                    ///  ---------- RESEND WITH TIMER UI ----------
                    Obx(
                      () => _authController.isResendEnabled.value
                          ? GestureDetector(
                              onTap: () {
                                _authController.resendCode();
                              },
                              child: Text(
                                AppStrings.resendOtp.tr,
                                style: context.titleSmall.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Text(
                              "Resend code in 00:${_authController.start.value.toString().padLeft(2, '0')}s",
                              style: context.titleSmall.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
