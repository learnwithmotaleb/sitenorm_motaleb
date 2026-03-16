import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/result_summary/controller/result_summary_controller.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/features/result_summary/presentation/screen/widgets/additional_info_widget.dart';
import 'package:weather_app/features/result_summary/presentation/screen/widgets/rainfall_record_widget.dart';
import 'package:weather_app/features/result_summary/presentation/screen/widgets/result_summary_card.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';

class ResultSummaryScreen extends StatelessWidget {
  const ResultSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resultData = Get.find<HomeController>().resultSummaryModel.value.data;
    final controller = Get.put(ResultSummaryController());
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.resultSummary.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            const ResultSummaryCard(),
            Gap(24.h),
            const RainfallRecordWidget(),
            Gap(24.h),
            const AdditionalInfoWidget(),
            Gap(32.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: Obx(
                () => OutlinedButton(
                  onPressed: controller.saveStationsLoading.value
                      ? null
                      : () {
                          if (resultData != null) {
                            controller.saveStations(body: resultData.toJson());
                          } else {
                            AppToast.error(message: 'No data to save');
                          }
                        },
                  child: controller.saveStationsLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppStrings.save.tr),
                ),
              ),
            ),
            Gap(32.h),

            // Footer
            GestureDetector(
              onTap: () {
                context.pushNamed(RoutePath.referenceScreen);
              },
              child: Text(
                "${AppStrings.climateReferencePeriod.tr}: ${resultData?.climateReferencePeriod ?? '1971-2000'}",
                style: context.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
