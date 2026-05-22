import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'fleet_theme_colors.dart';

class AppTheme {
  static TextStyle _plain(TextStyle s) =>
      s.copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent);

  static TextTheme _textTheme(TextTheme base, Color primary, Color secondary, Color muted) {
    return base.copyWith(
      displayLarge: _plain(GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w700, color: primary)),
      displayMedium: _plain(GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w600, color: primary)),
      displaySmall: _plain(GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: primary)),
      headlineLarge: _plain(GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: primary)),
      headlineMedium: _plain(GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primary)),
      headlineSmall: _plain(GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500, color: primary)),
      titleLarge: _plain(GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: primary)),
      titleMedium: _plain(GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: primary)),
      titleSmall: _plain(GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: secondary)),
      bodyLarge: _plain(GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: primary)),
      bodyMedium: _plain(GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: secondary)),
      bodySmall: _plain(GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: muted)),
      labelLarge: _plain(GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primary)),
      labelMedium: _plain(GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: secondary)),
      labelSmall: _plain(GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: muted)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FleetThemeColors.dark.background,
      extensions: const [FleetThemeColors.dark],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: _textTheme(
        GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        AppColors.textPrimary,
        AppColors.textSecondary,
        AppColors.textMuted,
      ),
      useMaterial3: true,
      dividerColor: AppColors.glassBorder,
      cardColor: AppColors.cardDark,
      dialogTheme: const DialogThemeData(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: FleetThemeColors.light.background,
      extensions: const [FleetThemeColors.light],
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF006064),
        secondary: Color(0xFF512DA8),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFD32F2F),
      ),
      textTheme: _textTheme(
        GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        const Color(0xFF0F172A),
        const Color(0xFF475569),
        const Color(0xFF64748B),
      ),
      useMaterial3: true,
      dividerColor: const Color(0xFFE2E8F0),
      cardColor: const Color(0xFFFFFFFF),
      dialogTheme: const DialogThemeData(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF006064), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF475569)),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}
