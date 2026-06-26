import 'dart:async';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/local/local_service.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/subscriptions/services/revenue_cat_service.dart';

import '../../../utils/config/app_config.dart';

class AuthController extends GetxController {
  RxBool isResendEnabled = true.obs;
  RxInt start = 30.obs;
  Timer? _timer;
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  void resendCode() {
    isResendEnabled.value = false;
    start.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        isResendEnabled.value = true;
        _timer?.cancel();
      } else {
        start.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Sign Up Section
  RxBool signUpLoading = false.obs;
  bool signUpLoadingMethod(bool status) => signUpLoading.value = status;

  Future<void> signUp({
    required String nameSignUp,
    required String emailSignUp,
    required String passwordSignUp,
    required String confirmPasswordSignUp,
  }) async {
    signUpLoadingMethod(true);
    final body = {
      "name": nameSignUp.trim(),
      "email": emailSignUp.trim(),
      "password": passwordSignUp.trim(),
      "confirmPassword": confirmPasswordSignUp.trim(),
    };

    AppConfig.logger.i(body);

    final response = await apiClient.post(url: ApiUrls.signUp(), body: body);

    AppConfig.logger.i(response.data);

    if (response.statusCode == 201) {
      signUpLoadingMethod(false);

      AppToast.success(
        message: response.data?['message']?.toString() ?? "Success",
      );

      AppRouter.route.pushNamed(
        RoutePath.activeOtpScreen,
        extra: {"email": emailSignUp},
      );
    } else {
      signUpLoadingMethod(false);
      AppToast.error(message: response.data?['message']?.toString() ?? "Error");
    }
    // try {

    // } catch (err) {
    //   signUpLoadingMethod(false);
    //   AppConfig.logger.e(err);
    //   AppToast.error(message: "Something went wrong");
    // }
  }

  // ===================== Verify OTP Section ===============
  RxBool activeOtpLoading = false.obs;
  bool activeOtpLoadingMethod(bool status) => activeOtpLoading.value = status;

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

  Future<void> activeOtp({required String otp, required String email}) async {
    AppConfig.logger.i("otp $otp");
    AppConfig.logger.i("email $email");
    try {
      activeOtpLoadingMethod(true);
      final body = {"otp": otp.trim(), "email": email.trim()};

      AppConfig.logger.i(body);

      final response = await apiClient.post(
        url: ApiUrls.emailVerify(),
        body: body,
      );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        activeOtpLoadingMethod(false);
        AppToast.success(
          message: response.data?["message"]?.toString() ?? "Success",
        );

        final data = response.data['data'];
        if (data != null && data['token'] != null) {
          final token = data['token']?.toString() ?? "";
          final refreshToken = "";
          final userId = data['user']?['id']?.toString() ?? "";
          final role = data['user']?['role']?.toString().toUpperCase() ?? "";

          await localService.saveUserdata(
            token: token,
            refreshToken: refreshToken,
            id: userId,
            role: role,
          );

          await RevenueCatService.instance.init(userId);
          final subscribed = await RevenueCatService.instance.isSubscribed();
          if (subscribed) {
            AppRouter.route.goNamed(RoutePath.homeScreen);
          } else {
            AppRouter.route.goNamed(RoutePath.paywallScreen);
          }
        } else {
          // If no user data is returned, fall back to login screen
          AppRouter.route.goNamed(RoutePath.loginScreen);
        }
      } else {
        activeOtpLoadingMethod(false);
        AppToast.error(
          message: response.data?["message"]?.toString() ?? "Error",
        );
      }
    } catch (err) {
      activeOtpLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }

  // ===================== Resend OTP Section ===============

  RxBool resendOtpLoading = false.obs;
  bool resendOtpLoadingMethod(bool status) => resendOtpLoading.value = status;

  Future<void> resendOtp({
    required String email,
    required String purpose,
  }) async {
    try {
      resendOtpLoadingMethod(true);
      final body = {"email": email.trim(), "purpose": purpose};

      AppConfig.logger.i(body);

      final response = await apiClient.post(
        url: ApiUrls.resendOtp(),
        body: body,
      );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        resendOtpLoadingMethod(false);

        AppToast.success(
          message: response.data?["message"]?.toString() ?? "Success",
        );
      } else {
        resendOtpLoadingMethod(false);
        AppToast.error(
          message: response.data?["message"]?.toString() ?? "Error",
        );
      }
    } catch (err) {
      resendOtpLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }

  // ================== Sign In Section===================
  RxBool signInLoading = false.obs;
  bool signInLoadingMethod(bool status) => signInLoading.value = status;

  Future<void> signIn({required String email, required String password}) async {
    try {
      signInLoadingMethod(true);

      final body = {"email": email.trim(), "password": password.trim()};

      AppConfig.logger.i(body);

      final response = await apiClient.post(url: ApiUrls.login(), body: body);

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        signInLoadingMethod(false);
        AppToast.success(
          message: response.data?["message"]?.toString() ?? "Login Successful",
        );

        final data = response.data['data'];
        final token = data['token']?.toString() ?? "";
        final refreshToken = ""; // Removed from new API response
        final userId = data['user']?['id']?.toString() ?? "";
        final role = data['user']?['role']?.toString().toUpperCase() ?? "";

        await localService.saveUserdata(
          token: token,
          refreshToken: refreshToken,
          id: userId,
          role: role,
        );

        signInLoadingMethod(false);
        await RevenueCatService.instance.init(userId);
        final subscribed = await RevenueCatService.instance.isSubscribed();
        if (subscribed) {
          AppRouter.route.goNamed(RoutePath.homeScreen);
        } else {
          AppRouter.route.goNamed(RoutePath.paywallScreen);
        }
      } else {
        signInLoadingMethod(false);
        AppToast.error(
          message: response.data?["message"]?.toString() ?? "Login Failed",
        );
      }
    } catch (err) {
      signInLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }

  // ================== Forgot Password Section ===================

  final forgotPasswordLoading = false.obs;
  bool forgotPasswordLoadingMethod(bool status) =>
      forgotPasswordLoading.value = status;
  Future<void> forgotPassword({required String email}) async {
    try {
      forgotPasswordLoadingMethod(true);

      final body = {"email": email.trim()};

      AppConfig.logger.i(body);

      final response = await apiClient.post(
        url: ApiUrls.forgotPassword(),
        body: body,
      );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        forgotPasswordLoadingMethod(false);
        AppToast.success(
          message:
              response.data?["message"]?.toString() ??
              "Forgot Password Successful",
        );
        AppRouter.route.goNamed(RoutePath.forgetOtpScreen, extra: email);
      } else {
        forgotPasswordLoadingMethod(false);
        AppToast.error(
          message:
              response.data?["message"]?.toString() ?? "Forgot Password Failed",
        );
      }
    } catch (err) {
      forgotPasswordLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }

  // // ================== Verify OTP Section ===================

  // final resetVerifyOtpLoading = false.obs;
  // bool resetVerifyOtpLoadingMethod(bool status) =>
  //     resetVerifyOtpLoading.value = status;
  // Future<void> resetVerifyOtp({
  //   required String otp,
  //   required String purpose,
  //   required String token,
  // }) async {
  //   try {
  //     resetVerifyOtpLoadingMethod(true);

  //     final body = {"otp": otp.trim(), "purpose": purpose};

  //     AppConfig.logger.i(body);

  //     final response = await apiClient.post(
  //       url: ApiUrls.resetPassword(),
  //       body: body,
  //       token: token,
  //     );

  //     AppConfig.logger.i(response.data);

  //     if (response.statusCode == 200) {
  //       resetVerifyOtpLoadingMethod(false);
  //       AppToast.success(
  //         message:
  //             response.data?["message"].toString() ?? "Verify OTP Successful",
  //       );
  //       AppRouter.route.goNamed(RoutePath.resetPasswordScreen, extra: token);
  //     } else {
  //       resetVerifyOtpLoadingMethod(false);
  //       AppToast.error(
  //         message: response.data?["message"].toString() ?? "Verify OTP Failed",
  //       );
  //     }
  //   } catch (err) {
  //     resetVerifyOtpLoadingMethod(false);
  //     AppConfig.logger.e(err);
  //     AppToast.error(message: "Something went wrong");
  //   }
  // }

  // ================== Reset Password Section ===================

  final resetPasswordLoading = false.obs;
  bool resetPasswordLoadingMethod(bool status) =>
      resetPasswordLoading.value = status;
  Future<void> resetPassword({required Map<String, dynamic> body}) async {
    try {
      resetPasswordLoadingMethod(true);

      AppConfig.logger.i(body);

      final response = await apiClient.post(
        url: ApiUrls.resetPassword(),
        body: body,
      );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        resetPasswordLoadingMethod(false);

        AppToast.success(
          message:
              response.data?["message"]?.toString() ??
              "Reset Password Successful",
        );

        AppRouter.route.goNamed(RoutePath.loginScreen);
      } else {
        resetPasswordLoadingMethod(false);
        AppToast.error(
          message:
              response.data?["message"]?.toString() ?? "Reset Password Failed",
        );
      }
    } catch (err) {
      resetPasswordLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }
}
