import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:weather_app/core/custom_assets/assets.gen.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/local/local_service.dart';
import 'package:weather_app/features/auth/controller/auth_controller.dart';
import 'package:weather_app/helper/validator/text_field_validator.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/text_field/custom_text_field.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/subscriptions/services/revenue_cat_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  final LocalService localService = sl();
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await localService.getToken();
    if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      final userId = await localService.getUserId();
      await RevenueCatService.instance.init(userId);
      final subscribed = await RevenueCatService.instance.isSubscribed();
      if (subscribed) {
        AppRouter.route.goNamed(RoutePath.homeScreen);
      } else {
        AppRouter.route.goNamed(RoutePath.paywallScreen);
      }
    } else {
      AppRouter.route.goNamed(RoutePath.loginScreen);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Assets.images.applogo.image(width: 150.w, height: 150.h),
                  const Gap(60),
                  Text(AppStrings.signIn.tr, style: context.headlineLarge),
                  const Gap(8),
                  Text(
                    AppStrings.getStarted.tr,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  const Gap(40),
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppStrings.enterEmailAddress.tr,
                    validator: TextFieldValidator.email(),
                  ),
                  const Gap(16),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: AppStrings.enterPassword.tr,
                    isPassword: true,
                    validator: TextFieldValidator.password(),
                  ),
                  const Gap(32),
                  Obx(
                    () => CustomButton(
                      isLoading: _authController.signInLoading.value,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _authController.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      text: AppStrings.signIn.tr,
                    ),
                  ),
                  const Gap(8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(RoutePath.forgetPasswordScreen);
                      },
                      child: Text(
                        AppStrings.forgotPassword.tr,
                        style: context.labelMedium.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Gap(60),
                  Text(
                    AppStrings.dontHaveAnAccount.tr,
                    style: context.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  OutlinedButton(
                    onPressed: () {
                      context.pushNamed(RoutePath.signUpScreen);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryText),
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppStrings.createNewAccount.tr),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
