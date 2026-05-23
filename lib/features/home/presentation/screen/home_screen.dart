import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/custom_assets/assets.gen.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/helper/date_converter/date_converter.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:weather_app/share/widgets/text_field/custom_text_field.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';
import 'package:weather_app/features/home/model/state_model.dart'
    as state_model;
import 'package:weather_app/features/home/model/counties_model.dart'
    as counties_model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = Get.put(HomeController());

  final ValueNotifier<state_model.StateModelDatum?> selectedState =
      ValueNotifier<state_model.StateModelDatum?>(null);
  final ValueNotifier<counties_model.Datum?> selectedCounty =
      ValueNotifier<counties_model.Datum?>(null);
  final ValueNotifier<String?> selectedDate = ValueNotifier<String?>(null);
  final TextEditingController _fipsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homeController.getStates();
  }

  @override
  void dispose() {
    _fipsController.dispose();
    selectedState.dispose();
    selectedCounty.dispose();
    selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.successColor,
          backgroundColor: const Color(0xFF1C1C1E),
          onRefresh: () async {
            selectedState.value = null;
            selectedCounty.value = null;
            selectedDate.value = null;
            _fipsController.clear();
            _dateController.clear();
            await _homeController.getStates();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      context.pushNamed(RoutePath.profileScreen);
                    },
                  ),
                ),
                Gap(20.h),

                /// ---------- HEADER ----------
                Center(
                  child: Assets.images.applogo.image(
                    width: 150.w,
                    height: 150.h,
                  ),
                ),
                Gap(40.h),

                /// ---------- FORM CONTAINER ----------
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E), // Dark surface
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      /// ---------- STATE DROPDOWN ----------
                      Obx(() {
                        final states =
                            _homeController.stateModel.value.data ?? [];
                        return ValueListenableBuilder<
                          state_model.StateModelDatum?
                        >(
                          valueListenable: selectedState,
                          builder: (context, value, child) {
                            return CustomDropdownField<
                              state_model.StateModelDatum
                            >(
                              hintText: AppStrings.selectState.tr,
                              items: states,
                              value: value,
                              onChanged: (newValue) {
                                selectedState.value = newValue;
                                selectedCounty.value = null; // cascade clearing
                                if (newValue?.code != null) {
                                  _homeController.getCounties(
                                    stateCode: newValue!.code!,
                                  );
                                }
                              },
                              fillColor: AppColors.darkBackground,
                              labelBuilder: (item) => item.code ?? '',
                            );
                          },
                        );
                      }),
                      Gap(16.h),

                      /// ---------- COUNTY DROPDOWN ----------
                      Obx(() {
                        final counties =
                            _homeController.countiesModel.value.data ?? [];
                        return ValueListenableBuilder<counties_model.Datum?>(
                          valueListenable: selectedCounty,
                          builder: (context, value, child) {
                            return CustomDropdownField<counties_model.Datum>(
                              hintText: AppStrings.selectCounty.tr,
                              items: counties,
                              value: value,
                              onChanged: (newValue) {
                                selectedCounty.value = newValue;
                                if (newValue?.fips != null) {
                                  _fipsController.text = newValue!.fips!;
                                } else {
                                  _fipsController.clear();
                                }
                              },
                              fillColor: AppColors.darkBackground,
                              labelBuilder: (item) => item.name ?? '',
                            );
                          },
                        );
                      }),
                      Gap(16.h),
                      CustomTextField(
                        controller: _dateController,
                        hintText: "Observation Date",
                        fillColor: AppColors.darkBackground,
                        readOnly: true,
                        onTap: () async {
                          final formattedDate = await DateConverter.selectDate(
                            context,
                          );
                          if (formattedDate != null) {
                            _dateController.text = formattedDate;
                          }
                        },
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      Gap(16.h),

                      /// ---------- DATE & FIPS ----------
                      // Row(
                      //   children: [
                      //     // Observation Date
                      //     // Expanded(
                      //     //   flex: 3,
                      //     //   child:
                      //     // ),
                      //     Gap(12.w),
                      //     // FIPS ID
                      //     Expanded(
                      //       child: Container(
                      //         height: 54.h,
                      //         padding: const EdgeInsets.symmetric(horizontal: 12),
                      //         decoration: BoxDecoration(
                      //           color: AppColors.darkBackground,
                      //           borderRadius: BorderRadius.circular(15),
                      //           border: Border.all(
                      //             color: AppColors.brandHoverColor,
                      //             width: 1.2,
                      //           ),
                      //         ),
                      //         child: TextField(
                      //           controller: _fipsController,
                      //           style: const TextStyle(color: Colors.white),
                      //           decoration: InputDecoration(
                      //             hintText: AppStrings.fipsId.tr,
                      //             hintStyle: const TextStyle(
                      //               color: AppColors.brandHoverColor,
                      //               fontSize: 14,
                      //             ),
                      //             border: InputBorder.none,
                      //             contentPadding: EdgeInsets.only(bottom: 8.h),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      CustomTextField(
                        controller: _fipsController,
                        hintText: "${AppStrings.fipsId.tr} (Optional)",
                        fillColor: AppColors.darkBackground,
                      ),
                      Gap(24.h),

                      /// ---------- SEARCH BUTTON ----------
                      Obx(
                        () => CustomButton(
                          text: AppStrings.search.tr,
                          isLoading:
                              _homeController.calculateByLocationLoading.value,
                          onTap: () {
                            _homeController.calculateByLocation(
                              body: {
                                "state": selectedState.value?.code,
                                "county": selectedCounty.value?.name,
                                "countyFips": _fipsController.text,
                                "observationDate": _dateController.text,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(24.h),

                /// ---------- CLIMATE REF PERIOD ----------
                Text(
                  "${AppStrings.climateReferencePeriod.tr}: 1971-2000",
                  style: context.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),

      /// ---------- QUICK SEARCH FAB ----------
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.pushNamed(RoutePath.quickSearchScreen);
            },
            backgroundColor: const Color(0xFF1C1C1E), // Dark surface
            shape: const CircleBorder(
              side: BorderSide(color: Color(0xFF2C2C2E)),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.successColor,
            ),
          ),
          Gap(4.h),
          Text(
            AppStrings.quickSearch.tr,
            style: context.bodySmall.copyWith(
              color: AppColors.successColor,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
