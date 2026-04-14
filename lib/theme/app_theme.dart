import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// "The Midnight Playground" (dark) + "The Heritage Playroom" (light).
/// Colors sourced from .github/DESIGN-dark.md & DESIGN-light.md.
class AppTheme {
  AppTheme._();

  // ── Brand tokens ─────────────────────────────────────────────────────────
  static const electricBlue = Color(0xFF6CB2FD);
  static const glowingAmber = Color(0xFFFF9800);
  static const neonCoral = Color(0xFFFF7161);
  static const oceanBlue = Color(0xFF0067AD);
  static const heritageRed = Color(0xFFC41F19);

  // ── Dark surfaces ─────────────────────────────────────────────────────────
  static const dBg = Color(0xFF0C0E11);
  static const dLow = Color(0xFF111417);
  static const dHigh = Color(0xFF1D2024);
  static const dHst = Color(0xFF23262A);
  static const dText = Color(0xFFF9F9FD);
  static const dMuted = Color(0xFFAAABAF);

  // ── Light surfaces ────────────────────────────────────────────────────────
  static const lBg = Color(0xFFFEFCF4);
  static const lSurf = Color(0xFFFFFFFF);
  static const lText = Color(0xFF383833);
  static const lMuted = Color(0xFF77776F);

  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness b) {
    final d = b == Brightness.dark;
    final cs = d ? _darkCS : _lightCS;

    final txt = GoogleFonts.interTextTheme().apply(
      bodyColor: d ? dMuted : lMuted,
      displayColor: d ? dText : lText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: cs,
      scaffoldBackgroundColor: d ? dBg : lBg,
      textTheme: txt,
      cardTheme: CardThemeData(
        color: d ? dHigh : lSurf,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: d ? dText : lText,
        iconTheme: IconThemeData(color: d ? dText : lText),
        systemOverlayStyle: d
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: (d ? dHst : lSurf).withOpacity(0.92),
        indicatorColor: (d ? electricBlue : oceanBlue).withOpacity(0.15),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.inter(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? (d ? electricBlue : oceanBlue)
                : (d ? dMuted : lMuted),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? (d ? electricBlue : oceanBlue)
                : (d ? dMuted : lMuted),
            size: 24,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: d ? dHst : const Color(0xFFD0CEC5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: d ? dHigh : const Color(0xFFF0EEE6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      dividerTheme: const DividerThemeData(space: 0, thickness: 0),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? (d ? electricBlue : oceanBlue)
              : (d ? dMuted : lMuted),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? (d ? electricBlue : oceanBlue).withOpacity(0.3)
              : (d ? dHst : const Color(0xFFD0CEC5)),
        ),
      ),
    );
  }

  static const _darkCS = ColorScheme(
    brightness: Brightness.dark,
    primary: electricBlue,
    onPrimary: Color(0xFF003055),
    primaryContainer: Color(0xFF1A3A5C),
    onPrimaryContainer: dText,
    secondary: glowingAmber,
    onSecondary: Color(0xFF2B1900),
    secondaryContainer: Color(0xFF3A2900),
    onSecondaryContainer: dText,
    tertiary: neonCoral,
    onTertiary: Color(0xFF2B0800),
    tertiaryContainer: Color(0xFF3D1208),
    onTertiaryContainer: dText,
    error: neonCoral,
    onError: Color(0xFF2B0800),
    errorContainer: Color(0xFF3D1208),
    onErrorContainer: dText,
    surface: dHigh,
    onSurface: dText,
    onSurfaceVariant: dMuted,
    outline: Color(0xFF46484B),
    outlineVariant: Color(0xFF2E3035),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: dText,
    onInverseSurface: dBg,
    inversePrimary: Color(0xFF1A3A5C),
    surfaceContainerLowest: dLow,
    surfaceContainerLow: dLow,
    surfaceContainer: dHigh,
    surfaceContainerHigh: dHst,
    surfaceContainerHighest: Color(0xFF2A2D32),
  );

  static const _lightCS = ColorScheme(
    brightness: Brightness.light,
    primary: oceanBlue,
    onPrimary: lSurf,
    primaryContainer: Color(0xFFB3D4FF),
    onPrimaryContainer: Color(0xFF00305A),
    secondary: heritageRed,
    onSecondary: lSurf,
    secondaryContainer: Color(0xFFFF7767),
    onSecondaryContainer: Color(0xFF3D0503),
    tertiary: Color(0xFF00751F),
    onTertiary: lSurf,
    tertiaryContainer: Color(0xFF91F78E),
    onTertiaryContainer: Color(0xFF002106),
    error: heritageRed,
    onError: lSurf,
    errorContainer: Color(0xFFFF7767),
    onErrorContainer: Color(0xFF3D0503),
    surface: lSurf,
    onSurface: lText,
    onSurfaceVariant: lMuted,
    outline: Color(0xFFD0CEC5),
    outlineVariant: Color(0xFFE8E4DC),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: lText,
    onInverseSurface: lSurf,
    inversePrimary: Color(0xFFB3D4FF),
    surfaceContainerLowest: Color(0xFFF8F5ED),
    surfaceContainerLow: Color(0xFFF4F1EA),
    surfaceContainer: Color(0xFFEFECE4),
    surfaceContainerHigh: Color(0xFFE9E6DE),
    surfaceContainerHighest: Color(0xFFE3E0D8),
  );
}
