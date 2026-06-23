import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/utils/color/app_colors.dart';
import 'package:weather_app/utils/extension/base_extension.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailingWidget;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
    this.iconColor,
    this.textColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: iconColor ?? AppColors.successColor,
            size: 24.sp,
          ),
          title: Text(
            title,
            style: context.titleMedium.copyWith(
              color: textColor ?? AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailingWidget ?? Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.secondaryText,
            size: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        ),
        if (showDivider)
          Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 20.w,
            endIndent: 20.w,
          ),
      ],
    );
  }
}
