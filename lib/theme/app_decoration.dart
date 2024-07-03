import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'theme_helper.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
// Outline decorations
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
      );
}

class BorderRadiusStyle {
  // Rounded borders
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
}
