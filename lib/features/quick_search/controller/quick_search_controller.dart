import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';
import 'package:weather_app/features/result/model/result_summary_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo;

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

  Future<void> searchAndCalculate() async {
    final input = searchController.text.trim();

    if (input.isEmpty) {
      AppToast.error(message: 'Please enter GPS Coordinates or Address');
      return;
    }

    final coordRegex = RegExp(
      r'^([-+]?\d{1,2}(?:\.\d+)?)\s*,\s*([-+]?\d{1,3}(?:\.\d+)?)$',
    );
    final match = coordRegex.firstMatch(input);

    double? lat;
    double? lon;

    if (match != null) {
      lat = double.tryParse(match.group(1)!);
      lon = double.tryParse(match.group(2)!);

      if (lat == null || lon == null) {
        AppToast.error(message: 'Invalid coordinate format.');
        return;
      }

      if (lat < -90 || lat > 90) {
        AppToast.error(message: 'Latitude must be between -90 and 90.');
        return;
      }
      if (lon < -180 || lon > 180) {
        AppToast.error(message: 'Longitude must be between -180 and 180.');
        return;
      }
    } else {
      reverseGeocodeLoading.value = true;
      try {
        final locations = await geo.locationFromAddress(input);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lon = locations.first.longitude;
        } else {
          throw Exception('No results from native geocoding');
        }
      } catch (e) {
        AppConfig.logger.w(
          'Native geocoding failed: $e, falling back to Google Maps API',
        );
        try {
          final apiKey = AppConfig.googleMapKey;
          final url = Uri.parse(
            "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(input)}&key=$apiKey",
          );
          final response = await http.get(url);

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['status'] == 'OK') {
              final results = data['results'] as List;
              if (results.isNotEmpty) {
                final location = results[0]['geometry']['location'];
                lat = (location['lat'] as num).toDouble();
                lon = (location['lng'] as num).toDouble();
              } else {
                AppToast.error(message: 'Address not found.');
                reverseGeocodeLoading.value = false;
                return;
              }
            } else {
              AppConfig.logger.e('Google Geocoding API error: ${data}');
              AppToast.error(message: 'Address not found or invalid.');
              reverseGeocodeLoading.value = false;
              return;
            }
          } else {
            AppConfig.logger.e(
              'Google Geocoding API HTTP error: ${response.statusCode}',
            );
            AppToast.error(message: 'Address not found or invalid.');
            reverseGeocodeLoading.value = false;
            return;
          }
        } catch (fallbackErr) {
          AppConfig.logger.e("Fallback geocoding failed: $fallbackErr");
          AppToast.error(
            message: 'Geocoding failed: Address not found or invalid.',
          );
          reverseGeocodeLoading.value = false;
          return;
        }
      }
    }

    final body = <String, dynamic>{"lat": lat, "lon": lon};

    final date = dateController.text.trim();
    if (date.isNotEmpty) {
      body["observationDate"] = date;
    }

    // Call the existing calculate method which handles its own loading state cleanup
    await calculate(body: body);
  }

  /// Single-step flow:
  /// POST /evaluations/calculate {lat, lon, observationDate}
  ///         → ResultSummaryModel
  Future<void> calculate({required Map<String, dynamic> body}) async {
    // Only set loading to true if it wasn't already set by searchAndCalculate
    if (!reverseGeocodeLoading.value) {
      reverseGeocodeLoading.value = true;
    }

    try {
      AppConfig.logger.i('calculate API call: $body');

      final calcResponse = await apiClient.post(
        url: ApiUrls.calculate(),
        body: body,
      );

      AppConfig.logger.i('calculate response: ${calcResponse.data}');

      if (calcResponse.statusCode == 200 || calcResponse.statusCode == 201) {
        final parsed = ResultSummaryModel.fromJson(calcResponse.data);
        // Store result in HomeController so ResultScreen & ResultSummary widgets
        // both read from the same single source of truth.
        Get.find<HomeController>().resultSummaryModel.value = parsed;
        resultSummaryModel.value = parsed;
        reverseGeocodeLoading.value = false;

        final successMsg = calcResponse.data['message']?.toString();
        AppToast.success(
          message:
              (successMsg == null || successMsg == 'null' || successMsg.isEmpty)
              ? 'Location calculated successfully'
              : successMsg,
        );

        // Pass lat/lon so ResultScreen can pin the marker correctly
        final lat = (body['lat'] as num?)?.toDouble();
        final lon = (body['lon'] as num?)?.toDouble();
        AppRouter.route.pushNamed(
          RoutePath.resultScreen,
          extra: <String, dynamic>{'latitude': lat, 'longitude': lon},
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
