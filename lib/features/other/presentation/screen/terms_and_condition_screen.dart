import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:weather_app/features/other/controller/other_controller.dart';
import 'package:weather_app/share/widgets/loading/loading_widget.dart';
import 'package:weather_app/utils/app_strings/app_strings.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/enum/app_enum.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final controller = Get.find<OtherController>();

  @override
  void initState() {
    controller.getTermsCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.termsCondition.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.termsLoading.value) {
          case ApiStatus.loading:
            return const LoadingWidget();
          case ApiStatus.internetError:
          case ApiStatus.noDataFound:
            return Center(child: Text("No data found!".tr));
          case ApiStatus.error:
            return Center(child: Text("Something went wrong!".tr));

          case ApiStatus.completed:
            final data = controller.termsConditionsData.value.data;
            String htmlContent = data?.content ?? "";
            if (htmlContent.isEmpty && data?.sections != null && data!.sections!.isNotEmpty) {
              final buffer = StringBuffer();
              for (var section in data.sections!) {
                if (section.heading != null && section.heading!.isNotEmpty) {
                  buffer.write('<h3>${section.heading}</h3>');
                }
                if (section.content != null && section.content!.isNotEmpty) {
                  buffer.write('<p>${section.content}</p>');
                }
              }
              htmlContent = buffer.toString();
            }

            if (htmlContent.isEmpty) {
              return Center(child: Text("No data found!".tr));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data?.updatedAt != null)
                    Text(
                      "Last updated: ${data!.updatedAt!.toLocal().toString().split(' ')[0]}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.hintTextColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  HtmlWidget(
                    htmlContent,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.hintTextColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
        }
      }),
    );
  }
}
