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
    final resultData = Get.find<SaveController>().saveDetailsModel.value.data;

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
                    decoration: const BoxDecoration(
                      color: AppColors.wefColor, // Teal color
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_outlined,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  Gap(12.w),
                  // WET Text
                  Text(
                    resultData?.determination?.toUpperCase() ??
                        AppStrings.wet.tr,
                    style: context.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Text(
                "${AppStrings.weightedScore.tr} (${resultData?.totalScore ?? 0} Out Of ${resultData?.maxScore ?? 0})",
                style: context.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Gap(4.h),
              Text(
                resultData?.period ?? "March - April 2025",
                style: context.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Color(0xFF14291B), // Dark Green pill background
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                AppStrings.evaluated.tr,
                style: context.labelMedium.copyWith(
                  color: AppColors.successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
