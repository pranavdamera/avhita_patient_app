import 'package:flutter/material.dart';

/// Avhita Patient color system.
/// Bridges the clinician dashboard's teal branding with
/// the HTML mockup's patient-friendly color palette.
class AppColors {
  AppColors._();

  // ── Primary Brand (shared with clinician dashboard) ────────
  static const Color primary = Color(0xFF0D9488);       // Teal-600
  static const Color primaryDark = Color(0xFF0F766E);   // Teal-700
  static const Color primaryLight = Color(0xFF14B8A6);  // Teal-500
  static const Color primarySurface = Color(0xFFCCFBF1); // Teal-100
  static const Color primaryMuted = Color(0xFF99F6E4);  // Teal-200

  // ── Status colors (from HTML mockup CSS vars) ──────────────
  static const Color green = Color(0xFF10B981);   // --green
  static const Color blue = Color(0xFF3B82F6);    // --blue
  static const Color red = Color(0xFFEF4444);     // --red
  static const Color amber = Color(0xFFF59E0B);   // --amber
  static const Color purple = Color(0xFF8B5CF6);  // --purple
  static const Color orange = Color(0xFFF97316);

  // ── Status surfaces (light tints for card backgrounds) ─────
  static const Color greenSurface = Color(0xFFF0FDF4);
  static const Color greenLight = Color(0xFFD1FAE5);
  static const Color blueSurface = Color(0xFFEFF6FF);
  static const Color blueLight = Color(0xFFDBEAFE);
  static const Color redSurface = Color(0xFFFEF2F2);
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color amberSurface = Color(0xFFFFFBEB);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color purpleSurface = Color(0xFFF5F3FF);
  static const Color purpleLight = Color(0xFFE0E7FF);

  // ── Hero card gradients (from HTML mockup) ─────────────────
  static const List<Color> heroHeartGradient = [Color(0xFFECFDF5), Color(0xFFD1FAE5)];
  static const List<Color> heroGlucoseGradient = [Color(0xFFFEF3C7), Color(0xFFFDE68A)];
  static const List<Color> heroBpGradient = [Color(0xFFDBEAFE), Color(0xFFBFDBFE)];
  static const List<Color> heroSpo2Gradient = [Color(0xFFE0E7FF), Color(0xFFC7D2FE)];
  static const List<Color> heroTempGradient = [Color(0xFFFED7AA), Color(0xFFFDBA74)];

  // ── Backgrounds & Surfaces ─────────────────────────────────
  static const Color background = Color(0xFFF9FAFB);   // --gray-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFF3F4F6);      // --gray-100
  static const Color divider = Color(0xFFE5E7EB);      // --gray-200

  // ── Text ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);   // --gray-900
  static const Color textSecondary = Color(0xFF4B5563); // --gray-600
  static const Color textTertiary = Color(0xFF9CA3AF);  // --gray-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Shadows ────────────────────────────────────────────────
  static const Color shadow = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);

  // ── SOS / Emergency ────────────────────────────────────────
  static const Color sos = Color(0xFFEF4444);
  static const Color sosShadow = Color(0x4DEF4444);
}
