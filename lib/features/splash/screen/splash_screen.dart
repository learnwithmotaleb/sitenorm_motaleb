import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/custom_assets/assets.gen.dart';
import 'package:weather_app/features/auth/controller/auth_controller.dart';
import 'package:weather_app/utils/color/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _handleSplash();
  }

  Future<void> _handleSplash() async {
    // Add a small delay for the splash animation
    await Future.delayed(const Duration(seconds: 2));
    _authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(child: Assets.images.applogo.image(width: 200, height: 200)),
    );
  }
}
