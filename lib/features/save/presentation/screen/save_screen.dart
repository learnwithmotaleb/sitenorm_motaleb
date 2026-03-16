import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/save/controller/save_controller.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final SaveController _controller = Get.put(SaveController());
  @override
  void dispose() {
    Get.delete<SaveController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.save.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final rawList = _controller.savedModel.value.data ?? [];

        // Deduplicate by id
        final seenIds = <String>{};
        final savedList = rawList.where((item) {
          final id = item.id ?? '';
          if (seenIds.contains(id)) return false;
          seenIds.add(id);
          return true;
        }).toList();

        if (savedList.isEmpty) {
          return const Center(
            child: Text(
              "No saved stations found",
              style: TextStyle(color: AppColors.white),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.getSavedStations(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            itemCount: savedList.length,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              final item = savedList[index];
              final timeStr = item.savedAt != null
                  ? DateFormat('MMM d, yyyy').format(item.savedAt!)
                  : "";
              return _buildSavedItem(
                context,
                item.location ?? item.stationName ?? "Unknown Location",
                timeStr,
                item.simpleLabel ?? "",
                item.id ?? "",
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildSavedItem(
    BuildContext context,
    String location,
    String time,
    String label,
    String id,
  ) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RoutePath.saveDetailsScreen,extra: id );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: context.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (label.isNotEmpty) ...[
                    Gap(4.h),
                    Text(
                      label,
                      style: context.bodySmall.copyWith(
                        color: AppColors.successColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              time,
              style: context.bodySmall.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
