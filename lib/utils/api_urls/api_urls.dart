import 'package:weather_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;
  //=========== Auth Section ============
  static String login() => '$base/auth/signin';
  static String signUp() => '$base/auth/signup';
  static String emailVerify() => '$base/auth/verify-otp';
  static String resendOtp() => '$base/auth/resend-otp';
  static String forgotPassword() => '$base/auth/forgot-password';
  static String resetPassword() => '$base/auth/reset-password';
  static String logout() => '$base/users/logout';

  //=========== User Section ===========

  static String changePassword() => '$base/users/change-password';
  static String getProfile() => '$base/users/profile';
  static String editProfile() => '$base/users/profile';
  static String updateAvatar() => '$base/users/avatar';

  static String privacyPolicy() => '$base/settings/privacy';
  static String termsAndConditions() => '$base/settings/terms';
  static String contact() => '$base/settings/contact';

  static String getStates() => '$base/stations/states';
  static String getCounties({required String stateCode}) =>
      '$base/stations/counties/$stateCode';
  static String calculateByLocation() =>
      '$base/evaluations/calculate-by-location';

  static String reverseGeocode() => '$base/stations/reverse-geocode';
  static String saveStations() => '$base/evaluations/save';
  static String calculate() => '$base/evaluations/calculate';
  static String getSavedStations() => '$base/evaluations/saved';
  static String getSaveDetails({required String id})=> '$base/evaluations/$id';
}
