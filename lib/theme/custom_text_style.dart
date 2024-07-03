import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get montserrat {
    return copyWith(
      fontFamily: 'Montserrat',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static get bodyMediumGray700 => theme.textTheme.bodyMedium!.copyWith(
        fontFamily: "Poppins",
        color: appTheme.gray700,
      );
  static get bodySmall10 => theme.textTheme.bodySmall!.copyWith(
        fontFamily: "Poppins",
        color: appTheme.gray500,
        fontSize: 12.fSize,
      );
  static get bodySmallMontserratGray500 =>
      theme.textTheme.bodySmall!.montserrat.copyWith(
        fontFamily: "Poppins",
        color: appTheme.gray500,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
      fontFamily: "Poppins",
      color: theme.colorScheme.onPrimary.withOpacity(1),
      fontSize: 14.v,
      fontWeight: FontWeight.w600);
  static get bodySmallOnPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        fontFamily: "Poppins",
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        fontFamily: "Poppins",
        color: theme.colorScheme.primary,
      );
  static get bodySmallPrimary_1 => theme.textTheme.bodySmall!.copyWith(
        fontFamily: "Poppins",
        color: theme.colorScheme.primary,
      );
}
