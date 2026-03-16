import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/save/controller/save_controller.dart';

class SaveAdditionalInfoWidget extends StatelessWidget {
  const SaveAdditionalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.find<SaveController>().saveDetailsModel.value.data;
    final info = data?.additionalInfo;
    final station = data?.station;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.additionalInformation.tr,
          style: context.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                context,
                icon: Icons.cell_tower,
                text: "WETS Station: ${info?.wetsStation ?? 'N/A'}",
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This is the closest station to site with all data",
                      style: context.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${_formatDistance(station?.distance)} miles from site",
                      style: context.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.h),
              _buildInfoRow(
                context,
                icon: Icons.location_on_outlined,
                text: "Location: ${info?.location ?? 'N/A'}",
              ),
              Gap(12.h),
              _buildInfoRow(
                context,
                icon: Icons.layers_outlined,
                text: "Soil Map Unit: ${info?.soilMapUnit ?? 'N/A'}",
              ),
              Gap(12.h),
              _buildInfoRow(
                context,
                icon: Icons.eco_outlined,
                text:
                    "Growing Season (${info?.growingSeasonThreshold ?? '50% > 28°F'})\n${info?.growingSeason ?? 'N/A'}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    Widget? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.successColor, size: 20.sp),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: context.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              if (subtitle != null) ...[
                Gap(4.h), // Add spacing
                subtitle,
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDistance(dynamic distance) {
    if (distance == null) return '_____';
    if (distance is num) return distance.toStringAsFixed(1);
    if (distance is String) {
      final parsed = double.tryParse(distance);
      return parsed != null ? parsed.toStringAsFixed(1) : distance;
    }
    return '_____';
  }
}
