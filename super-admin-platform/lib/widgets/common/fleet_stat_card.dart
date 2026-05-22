import 'package:flutter/material.dart';
import '../../theme/fleet_theme_colors.dart';
import 'animated_counter.dart';

/// KPI / metric card with correct contrast in dark & light mode.
class FleetStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color accent;
  final String prefix;
  final String suffix;
  final int decimals;
  final String? trend;

  const FleetStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.glassBorder, width: 1),
        boxShadow: c.isDark
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: c.isDark ? 0.12 : 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      color: c.isDark ? const Color(0xFF00E676) : const Color(0xFF059669),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedCounter(
            targetValue: value,
            prefix: prefix,
            suffix: suffix,
            decimals: decimals,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: -0.8,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: c.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title used on dashboard panels.
class FleetPanelHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accent;
  final Widget? trailing;

  const FleetPanelHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.accent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: c.isDark ? 0.12 : 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: accent, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: c.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}
