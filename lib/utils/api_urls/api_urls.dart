import 'package:weather_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;
  //=========== Auth Section ============
  static String login() => '$base/auth/signin';
  static String signUp() => '$base/auth/signup';
  static String emailVerify() => '$base/auth/verify-otp';
  static String resendOtp() => '$base/auth/resend-otp';
  static String forgotPassword() => '$base/auth/forgot-password';
  static String verifyResetOtp() => '$base/auth/verify-reset-otp';
  static String resetPassword() => '$base/auth/reset-password';
  static String logout() => '$base/users/logout';

  //=========== User Section ===========
  static String changePassword() => '$base/users/change-password';
  static String getProfile() => '$base/users/profile';
  static String editProfile() => '$base/users/profile';
  static String updateAvatar() => '$base/users/avatar';
  static String deleteAccount() => '$base/users/delete-account';

  //=========== Evaluations Section ===========
  static String calculate() => '$base/evaluations/calculate';
  static String calculateByLocation() =>
      '$base/evaluations/calculate-by-location';
  static String saveStations() =>
      '$base/evaluations/save'; // Matches Postman: /evaluations/save
  static String getSavedStations() =>
      '$base/evaluations/saved'; // Matches Postman: /evaluations/saved
  static String getSaveDetails({required String id}) => '$base/evaluations/$id';
  static String deleteEvaluation({required String id}) =>
      '$base/evaluations/$id';
  static String adminGetAllEvaluations() => '$base/evaluations/admin/all';

  //=========== Stations Section ===========
  static String getStates() => '$base/stations/states';
  static String getCounties({required String stateCode}) =>
      '$base/stations/counties/$stateCode';
  static String getNearestStations() => '$base/stations/nearest';
  static String searchMoreStations() => '$base/stations/search-more';
  static String getStationsByCounty() => '$base/stations/by-county';
  static String reverseGeocode() => '$base/stations/reverse-geocode';

  //=========== Settings Section ===========
  static String getTermsStatic() => '$base/settings/terms';
  static String getPrivacyStatic() => '$base/settings/privacy';
  static String contact() => '$base/settings/contact';

  //=========== Manage (CMS) Section ===========
  static String addTermsConditions() => '$base/manage/add-terms-conditions';
  static String getTermsConditionsJson() => '$base/manage/get-terms-conditions';
  static String termsAndConditions() => '$base/manage/view-terms-conditions';
  static String deleteTermsConditions() =>
      '$base/manage/delete-terms-conditions';

  static String addPrivacyPolicy() => '$base/manage/add-privacy-policy';
  static String getPrivacyPolicyJson() => '$base/manage/get-privacy-policy';
  static String privacyPolicy() => '$base/manage/view-privacy-policy';
  static String deletePrivacyPolicy() => '$base/manage/delete-privacy-policy';

  static String addAboutUs() => '$base/manage/add-about-us';
  static String getAboutUs() => '$base/manage/get-about-us';
  static String deleteAboutUs() => '$base/manage/delete-about-us';

  static String addFaq() => '$base/manage/add-faq';
  static String updateFaq() => '$base/manage/update-faq';
  static String getFaq() => '$base/manage/get-faq';
  static String deleteFaq() => '$base/manage/delete-faq';

  static String addContactUs() => '$base/manage/add-contact-us';
  static String getContactUs() => '$base/manage/get-contact-us';
  static String deleteContactUs() => '$base/manage/delete-contact-us';

  static String submitSupport() => '$base/manage/support';
  static String listSupport() => '$base/manage/support';
  static String getSupportById({required String id}) =>
      '$base/manage/support/$id';

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return AppConfig.defaultProfile;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final uri = Uri.tryParse(AppConfig.baseURL);
    if (uri != null && uri.hasScheme) {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      return '${uri.origin}/$cleanPath';
    }
    return '$base/$path';
  }
}
