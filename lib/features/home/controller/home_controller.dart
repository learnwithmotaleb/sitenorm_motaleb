import 'package:get/get.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/home/model/counties_model.dart';
import 'package:weather_app/features/home/model/state_model.dart';
import 'package:weather_app/features/result/model/result_summary_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';
import 'package:weather_app/utils/enum/app_enum.dart';

import '../../../core/service/datasource/local/local_service.dart';
import '../../../subscriptions/services/revenue_cat_service.dart';

class HomeController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();

  // State
  final Rx<StateModel> stateModel = StateModel().obs;
  final Rx<ApiStatus> stateLoading = ApiStatus.completed.obs;
  void stateLoadingMethod(ApiStatus status) => stateLoading.value = status;
  final LocalService localService = sl();

  Future<void> getStates() async {
    stateLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.getStates());
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      stateModel.value = StateModel.fromJson(response.data);
      stateLoadingMethod(ApiStatus.completed);
    } else {
      AppConfig.logger.e(response.data);
      stateLoadingMethod(ApiStatus.error);
    }
  }

  // Counties
  final Rx<CountiesModel> countiesModel = CountiesModel().obs;
  final Rx<ApiStatus> countiesLoading = ApiStatus.completed.obs;
  void countiesLoadingMethod(ApiStatus status) =>
      countiesLoading.value = status;

  Future<void> getCounties({required String stateCode}) async {
    countiesLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(
      url: ApiUrls.getCounties(stateCode: stateCode),
    );
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      countiesModel.value = CountiesModel.fromJson(response.data);
      countiesLoadingMethod(ApiStatus.completed);
    } else {
      AppConfig.logger.e(response.data);
      countiesLoadingMethod(ApiStatus.error);
    }
  }

  //=============

  final Rx<ResultSummaryModel> resultSummaryModel = ResultSummaryModel().obs;
  final RxBool calculateByLocationLoading = false.obs;
  void calculateByLocationLoadingMethod(bool loading) =>
      calculateByLocationLoading.value = loading;

  Future<void> calculateByLocation({required Map<String, dynamic> body}) async {
    calculateByLocationLoadingMethod(true);
    var response = await apiClient.post(
      url: ApiUrls.calculateByLocation(),
      body: body,
    );
    AppConfig.logger.i(body);
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      resultSummaryModel.value = ResultSummaryModel.fromJson(response.data);
      calculateByLocationLoadingMethod(false);
      final successMsg = response.data['message']?.toString();
      AppToast.success(
        message:
            (successMsg == null || successMsg == "null" || successMsg.isEmpty)
            ? "Location fetched successfully"
            : successMsg,
      );
      AppRouter.route.pushNamed(
        RoutePath.resultScreen,
        extra: resultSummaryModel,
      );
    } else {
      AppConfig.logger.e(response.data);
      final msg =
          response.data['message']?.toString() ?? "Something went wrong";
      AppToast.error(message: msg);
      calculateByLocationLoadingMethod(false);
    }
  }

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
      final successMsg = response.data['message']?.toString();
      AppToast.success(
        message:
            (successMsg == null || successMsg == "null" || successMsg.isEmpty)
            ? "Calculation successful"
            : successMsg,
      );
      AppRouter.route.pushNamed(
        RoutePath.resultScreen,
        extra: resultSummaryModel,
      );
    } else {
      AppConfig.logger.e(response.data);
      final msg =
          response.data['message']?.toString() ?? "Something went wrong";
      AppToast.error(message: msg);
      calculateLoadingMethod(false);
    }
  }

  Future<void> checkSubscriptionStatus() async {
    final userId = await localService.getUserId();

    // If somehow there's no user logged in, go to login
    if (userId.isEmpty) {
      AppRouter.route.goNamed(RoutePath.loginScreen);
      return;
    }

    // Check subscription
    await RevenueCatService.instance.init(userId);
    final subscribed = await RevenueCatService.instance.isSubscribed();

    if (!subscribed) {
      // If not pro, kick them to paywall
      AppRouter.route.goNamed(RoutePath.paywallScreen);
    } else {
      // If pro, load the data
      getStates();
    }
  }
}
