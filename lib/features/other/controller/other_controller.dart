import 'package:get/get.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/local/local_service.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/other/model/terms_and_condition_model.dart' as tc;
import 'package:weather_app/features/result/model/result_summary_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';
import 'package:weather_app/utils/enum/app_enum.dart';

class OtherController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl<LocalService>();

  /// ============================= GET Terms Condition =====================================
  final Rx<tc.TermsConditionModel> termsConditionsData = tc.TermsConditionModel().obs;
  final Rx<ApiStatus> termsLoading = ApiStatus.completed.obs;
  void termsLoadingMethod(ApiStatus status) => termsLoading.value = status;

  Future<void> getTermsCondition() async {
    termsLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.termsAndConditions());
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        termsConditionsData.value = tc.TermsConditionModel.fromJson(response.data);
      } else if (response.data is String) {
        termsConditionsData.value = tc.TermsConditionModel(
          success: true,
          data: tc.Data(
            content: response.data,
            updatedAt: DateTime.now(),
          ),
        );
      }
      termsLoadingMethod(ApiStatus.completed);
    } else {
      AppConfig.logger.e(response.data);
      termsLoadingMethod(ApiStatus.error);
    }
  }

  /// ============================= GET Privacy Policy =====================================
  final Rx<tc.TermsConditionModel> privacyConditionsData =
      tc.TermsConditionModel().obs;
  final Rx<ApiStatus> privacyLoading = ApiStatus.completed.obs;
  void privacyLoadingMethod(ApiStatus status) => privacyLoading.value = status;

  Future<void> getPrivacyPolicy() async {
    privacyLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.privacyPolicy());
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        privacyConditionsData.value = tc.TermsConditionModel.fromJson(response.data);
      } else if (response.data is String) {
        privacyConditionsData.value = tc.TermsConditionModel(
          success: true,
          data: tc.Data(
            content: response.data,
            updatedAt: DateTime.now(),
          ),
        );
      }
      privacyLoadingMethod(ApiStatus.completed);
    } else {
      AppConfig.logger.e(response.data);
      privacyLoadingMethod(ApiStatus.error);
    }
  }

  /// ============================= GET FAQ =====================================
  final RxList<dynamic> faqData = [].obs;
  final RxBool faqLoading = false.obs;
  void faqLoadingMethod(bool status) => faqLoading.value = status;

  Future<void> contact({required Map<String, dynamic> body}) async {
    faqLoadingMethod(true);
    var response = await apiClient.post(url: ApiUrls.contact(), body: body);
    AppConfig.logger.i(body);
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      faqLoadingMethod(false);
      AppToast.success(message: response.data['message']);
      AppRouter.route.pop();
    } else {
      AppToast.error(message: response.data['message']);
      faqLoadingMethod(false);
    }
  }

  /// ============================= Patch Change Password =====================================
  final RxBool changePasswordLoading = false.obs;
  void changePasswordLoadingMethod(bool loading) =>
      changePasswordLoading.value = loading;

  Future<void> changePassword({required Map<String, dynamic> body}) async {
    changePasswordLoadingMethod(true);
    var response = await apiClient.post(
      url: ApiUrls.changePassword(),
      body: body,
    );
    AppConfig.logger.i(body);
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      changePasswordLoadingMethod(false);
      AppToast.success(message: response.data['message']);
      AppRouter.route.pop();
    } else {
      AppToast.error(
        message: response.data['message'] ?? "Something went wrong",
      );
      changePasswordLoadingMethod(false);
    }
  }

  final Rx<ResultSummaryModel> resultSummaryModel = ResultSummaryModel().obs;
  final RxBool calculateLoading = false.obs;
  void calculateLoadingMethod(bool loading) => calculateLoading.value = loading;

  Future<void> calculate({required Map<String, dynamic> body}) async {
    calculateLoadingMethod(true);
    var response = await apiClient.post(url: ApiUrls.calculate(), body: body);
    AppConfig.logger.i(body);
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      resultSummaryModel.value = ResultSummaryModel.fromJson(response.data);
      calculateLoadingMethod(false);
      AppToast.success(message: response.data['message']);
      AppRouter.route.pushNamed(
        RoutePath.resultScreen,
        extra: resultSummaryModel,
      );
    } else {
      AppConfig.logger.e(response.data);
      AppToast.error(message: response.data['message']);
      calculateLoadingMethod(false);
    }
  }
}
