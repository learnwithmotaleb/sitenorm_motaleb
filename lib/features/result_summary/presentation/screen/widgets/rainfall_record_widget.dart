import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';
import 'package:weather_app/features/home/controller/home_controller.dart';

class RainfallRecordWidget extends StatelessWidget {
  const RainfallRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final resultData = homeController.resultSummaryModel.value.data;
      final records = resultData?.rainfallRecord ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.rainfallRecord.tr,
            style: context.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(12.h),
          // Header row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildHeaderCell(context, AppStrings.month.tr, flex: 2),
                _buildHeaderCell(context, "< 30%", flex: 1),
                _buildHeaderCell(context, AppStrings.avg.tr, flex: 1),
                _buildHeaderCell(context, "> 30%", flex: 1),
                _buildHeaderCell(
                  context,
                  AppStrings.rainfall.tr,
                  flex: 1,
                  isEnd: true,
                ),
              ],
            ),
          ),
          Gap(8.h),
          if (records.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'No rainfall data available',
                  style: context.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            )
          else
            ...records.map((record) {
              final cond = record.condition?.toLowerCase() ?? '';
              // If condition is null/empty, use neutral gray — never imply a category
              Color statusColor = cond.isEmpty
                  ? Colors.grey.shade600
                  : AppColors.normalColor;
              if (cond == 'wet') {
                statusColor = AppColors.wefColor;
              } else if (cond == 'dry') {
                statusColor = AppColors.dryColor;
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildRow(
                  context,
                  month: record.month ?? '—',
                  less30: record.less30 != null
                      ? record.less30!.toStringAsFixed(2)
                      : 'N/A',
                  avg: record.avg != null
                      ? record.avg!.toStringAsFixed(2)
                      : 'N/A',
                  more30: record.more30 != null
                      ? record.more30!.toStringAsFixed(2)
                      : 'N/A',
                  rainfall: record.rainfall != null
                      ? record.rainfall!.toString()
                      : 'N/A',
                  condition: record.condition ?? '',
                  statusColor: statusColor,
                ),
              );
            }),
          Gap(4.h),
          // Legend
          Row(
            children: [
              _buildLegendItem(
                context,
                color: AppColors.dryColor,
                text: AppStrings.dry.tr,
              ),
              Gap(16.w),
              _buildLegendItem(
                context,
                color: AppColors.normalColor,
                text: AppStrings.normal.tr,
              ),
              Gap(16.w),
              _buildLegendItem(
                context,
                color: AppColors.wefColor,
                text: AppStrings.wet.tr,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text, {
    int flex = 1,
    bool isEnd = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: isEnd ? TextAlign.center : TextAlign.start,
        style: context.bodySmall.copyWith(
          color: AppColors.secondaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String month,
    required String less30,
    required String avg,
    required String more30,
    required String rainfall,
    required String condition,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              month,
              style: context.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              less30,
              style: context.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              avg,
              style: context.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              more30,
              style: context.bodySmall.copyWith(color: AppColors.secondaryText),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  rainfall,
                  textAlign: TextAlign.center,
                  style: context.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap(6.w),
        Text(
          text,
          style: context.bodySmall.copyWith(
            color: AppColors.secondaryText,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
