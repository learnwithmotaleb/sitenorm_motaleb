import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/save/controller/save_controller.dart';

class SaveDetailsCard extends StatelessWidget {
  const SaveDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final saveController = Get.find<SaveController>();

    return Obx(() {
      final resultData = saveController.saveDetailsModel.value.data;

      Color labelColor = AppColors.normalColor;
      final label = resultData?.simpleLabel?.toUpperCase() ?? '';
      if (label == 'WET') {
        labelColor = AppColors.wefColor;
      } else if (label == 'DRY') {
        labelColor = AppColors.dryColor;
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Circle
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: labelColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_outlined,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    Gap(12.w),
                    // Determination Text
                    Expanded(
                      child: Text(
                        resultData?.determination?.toUpperCase() ?? '—',
                        style: context.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                if (resultData?.county != null || resultData?.state != null)
                  Text(
                    '${resultData?.county ?? ''}, ${resultData?.state ?? ''}',
                    style: context.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: resultData?.determination != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14291B), // Dark Green
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
                        color: const Color(0xFF2B2000), // Dark amber
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
          ],
        ),
      );
    });
  }
}
