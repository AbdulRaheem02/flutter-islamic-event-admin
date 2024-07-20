import 'package:islamic_event_admin/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Circleimage extends StatelessWidget {
  Circleimage({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.margin,
    this.onTap,
  });

  String? imagePath;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;
  double? height, width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        17.h,
      ),
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: height ?? 35.adaptSize,
          width: width ?? 35.adaptSize,
          // fit: BoxFit.contain,
          radius: BorderRadius.circular(
            17.h,
          ),
        ),
      ),
    );
  }
}
