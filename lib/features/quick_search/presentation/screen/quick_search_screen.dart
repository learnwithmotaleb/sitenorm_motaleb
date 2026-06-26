import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';
import 'package:weather_app/helper/date_converter/date_converter.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/helper/validator/text_field_validator.dart';
import 'package:weather_app/share/widgets/align/custom_align_text.dart';
import 'package:weather_app/share/widgets/button/custom_button.dart';
import 'package:weather_app/share/widgets/text_field/custom_text_field.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/quick_search/controller/quick_search_controller.dart';
import 'package:get/get.dart';

class QuickSearchScreen extends StatefulWidget {
  const QuickSearchScreen({super.key});

  @override
  State<QuickSearchScreen> createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends State<QuickSearchScreen> {
  final QuickSearchController _controller = Get.put(QuickSearchController());
  late final HomeController _homeController;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use putIfAbsent so QuickSearch works even if Home was never visited
    _homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
  }

  @override
  void dispose() {
    _dateController.dispose();
    // Do NOT call _controller.dispose() — GetX manages the lifecycle
    // of controllers registered via Get.put(). Manually disposing causes
    // crashes in release mode.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Quick Search',
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),

            Text(
              'Enter GPS Coordinates or Address',
              style: context.bodyMedium.copyWith(fontSize: 14),
            ),

            const Gap(16),

            CustomTextField(
              controller: _controller.searchController,
              hintText: '33.77261, -95.81259',
              validator: TextFieldValidator.required(
                errorText: 'Please enter GPS Coordinates or Address',
              ),
            ),
            const Gap(16),
            CustomAlignText(
              text: 'e.g. 33.77261, -95.81259 or address here',
              textAlign: TextAlign.left,
              style: context.bodyMedium.copyWith(fontSize: 14),
            ),
            const Gap(16),
            CustomTextField(
              controller: _dateController,
              hintText: "Observation Date",
              fillColor: AppColors.darkBackground,
              readOnly: true,
              onTap: () async {
                final formattedDate = await DateConverter.selectDate(context);
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
            Obx(
              () => GestureDetector(
                onTap: _controller.isLoadingLocation.value
                    ? null
                    : _controller.getCurrentLocation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _controller.isLoadingLocation.value
                          ? AppColors.primaryText.withValues(alpha: 0.5)
                          : AppColors.primaryText,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: _controller.isLoadingLocation.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryText,
                                  ),
                                ),
                              ),
                              const Gap(12),
                              Text(
                                'Getting Location...',
                                style: context.titleMedium.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location,
                                color: AppColors.primaryText,
                                size: 20,
                              ),
                              const Gap(8),
                              Text(
                                'Use Current Location',
                                style: context.titleMedium.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const Gap(20),

            Obx(
              () => CustomButton(
                text: 'Search',
                isLoading: _controller.reverseGeocodeLoading.value,
                onTap: () {
                  final coordinates = _controller.searchController.text.trim();

                  if (coordinates.isEmpty) {
                    AppToast.error(
                      message: 'Please enter GPS coordinates or address',
                    );
                    return;
                  }

                  final parts = coordinates.split(',');
                  if (parts.length == 2) {
                    try {
                      final latitude = double.parse(parts[0].trim());
                      final longitude = double.parse(parts[1].trim());

                      final body = <String, dynamic>{
                        "lat": latitude,
                        "lon": longitude,
                      };

                      final date = _dateController.text.trim();
                      if (date.isNotEmpty) {
                        body["observationDate"] = date;
                      }

                      // Use QuickSearchController's own calculate method
                      _controller.calculate(body: body);
                    } catch (e) {
                      AppToast.error(
                        message:
                            'Invalid coordinate format. Use: latitude, longitude',
                      );
                    }
                  } else {
                    AppToast.error(
                      message:
                          'Invalid coordinate format. Use: latitude, longitude',
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 40),

            // Climate Reference Period
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Climate Reference Period: 1971-2000',
                  style: context.bodySmall.copyWith(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
