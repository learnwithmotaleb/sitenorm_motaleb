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

  /// Two-step flow:
  /// Step 1: POST /stations/reverse-geocode {lat, lon, observationDate}
  ///         → {countyFips, countyName, stateCode, ...}
  /// Step 2: POST /evaluations/calculate-by-location {state, county, countyFips, observationDate}
  ///         → ResultSummaryModel
  Future<void> calculate({required Map<String, dynamic> body}) async {
    reverseGeocodeLoading.value = true;

    try {
      AppConfig.logger.i('Step 1 — reverse-geocode: $body');

      // Step 1: Resolve lat/lon to county info
      final geoResponse = await apiClient.post(
        url: ApiUrls.reverseGeocode(),
        body: body,
      );

      AppConfig.logger.i('reverse-geocode response: ${geoResponse.data}');

      if (geoResponse.statusCode != 200 && geoResponse.statusCode != 201) {
        final msg =
            geoResponse.data['message']?.toString() ??
            'Failed to resolve location';
        AppToast.error(message: msg);
        reverseGeocodeLoading.value = false;
        return;
      }

      final geoData = geoResponse.data['data'] as Map<String, dynamic>? ?? {};
      final countyFips = geoData['countyFips']?.toString() ?? '';
      final countyName = geoData['countyName']?.toString() ?? '';
      final stateCode = geoData['stateCode']?.toString() ?? '';

      if (countyFips.isEmpty || stateCode.isEmpty) {
        AppToast.error(message: 'Could not determine county from coordinates.');
        reverseGeocodeLoading.value = false;
        return;
      }

      // Step 2: Calculate using derived county info
      final calculateBody = <String, dynamic>{
        'state': stateCode,
        'county': countyName,
        'countyFips': countyFips,
      };

      if (body['observationDate'] != null) {
        calculateBody['observationDate'] = body['observationDate'];
      }

      AppConfig.logger.i('Step 2 — calculate-by-location: $calculateBody');

      final calcResponse = await apiClient.post(
        url: ApiUrls.calculateByLocation(),
        body: calculateBody,
      );

      AppConfig.logger.i(
        'calculate-by-location response: ${calcResponse.data}',
      );

      if (calcResponse.statusCode == 200 || calcResponse.statusCode == 201) {
        resultSummaryModel.value = ResultSummaryModel.fromJson(
          calcResponse.data,
        );
        reverseGeocodeLoading.value = false;
        final successMsg = calcResponse.data['message']?.toString();
        AppToast.success(
          message:
              (successMsg == null || successMsg == 'null' || successMsg.isEmpty)
              ? 'Location calculated successfully'
              : successMsg,
        );
        AppRouter.route.pushNamed(
          RoutePath.resultScreen,
          extra: resultSummaryModel,
        );
      } else {
        AppConfig.logger.e(calcResponse.data);
        final msg =
            calcResponse.data['message']?.toString() ?? 'Something went wrong';
        AppToast.error(message: msg);
        reverseGeocodeLoading.value = false;
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
      AppToast.error(message: 'An error occurred: ${e.toString()}');
      reverseGeocodeLoading.value = false;
    }
  }
}
