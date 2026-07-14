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
    final saveController = Get.find<SaveController>();

    return Obx(() {
      final data = saveController.saveDetailsModel.value.data;
      final info = data?.additionalInfo;
      final station = data?.station;
      // In case we want to show rainfall station if it becomes available in saved data
      final rainfallStation = data?.rainfallStation;
      final stationMethod = data?.stationMethod;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  context,
                  icon: Icons.cell_tower,
                  label: 'WETS Station',
                  value: info?.wetsStation ?? station?.name ?? 'N/A',
                ),
                Gap(16.h),

                // Rainfall Station (if decoupled)
                if (rainfallStation != null) ...[
                  _buildInfoRow(
                    context,
                    icon: Icons.water_drop_outlined,
                    label: 'Rainfall Station',
                    value:
                        '${rainfallStation.name ?? 'N/A'} (${_formatDistance(rainfallStation.distance)} mi)',
                  ),
                  if (stationMethod == 'decoupled') ...[
                    Gap(4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 32.w),
                      child: Text(
                        'Historical normals from WETS station; recent rainfall from this station.',
                        style: context.bodySmall.copyWith(
                          color: AppColors.secondaryText,
                          fontSize: 11.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  Gap(16.h),
                ],

                _buildInfoRow(
                  context,
                  icon: Icons.location_on_outlined,
                  label: AppStrings.location.tr,
                  value: info?.location ?? 'N/A',
                ),
                Gap(16.h),
                _buildInfoRow(
                  context,
                  icon: Icons.layers_outlined,
                  label: AppStrings.soilMapUnit.tr,
                  value: info?.soilMapUnit ?? 'N/A',
                ),
                Gap(16.h),
                _buildInfoRow(
                  context,
                  icon: Icons.eco_outlined,
                  label:
                      '${AppStrings.growingSeason.tr} (${info?.growingSeasonThreshold ?? 'N/A'})',
                  value: info?.growingSeason ?? 'N/A',
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
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
                label,
                style: context.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
              Gap(2.h),
              Text(
                value,
                style: context.bodyMedium.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDistance(dynamic distance) {
    if (distance == null) return '?';
    if (distance is num) return distance.toStringAsFixed(1);
    if (distance is String) {
      final parsed = double.tryParse(distance);
      return parsed != null ? parsed.toStringAsFixed(1) : distance;
    }
    return '?';
  }
}
