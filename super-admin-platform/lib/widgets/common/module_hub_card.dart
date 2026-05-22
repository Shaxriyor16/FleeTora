import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../theme/fleet_theme_colors.dart';
import 'fleet_panel_card.dart';
import 'fleet_text.dart';

/// Compact functional hub — replaces empty placeholder screens.
class ModuleHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final List<ModuleHubAction> actions;
  final Widget? child;

  const ModuleHubCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.actions = const [],
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;
    return FleetPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: c.isDark ? 0.12 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FleetText(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.textPrimary)),
                    const SizedBox(height: 4),
                    FleetText(subtitle, style: TextStyle(fontSize: 12, color: c.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          if (child != null) ...[const SizedBox(height: 16), child!],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: actions.map((a) => _ActionChip(action: a, accent: accent)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class ModuleHubAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ModuleHubAction({required this.label, required this.icon, required this.onTap});
}

class _ActionChip extends StatelessWidget {
  final ModuleHubAction action;
  final Color accent;

  const _ActionChip({required this.action, required this.accent});

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;
    return Material(
      color: c.surfaceLight,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(action.icon, size: 14, color: accent),
              const SizedBox(width: 6),
              FleetText(action.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row of two hub cards (routes + maintenance, etc.)
class ModuleHubRow extends StatelessWidget {
  final List<ModuleHubCard> cards;

  const ModuleHubRow({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 14),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

extension ModuleHubSnack on BuildContext {
  void hubAction(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

void showHubSnack(BuildContext context, AppStrings s, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${s.appName}: $feature')),
  );
}
