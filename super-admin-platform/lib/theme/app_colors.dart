import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF060A14);
  static const Color surface = Color(0xFF0D1321);
  static const Color surfaceLight = Color(0xFF1A2235);
  static const Color cardDark = Color(0xFF111827);

  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF00838F);
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentLight = Color(0xFFB388FF);

  static const Color success = Color(0xFF00E676);
  static const Color successDark = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color warningDark = Color(0xFFFF6D00);
  static const Color error = Color(0xFFFF1744);
  static const Color errorDark = Color(0xFFD50000);
  static const Color info = Color(0xFF448AFF);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  static const Color glassBg = Color(0x0FFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glassHighlight = Color(0x0DFFFFFF);

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonRed = Color(0xFFFF1744);
  static const Color neonOrange = Color(0xFFFF9100);
  static const Color neonPurple = Color(0xFF7C4DFF);
  static const Color neonBlue = Color(0xFF448AFF);
  static const Color neonYellow = Color(0xFFFFEA00);

  static const Color chartGreen = Color(0xFF00E676);
  static const Color chartCyan = Color(0xFF00E5FF);
  static const Color chartPurple = Color(0xFF7C4DFF);
  static const Color chartOrange = Color(0xFFFF9100);
  static const Color chartPink = Color(0xFFFF4081);
  static const Color gradientStart = Color(0xFF0A0E1A);
  static const Color gradientEnd = Color(0xFF060A14);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0E1A), Color(0xFF060A14)],
  );

  static const glowCyan = BoxShadow(
    color: Color(0x0800E5FF),
    blurRadius: 12,
    spreadRadius: 0,
  );

  static const glowPurple = BoxShadow(
    color: Color(0x087C4DFF),
    blurRadius: 12,
    spreadRadius: 0,
  );
}
