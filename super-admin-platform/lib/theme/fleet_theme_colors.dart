import 'package:flutter/material.dart';

/// Theme-aware palette — use via [BuildContext.fleetColors].
@immutable
class FleetThemeColors extends ThemeExtension<FleetThemeColors> {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color glassBg;
  final Color glassBorder;
  final Color mapBackground;
  final List<Color> backgroundGradient;

  const FleetThemeColors({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.glassBg,
    required this.glassBorder,
    required this.mapBackground,
    required this.backgroundGradient,
  });

  static const dark = FleetThemeColors(
    background: Color(0xFF060A14),
    surface: Color(0xFF0D1321),
    surfaceLight: Color(0xFF1A2235),
    card: Color(0xFF111827),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    glassBg: Color(0x14FFFFFF),
    glassBorder: Color(0x1AFFFFFF),
    mapBackground: Color(0xFF0A0E1A),
    backgroundGradient: [
      Color(0xFF060A14),
      Color(0xFF0A1628),
      Color(0xFF0D1A30),
      Color(0xFF060A14),
    ],
  );

  static const light = FleetThemeColors(
    background: Color(0xFFEEF2F6),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF1F5F9),
    card: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    glassBg: Color(0xFFFFFFFF),
    glassBorder: Color(0xFFDCE3EC),
    mapBackground: Color(0xFFE2E8F0),
    backgroundGradient: [
      Color(0xFFF8FAFC),
      Color(0xFFEEF2F6),
      Color(0xFFE2E8F0),
      Color(0xFFF8FAFC),
    ],
  );

  /// Chart / KPI accents — readable on both themes.
  Color get accentCyan => isDark ? const Color(0xFF00E5FF) : const Color(0xFF0284C7);
  Color get accentGreen => isDark ? const Color(0xFF00E676) : const Color(0xFF059669);
  Color get accentPurple => isDark ? const Color(0xFF7C4DFF) : const Color(0xFF7C3AED);
  Color get accentOrange => isDark ? const Color(0xFFFF9100) : const Color(0xFFD97706);
  Color get accentRed => isDark ? const Color(0xFFFF1744) : const Color(0xFFDC2626);
  Color get accentBlue => isDark ? const Color(0xFF448AFF) : const Color(0xFF2563EB);
  Color get accentPink => isDark ? const Color(0xFFFF4081) : const Color(0xFFDB2777);
  Color get brandPrimary => isDark ? const Color(0xFF00E5FF) : const Color(0xFF006064);

  bool get isDark => background == dark.background;

  @override
  FleetThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? glassBg,
    Color? glassBorder,
    Color? mapBackground,
    List<Color>? backgroundGradient,
  }) {
    return FleetThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      glassBg: glassBg ?? this.glassBg,
      glassBorder: glassBorder ?? this.glassBorder,
      mapBackground: mapBackground ?? this.mapBackground,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  FleetThemeColors lerp(ThemeExtension<FleetThemeColors>? other, double t) {
    if (other is! FleetThemeColors) return this;
    return FleetThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      glassBg: Color.lerp(glassBg, other.glassBg, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      mapBackground: Color.lerp(mapBackground, other.mapBackground, t)!,
      backgroundGradient: backgroundGradient,
    );
  }
}

extension FleetThemeContext on BuildContext {
  FleetThemeColors get fleetColors =>
      Theme.of(this).extension<FleetThemeColors>() ?? FleetThemeColors.dark;
}
