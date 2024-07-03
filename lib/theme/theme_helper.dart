import 'dart:ui';
import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "primary";
PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [newTheme].
  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      scaffoldBackgroundColor: appTheme.lightbackground,
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white), // Tick color
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary; // Color when selected
            }
            return theme.colorScheme.primaryContainer; // Default color
          },
        ),
      ),
      dividerColor: Colors.transparent,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontSize: 20.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontSize: 15.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static const primaryColorScheme = ColorScheme.light(
    primary: Color(0XFF1DA0F2),
    primaryContainer: Color(0XFFCFCFCF),
    onPrimary: Color(0X28FFFFFF),
    onPrimaryContainer: Color(0XFF1E1E1E),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
// BlueGray
  Color get blueGray400 => const Color(0XFF888888);
  Color get primaryBackground => const Color(0XFFD5D7DC);
  Color get gray700 => const Color(0XFFD5D7DC);
  Color get white => const Color.fromARGB(255, 255, 255, 255);

  // textcolor
  Color get black900 => const Color(0XFF120D26);
  Color get blackText => const Color(0XFF433D37);
  Color get blackheading => const Color(0XFF2E2D31);

// hint color
  Color get gray600 => const Color(0XFFA5A5A5);

  Color get gray500 => const Color(0XFF747688);
  Color get gray400 => const Color(0XFFBDB5B5);

  //lightbackground
  Color get lightbackground => const Color(0XFFF3F3F3);
  // Color get lightbackground => const Color(0XFFfdfdfd);
}
