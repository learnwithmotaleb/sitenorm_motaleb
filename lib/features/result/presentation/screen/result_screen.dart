import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';

import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class ResultScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const ResultScreen({super.key, this.latitude, this.longitude});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = {};

  // Default location (Pasadena, CA) if no coordinates provided
  static const LatLng _defaultLocation = LatLng(34.147785, -118.144516);

  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();

    // resultSummaryModel in HomeController is always the source of truth.
    // widget.latitude/longitude are passed as extras from both Home and QuickSearch.
    final resultData = _homeController.resultSummaryModel.value.data;
    final lat =
        widget.latitude ??
        resultData?.location?.lat ??
        _defaultLocation.latitude;
    final lng =
        widget.longitude ??
        resultData?.location?.lon ??
        _defaultLocation.longitude;

    _initialCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12.0,
    );

    _markers = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: resultData?.county ?? 'Selected Location',
          snippet: '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
        ),
      ),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showResultInfo();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // /// Search for location by coordinates
  // Future<void> _searchLocation() async {
  //   final coordinates = _searchController.text.trim();

  //   if (coordinates.isEmpty) {
  //     _showSnackBar('Please enter GPS coordinates', isError: true);
  //     return;
  //   }

  //   // Parse coordinates (format: "latitude, longitude")
  //   final parts = coordinates.split(',');
  //   if (parts.length == 2) {
  //     try {
  //       final latitude = double.parse(parts[0].trim());
  //       final longitude = double.parse(parts[1].trim());

  //       await _updateMapLocation(latitude, longitude, 'Searched Location');
  //       _showSnackBar('Location found!', isError: false);
  //     } catch (e) {
  //       _showSnackBar(
  //         'Invalid coordinate format. Use: latitude, longitude',
  //         isError: true,
  //       );
  //     }
  //   } else {
  //     _showSnackBar(
  //       'Invalid coordinate format. Use: latitude, longitude',
  //       isError: true,
  //     );
  //   }
  // }

  void _showResultInfo() {
    final resultData = _homeController.resultSummaryModel.value.data;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.2,
      ), // Optional: lighter barrier for map visibility
      builder: (context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF101010), // Dark background matching image
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ---------- HANDLE / INDICATOR ----------
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(20.h),

            /// ---------- TITLE ----------
            Text(
              AppStrings.result.tr, // "Result"
              style: context.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(4.h),
            Text(
              resultData?.period ?? "March - April 2025",
              style: context.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            Gap(24.h),

            /// ---------- RESULT CARD ----------
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E), // Slightly lighter dark
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon Circle
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D7B92), // Teal color
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cloud_outlined,
                          color: Colors.white,
                          size: 24.sp,
                        ), // Replace with SVG if needed
                      ),
                      Gap(12.w),
                      // WET Text
                      Text(
                        resultData?.simpleLabel?.toUpperCase() ??
                            AppStrings.wet.tr, // "WET"
                        style: context.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  // Score
                  Text(
                    "${AppStrings.weightedScore.tr} (${resultData?.totalScore ?? 0} out of ${resultData?.maxScore ?? 0})",
                    style: context.bodyMedium.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Gap(24.h),

            /// ---------- BUTTON ----------
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(RoutePath.resultSummaryScreen);
                },

                child: Text(
                  AppStrings.fullDetails.tr, // "Full Details"
                  style: context.titleMedium.copyWith(
                    color: AppColors.successColor,
                  ),
                ),
              ),
            ),
            Gap(24.h),

            /// ---------- FOOTER ----------
            Text(
              "${AppStrings.wetsStation.tr}: ${resultData?.station?.name ?? 'Unknown'}",
              style: context.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
            Gap(4.h),
            Text(
              "${AppStrings.climateReferencePeriod.tr}: ${resultData?.climateReferencePeriod ?? '1971-2000'}",
              style: context.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
            Gap(10.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showResultInfo();
        },
        child: const Icon(Icons.info),
      ),
      body: Stack(
        children: [
          /// ---------- GOOGLE MAP ----------
          GoogleMap(
            mapType: MapType.normal, // Or dark mode style json if available
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          /// ---------- BACK BUTTON ----------
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E), // Dark circle
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          /// ---------- SEARCH BAR ----------
          // Positioned(
          //   top: 50.h,
          //   left: 80.w,
          //   right: 20.w,
          //   child: Container(
          //     height: 44.h,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF1C1C1E),
          //       borderRadius: BorderRadius.circular(22.r),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withValues(alpha: 0.3),
          //           blurRadius: 8,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: GooglePlaceAutoCompleteTextField(
          //       textEditingController: _searchController,
          //       googleAPIKey:
          //           "AIzaSyC_qKHmzl-HHB9hr8-fWGmhETSVR2H0894", // TODO: Add your Google API key
          //       inputDecoration: InputDecoration(
          //         hintText: 'Search location (e.g., Dhaka, Bangladesh)',
          //         hintStyle: TextStyle(
          //           color: Colors.grey.withValues(alpha: 0.6),
          //           fontSize: 14.sp,
          //         ),
          //         prefixIcon: const Icon(
          //           Icons.search,
          //           color: AppColors.primaryText,
          //         ),
          //         suffixIcon: _searchController.text.isNotEmpty
          //             ? IconButton(
          //                 icon: const Icon(
          //                   Icons.clear,
          //                   color: Colors.grey,
          //                   size: 20,
          //                 ),
          //                 onPressed: () {
          //                   setState(() {
          //                     _searchController.clear();
          //                   });
          //                 },
          //               )
          //             : null,
          //         border: InputBorder.none,
          //         contentPadding: EdgeInsets.symmetric(
          //           horizontal: 16.w,
          //           vertical: 12.h,
          //         ),
          //       ),
          //       textStyle: const TextStyle(color: Colors.white),
          //       debounceTime: 600,
          //       isLatLngRequired: true,
          //       getPlaceDetailWithLatLng: (Prediction prediction) async {
          //         // Get place details with coordinates
          //         if (prediction.lat != null && prediction.lng != null) {
          //           final lat = double.parse(prediction.lat!);
          //           final lng = double.parse(prediction.lng!);

          //           await _updateMapLocation(
          //             lat,
          //             lng,
          //             prediction.description ?? 'Selected Location',
          //           );

          //           _showSnackBar('Location found!', isError: false);
          //         }
          //       },
          //       itemClick: (Prediction prediction) {
          //         _searchController.text = prediction.description ?? '';
          //         _searchController.selection = TextSelection.fromPosition(
          //           TextPosition(offset: prediction.description?.length ?? 0),
          //         );
          //       },
          //       seperatedBuilder: const Divider(height: 1, color: Colors.grey),
          //       containerHorizontalPadding: 10,
          //       itemBuilder: (context, index, Prediction prediction) {
          //         return Container(
          //           padding: const EdgeInsets.all(10),
          //           color: const Color(0xFF1C1C1E),
          //           child: Row(
          //             children: [
          //               const Icon(
          //                 Icons.location_on,
          //                 color: AppColors.primaryText,
          //               ),
          //               const SizedBox(width: 10),
          //               Expanded(
          //                 child: Text(
          //                   prediction.description ?? '',
          //                   style: const TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //       isCrossBtnShown: false,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
