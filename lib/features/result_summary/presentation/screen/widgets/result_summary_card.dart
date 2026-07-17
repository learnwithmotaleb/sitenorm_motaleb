import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';

import '../../../../../helper/icons_healper/icons_helper.dart';

class ResultSummaryCard extends StatelessWidget {
  const ResultSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final resultData = homeController.resultSummaryModel.value.data;

      // Determine color and icon based on simpleLabel
      Color labelColor = AppColors.normalColor;
      IconData labelIcon = Icons.cloud_outlined;

      final label = resultData?.simpleLabel?.toUpperCase() ?? '';

      if (label == 'WET') {
        labelColor = AppColors.wefColor;
        labelIcon = Icons.water_drop_outlined;
      } else if (label == 'DRY') {
        labelColor = AppColors.dryColor;
        labelIcon = Icons.wb_sunny_outlined;
      } else if (label == 'NORMAL') {
        labelColor = AppColors.normalColor;
        labelIcon = Icons.cloud_outlined;
      } else if (label == 'UNKNOWN' || label.isEmpty) {
        labelColor = Colors.grey;
        labelIcon = Icons.help_outline;
      }

      return Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Circle
                    // Icon Circle
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: labelColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        getDeterminationIcon(resultData?.determination),
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    Gap(12.w),
                    // Determination label
                    Expanded(
                      child: Text(
                        resultData?.determination?.toUpperCase() ?? 'INSUFFICIENT DATA',
                        style: context.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                Text(
                  (resultData?.totalScore != null && resultData?.maxScore != null)
                      ? "${AppStrings.weightedScore.tr} (${resultData!.totalScore} Out Of ${resultData.maxScore})"
                      : "Not enough monthly data to calculate a score",
                  style: context.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                Gap(4.h),
                Text(
                  resultData?.period ?? 'No evaluation period available',
                  style: context.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                Gap(8.h),
                // County & State
                if (resultData?.county != null || resultData?.state != null)
                  Text(
                    '${resultData?.county ?? ''}, ${resultData?.state ?? ''}',
                    style: context.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
              ],
            ),
          ),
          // Conditional Evaluated / Incomplete badge (Bug #10)
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: resultData?.determination != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14291B),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        AppStrings.evaluated.tr,
                        style: context.labelMedium.copyWith(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2000),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Incomplete',
                        style: context.labelMedium.copyWith(
                          color: const Color(0xFFFFA500),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
