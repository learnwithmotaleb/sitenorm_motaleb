import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/helper/validator/text_field_validator.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/text_field/custom_text_field.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/features/other/controller/other_controller.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _previousPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _otherController = Get.find<OtherController>();

  @override
  void dispose() {
    _previousPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.changePassword.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap(30.h),
              CustomTextField(
                controller: _previousPasswordController,
                hintText: AppStrings.previousPassword.tr,
                isPassword: true,
                validator: TextFieldValidator.required(errorText: "Previous password is required"),
              ),
              Gap(16.h),
              CustomTextField(
                controller: _newPasswordController,
                hintText: AppStrings.createYourNewPassword.tr,
                isPassword: true,
                validator: TextFieldValidator.password(),
              ),
              Gap(16.h),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: AppStrings.confirmPassword.tr,
                isPassword: true,
                validator: TextFieldValidator.confirmPassword(
                  _newPasswordController,
                ),
              ),
              Gap(30.h),
              Obx(() {
                return CustomButton(
                  text: AppStrings.changePassword.tr,
                  isLoading: _otherController.changePasswordLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _otherController.changePassword(
                        body: {
                          "currentPassword": _previousPasswordController.text,
                          "newPassword": _newPasswordController.text,
                        },
                      );
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
