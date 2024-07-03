import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/theme_helper.dart'; // ignore: must_be_immutable
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AppbarTitle extends StatelessWidget {
  AppbarTitle(
      {super.key, this.textstyle, required this.text, this.margin, this.onTap});

  String text;
  TextStyle? textstyle;
  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: textstyle ??
              TextStyle(
                  color: appTheme.blackheading,
                  fontSize: 20.v,
                  fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
