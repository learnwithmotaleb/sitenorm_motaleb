import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/result/model/result_summary_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';

class QuickSearchController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final RxBool isLoadingLocation = false.obs;

  @override
  void onClose() {
    searchController.dispose();
    dateController.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppToast.error(
          message: 'Location services are disabled. Please enable them.',
        );
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppToast.error(message: 'Location permissions are denied.');
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppToast.error(
          message:
              'Location permissions are permanently denied. Please enable them in settings.',
        );
        isLoadingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      searchController.text = '${position.latitude}, ${position.longitude}';
      AppToast.success(message: 'Location retrieved successfully!');
    } catch (e) {
      AppToast.error(message: 'Failed to get location: ${e.toString()}');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  final Rx<ResultSummaryModel> resultSummaryModel = ResultSummaryModel().obs;
  final RxBool reverseGeocodeLoading = false.obs;
  void reverseGeocodeLoadingMethod(bool loading) =>
      reverseGeocodeLoading.value = loading;

  Future<void> calculate({required Map<String, dynamic> body}) async {
    reverseGeocodeLoadingMethod(true);
    var response = await apiClient.post(url: ApiUrls.calculate(), body: body);
    AppConfig.logger.i(body);
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      resultSummaryModel.value = ResultSummaryModel.fromJson(response.data);
      reverseGeocodeLoadingMethod(false);
      AppToast.success(message: response.data['message']);
      AppRouter.route.pushNamed(
        RoutePath.resultScreen,
        extra: resultSummaryModel,
      );
    } else {
      AppConfig.logger.e(response.data);
      final msg =
          response.data['message']?.toString() ?? "Something went wrong";
      AppToast.error(message: msg);
      reverseGeocodeLoadingMethod(false);
    }
  }
}
