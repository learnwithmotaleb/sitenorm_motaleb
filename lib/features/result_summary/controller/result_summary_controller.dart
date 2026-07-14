import 'package:get/get.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/result/model/result_summary_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';

class ResultSummaryController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final Rx<ResultSummaryModel> resultSummaryModel = ResultSummaryModel().obs;
  final RxBool saveStationsLoading = false.obs;

  Future<void> saveStations({required Map<String, dynamic> body}) async {
    saveStationsLoading.value = true;
    try {
      // Strip fields rejected by the save endpoint's enum validation.
      // The backend does not accept stationMethod="decoupled" (or unknown enum
      // values), so we remove it — the API will re-derive it on its own.
      final sanitizedBody = Map<String, dynamic>.from(body)
        ..remove('stationMethod')
        ..remove(
          'stationLog',
        ); // stationLog is also read-only, not needed for save

      var response = await apiClient.post(
        url: ApiUrls.saveStations(),
        body: sanitizedBody,
      );

      AppConfig.logger.i(body);
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        saveStationsLoading.value = false;

        // Extract message safely
        final successMsg = response.data['message']?.toString();
        AppToast.success(
          message:
              (successMsg == null || successMsg == "null" || successMsg.isEmpty)
              ? "Evaluation saved successfully"
              : successMsg,
        );

        AppRouter.route.pushNamed(RoutePath.saveScreen);
      } else {
        AppConfig.logger.e(response.data);
        final msg =
            response.data['message']?.toString() ?? "Failed to save evaluation";
        AppToast.error(message: msg);
        saveStationsLoading.value = false;
      }
    } catch (e) {
      AppConfig.logger.e(e);
      AppToast.error(message: "An error occurred while saving.");
      saveStationsLoading.value = false;
    }
  }
}
