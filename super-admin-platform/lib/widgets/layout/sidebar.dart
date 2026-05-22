import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_strings.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/fleet_theme_colors.dart';
import '../common/app_logo.dart';
import '../common/fleet_text.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  static const double _collapsedWidth = 72;
  static const double _expandedWidth = 268;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _widthAnimation = Tween<double>(begin: _collapsedWidth, end: _expandedWidth).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fleetColors;

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isSidebarExpanded && _controller.status != AnimationStatus.completed) {
          _controller.forward();
        } else if (!provider.isSidebarExpanded && _controller.status != AnimationStatus.dismissed) {
          _controller.reverse();
        }

        final expanded = provider.isSidebarExpanded;

        return AnimatedBuilder(
          animation: _widthAnimation,
          builder: (context, child) {
            return Container(
              width: _widthAnimation.value,
              margin: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.glassBorder),
                boxShadow: colors.isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  _buildLogo(expanded, colors),
                  Expanded(child: _buildNavGroups(provider, expanded, colors)),
                  _buildBottomActions(provider, expanded, colors),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLogo(bool expanded, FleetThemeColors colors) {
    return Padding(
      padding: EdgeInsets.fromLTRB(expanded ? 20 : 14, 20, expanded ? 20 : 14, 12),
      child: AppLogo(size: 34, showText: expanded),
    );
  }

  Widget _buildNavGroups(AppProvider provider, bool expanded, FleetThemeColors colors) {
    final s = provider.strings;
    if (!expanded) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: [
          for (final group in AppNavigation.groups)
            for (final item in group.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _NavTile(
                  icon: item.icon,
                  label: s.navLabel(item.labelKey),
                  expanded: false,
                  selected: provider.selectedIndex == item.index,
                  accent: group.accent,
                  badge: _badgeFor(provider, item),
                  isAlerts: item.labelKey == 'nav.alerts',
                  onTap: () => provider.selectIndex(item.index),
                ),
              ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      children: [
        for (final group in AppNavigation.groups) ...[
          _NavGroupCard(group: group, provider: provider, colors: colors, strings: s),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  int? _badgeFor(AppProvider provider, NavEntry item) {
    if (item.showFleetBadge) return provider.fleetBadgeCount;
    if (item.showAlertsBadge) return provider.alertsBadgeCount;
    return null;
  }

  Widget _buildBottomActions(AppProvider provider, bool expanded, FleetThemeColors colors) {
    final actions = [
      _ActionButton(icon: Icons.auto_awesome_rounded, tint: AppColors.primary, onTap: provider.toggleAiAssistant),
      _ActionButton(icon: Icons.notifications_rounded, tint: AppColors.warning, onTap: provider.toggleNotificationsPanel),
      _ActionButton(icon: Icons.settings_rounded, tint: AppColors.accent, onTap: () => provider.selectIndex(AppNavigation.settings)),
    ];
    return Padding(
      padding: const EdgeInsets.all(8),
      child: expanded
          ? Row(children: [for (final a in actions) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: a))])
          : Column(children: [for (final a in actions) Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: a)]),
    );
  }
}

class _NavGroupCard extends StatelessWidget {
  final NavGroup group;
  final AppProvider provider;
  final FleetThemeColors colors;
  final AppStrings strings;

  const _NavGroupCard({
    required this.group,
    required this.provider,
    required this.colors,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = group.items.any((e) => e.index == provider.selectedIndex);

    return Container(
      decoration: BoxDecoration(
        color: hasSelection
            ? group.accent.withValues(alpha: colors.isDark ? 0.06 : 0.08)
            : colors.surfaceLight.withValues(alpha: colors.isDark ? 0.5 : 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasSelection ? group.accent.withValues(alpha: 0.25) : colors.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                Icon(group.icon, size: 14, color: group.accent),
                const SizedBox(width: 8),
                FleetText(
                  strings.navLabel(group.titleKey),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          for (final item in group.items)
            _NavTile(
              icon: item.icon,
              label: strings.navLabel(item.labelKey),
              expanded: true,
              selected: provider.selectedIndex == item.index,
              accent: group.accent,
              badge: item.showFleetBadge
                  ? provider.fleetBadgeCount
                  : item.showAlertsBadge
                      ? provider.alertsBadgeCount
                      : null,
              isAlerts: item.labelKey == 'nav.alerts',
              onTap: () => provider.selectIndex(item.index),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool expanded;
  final bool selected;
  final Color accent;
  final int? badge;
  final bool isAlerts;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.expanded,
    required this.selected,
    required this.accent,
    required this.onTap,
    this.badge,
    this.isAlerts = false,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.fleetColors;
    final bg = widget.selected
        ? widget.accent.withValues(alpha: colors.isDark ? 0.14 : 0.12)
        : _hovered
            ? colors.surfaceLight
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: widget.expanded ? 6 : 0, vertical: 1),
          padding: EdgeInsets.symmetric(horizontal: widget.expanded ? 10 : 8, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: widget.selected
                ? Border.all(color: widget.accent.withValues(alpha: 0.35))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 19,
                color: widget.selected ? widget.accent : colors.textMuted,
              ),
              if (widget.expanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: FleetText(
                    widget.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                      color: widget.selected ? colors.textPrimary : colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.badge != null && widget.badge! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.isAlerts
                          ? AppColors.error.withValues(alpha: 0.12)
                          : widget.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FleetText(
                      '${widget.badge}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: widget.isAlerts ? AppColors.error : widget.accent,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.tint, required this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 40,
          decoration: BoxDecoration(
            color: _hovered ? widget.tint.withValues(alpha: 0.14) : widget.tint.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.tint.withValues(alpha: 0.2)),
          ),
          child: Icon(widget.icon, color: widget.tint, size: 18),
        ),
      ),
    );
  }
}
