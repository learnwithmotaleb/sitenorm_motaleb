import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/features/save/controller/save_controller.dart';
import 'package:weather_app/features/save/presentation/screen/widgets/save_additional_info_widget.dart';
import 'package:weather_app/features/save/presentation/screen/widgets/save_rainfall_record_widget.dart';
import 'package:weather_app/features/save/presentation/screen/widgets/save_details_card.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class SaveDetailsScreen extends StatefulWidget {
  final String id;
  const SaveDetailsScreen({super.key, required this.id});

  @override
  State<SaveDetailsScreen> createState() => _SaveDetailsScreenState();
}

class _SaveDetailsScreenState extends State<SaveDetailsScreen> {
  final SaveController _controller = Get.find<SaveController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getSaveDetails(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.resultSummary.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final resultData = _controller.saveDetailsModel.value.data;

        if (resultData == null) {
          return const Center(
            child: Text(
              "No details found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              const SaveDetailsCard(),
              Gap(24.h),
              const SaveRainfallRecordWidget(),
              Gap(24.h),
              const SaveAdditionalInfoWidget(),
              Gap(32.h),

              // Footer
              GestureDetector(
                onTap: () {
                  context.pushNamed(RoutePath.referenceScreen);
                },
                child: Text(
                  "${AppStrings.climateReferencePeriod.tr}: ${resultData.climateReferencePeriod ?? '1971-2000'}",
                  style: context.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Gap(20.h),
            ],
          ),
        );
      }),
    );
  }
}
