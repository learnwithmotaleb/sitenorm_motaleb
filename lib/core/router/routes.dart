import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/auth/presentation/screen/active_otp_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/forget_otp_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/login_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:weather_app/subscriptions/paywall/paywall_screen.dart';
import 'package:weather_app/subscriptions/history/history_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/forget_password_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/reset_password_screen.dart';
import 'package:weather_app/features/auth/presentation/screen/welcome_back_screen.dart';
import 'package:weather_app/features/home/presentation/screen/home_screen.dart';
import 'package:weather_app/features/other/presentation/screen/reference_screen.dart';
import 'package:weather_app/features/quick_search/presentation/screen/quick_search_screen.dart';
import 'package:weather_app/features/other/presentation/screen/change_password_screen.dart';
import 'package:weather_app/features/other/presentation/screen/contact_and_support.dart';
import 'package:weather_app/features/other/presentation/screen/privacy_policy_screen.dart';
import 'package:weather_app/features/other/presentation/screen/setting_screen.dart';
import 'package:weather_app/features/other/presentation/screen/terms_and_condition_screen.dart';
import 'package:weather_app/features/profile/presentation/screen/edit_profile_screen.dart';
import 'package:weather_app/features/profile/presentation/screen/profile_screen.dart';
import 'package:weather_app/features/result/presentation/screen/result_screen.dart';
import 'package:weather_app/features/result_summary/presentation/screen/result_summary.dart';
import 'package:weather_app/features/save/presentation/screen/save_details_screen.dart';
import 'package:weather_app/features/save/presentation/screen/save_screen.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

import '../../features/splash/screen/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter initRoute = GoRouter(
    initialLocation: RoutePath.splashScreen.addBasePath,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: [
      ///======================= Initial Route =======================
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SplashScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.signUpScreen,
        path: RoutePath.signUpScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SignUpScreen(),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.loginScreen,
        path: RoutePath.loginScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const LoginScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.activeOtpScreen,
        path: RoutePath.activeOtpScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final map = (extra is Map<String, dynamic>) ? extra : {};

          final email = map['email'] as String?;
          return _buildPageWithAnimation(
            child: ActiveOtpScreen(email: email ?? ""),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.forgetPasswordScreen,
        path: RoutePath.forgetPasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ForgetPasswordScreen(),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.forgetOtpScreen,
        path: RoutePath.forgetOtpScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final email = extra as String?;
          return _buildPageWithAnimation(
            child: ForgetOtpScreen(email: email ?? ""),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.resetPasswordScreen,
        path: RoutePath.resetPasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final map = (extra is Map<String, dynamic>) ? extra : {};

          final email = map['email'] as String?;
          final otp = map['otp'] as String?;
          return _buildPageWithAnimation(
            child: ResetPasswordScreen(email: email ?? "", otp: otp ?? ""),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.welcomeBackScreen,
        path: RoutePath.welcomeBackScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const WelcomeBackScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.homeScreen,
        path: RoutePath.homeScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const HomeScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.paywallScreen,
        path: RoutePath.paywallScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const PaywallScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.historyScreen,
        path: RoutePath.historyScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const HistoryScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.quickSearchScreen,
        path: RoutePath.quickSearchScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const QuickSearchScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.resultScreen,
        path: RoutePath.resultScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          double? latitude;
          double? longitude;

          if (extra is Map<String, dynamic>) {
            latitude = extra['latitude'] as double?;
            longitude = extra['longitude'] as double?;
          }

          return _buildPageWithAnimation(
            child: ResultScreen(latitude: latitude, longitude: longitude),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.resultSummaryScreen,
        path: RoutePath.resultSummaryScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ResultSummaryScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.saveScreen,
        path: RoutePath.saveScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SaveScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.profileScreen,
        path: RoutePath.profileScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ProfileScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.editProfileScreen,
        path: RoutePath.editProfileScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const EditProfileScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.settingScreen,
        path: RoutePath.settingScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SettingScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.changePasswordScreen,
        path: RoutePath.changePasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ChangePasswordScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.contactSupportScreen,
        path: RoutePath.contactSupportScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ContactAndSupportScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.termsAndConditionScreen,
        path: RoutePath.termsAndConditionScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const TermsAndConditionScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.privacyPolicyScreen,
        path: RoutePath.privacyPolicyScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const PrivacyPolicyScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.referenceScreen,
        path: RoutePath.referenceScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ReferenceScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.saveDetailsScreen,
        path: RoutePath.saveDetailsScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final id = extra as String? ?? "";
          return _buildPageWithAnimation(
            child: SaveDetailsScreen(id: id),
            state: state,
          );
        },
      ),
      /*GoRoute(
        name: RoutePath.categoryEventsScreen,
        path: RoutePath.categoryEventsScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final map = (extra is Map<String, dynamic>) ? extra : {};

          final id = map['id'] as String? ?? '';
          final title = map['title'] as String? ?? '';

          return _buildPageWithAnimation(
            child: CategoryEventsScreen(id: id, title: title),
            state: state,
          );
        },
      ),*/
    ],
  );

  static CustomTransitionPage _buildPageWithAnimation({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static GoRouter get route => initRoute;
}
