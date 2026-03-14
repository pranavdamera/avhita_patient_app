import 'package:flutter/material.dart';
import 'colors.dart';

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
  static const EdgeInsets card = EdgeInsets.all(20);
  static const EdgeInsets cardCompact = EdgeInsets.all(16);
}

/// Decoration presets matching the HTML mockup's card styles.
class AppDecorations {
  AppDecorations._();

  static const double cardRadius = 20;    // .card border-radius
  static const double metricRadius = 16;  // .metric border-radius
  static const double chipRadius = 20;    // .device-chip border-radius
  static const double buttonRadius = 12;  // .btn border-radius
  static const double inputRadius = 14;
  static const double sheetRadius = 28;

  /// Standard card (white, rounded 20, subtle shadow)
  static BoxDecoration card({Color? color}) => BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 2)),
        ],
      );

  /// Hero card with gradient background
  static BoxDecoration heroCard(List<Color> gradient) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
      );

  /// Metric tile with left colored border (matches HTML .metric)
  static BoxDecoration metricTile({
    required Color borderColor,
    Color? bgColor,
  }) =>
      BoxDecoration(
        color: bgColor ?? AppColors.inputBg,
        borderRadius: BorderRadius.circular(metricRadius),
        border: Border(
          left: BorderSide(color: borderColor, width: 3),
        ),
      );

  /// Info box (matches HTML .info-box)
  static BoxDecoration infoBox({required Color borderColor, required Color bgColor}) =>
      BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      );

  /// Insights section (matches HTML .insights)
  static BoxDecoration insightsCard(List<Color> gradient, Color borderColor) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: borderColor, width: 2),
      );

  /// Device chip
  static BoxDecoration deviceChip({bool active = false}) => BoxDecoration(
        color: active ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(chipRadius),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.inputBg,
          width: 2,
        ),
        boxShadow: active
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 8)]
            : null,
      );

  /// Alert banner (matches HTML .alert)
  static BoxDecoration alertBanner() => BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
        ),
        borderRadius: BorderRadius.circular(metricRadius),
        border: const Border(
          left: BorderSide(color: AppColors.red, width: 4),
        ),
      );

  /// Standard input decoration
  static InputDecoration input({String? hint, Widget? prefix, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
      );

  /// SOS button shadow
  static List<BoxShadow> sosShadow() => [
        BoxShadow(color: AppColors.sosShadow, blurRadius: 12, offset: const Offset(0, 4)),
      ];
}
