import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/features/auth/controller/auth_controller.dart';
import 'package:weather_app/helper/validator/text_field_validator.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/text_field/custom_text_field.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _authController = Get.find<AuthController>();
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- TITLE ----------
                Text(
                  AppStrings.createNewPassword.tr, // Check string key
                  style: context.headlineMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12.h),

                /// ---------- SUBTITLE ----------
                Text(
                  AppStrings.createYourNewPassword.tr, // Check string key
                  style: context.bodyMedium.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(40.h),

                /// ---------- PASSWORD INPUT ----------
                CustomTextField(
                  controller: _passwordController,
                  hintText:
                      AppStrings.createNewPassword.tr, // Using as hint for now
                  isPassword: true,
                  validator: TextFieldValidator.password(),
                ),
                Gap(16.h),

                /// ---------- CONFIRM PASSWORD INPUT ----------
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: AppStrings.confirmPassword.tr,
                  isPassword: true,
                  validator: TextFieldValidator.confirmPassword(
                    _passwordController,
                  ),
                ),
                Gap(24.h),

                /// ---------- SUBMIT BUTTON ----------
                Obx(
                  () => CustomButton(
                    text: AppStrings.changePassword.tr,
                    isLoading: _authController.resetPasswordLoading.value,
                    onTap: () {
                      final body = {
                        "email": widget.email,
                        "otp": widget.otp,
                        "newPassword": _passwordController.text,
                      };
                      if (_formKey.currentState!.validate()) {
                        _authController.resetPassword(body: body);
                      }
                      // context.goNamed(RoutePath.welcomeBackScreen);
                    },
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
