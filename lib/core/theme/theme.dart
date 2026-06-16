import 'package:flutter/material.dart';

class CustomThemeData extends ThemeExtension<CustomThemeData> {
  final double maxWidth;
  final double sidebarWidth;
  final double headerHeight;
  final double mobileNavHeight;
  final Map<String, double> spacing;
  final Map<String, BorderRadiusGeometry> borderRadius;
  final Map<String, BoxShadow> shadows;
  final Map<String, Duration> transitions;

  const CustomThemeData({
    required this.maxWidth,
    required this.sidebarWidth,
    required this.headerHeight,
    required this.mobileNavHeight,
    required this.spacing,
    required this.borderRadius,
    required this.shadows,
    required this.transitions,
  });

  @override
  CustomThemeData copyWith({
    double? maxWidth,
    double? sidebarWidth,
    double? headerHeight,
    double? mobileNavHeight,
    Map<String, double>? spacing,
    Map<String, BorderRadiusGeometry>? borderRadius,
    Map<String, BoxShadow>? shadows,
    Map<String, Duration>? transitions,
  }) {
    return CustomThemeData(
      maxWidth: maxWidth ?? this.maxWidth,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      headerHeight: headerHeight ?? this.headerHeight,
      mobileNavHeight: mobileNavHeight ?? this.mobileNavHeight,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      transitions: transitions ?? this.transitions,
    );
  }

  @override
  CustomThemeData lerp(ThemeExtension<CustomThemeData>? other, double t) {
    if (other is! CustomThemeData) return this;
    return CustomThemeData(
      maxWidth: maxWidth,
      sidebarWidth: sidebarWidth,
      headerHeight: headerHeight,
      mobileNavHeight: mobileNavHeight,
      spacing: spacing,
      borderRadius: borderRadius,
      shadows: shadows,
      transitions: transitions,
    );
  }
}

// Light Theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Tajawal',
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0B6B6B),
    secondary: Color(0xFF12355B),
    tertiary: Color(0xFFD6A545),
    error: Color(0xFFDC2626),
    surface: Color(0xFFFFFFFF),
    onPrimary: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
);

// Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Tajawal',
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF33CCCC),
    secondary: Color(0xFF3B5581),
    tertiary: Color(0xFFE8B84D),
    error: Color(0xFFEF4444),
    surface: Color(0xFF1E293B),
    onPrimary: Color(0xFF0B6B6B),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
);
