import 'package:flutter/material.dart';

class NavEntry {
  final String labelKey;
  final IconData icon;
  final int index;
  final bool showFleetBadge;
  final bool showAlertsBadge;

  const NavEntry({
    required this.labelKey,
    required this.icon,
    required this.index,
    this.showFleetBadge = false,
    this.showAlertsBadge = false,
  });
}

class NavGroup {
  final String titleKey;
  final IconData icon;
  final Color accent;
  final List<NavEntry> items;

  const NavGroup({
    required this.titleKey,
    required this.icon,
    required this.accent,
    required this.items,
  });
}

/// Streamlined navigation — no empty placeholder routes.
class AppNavigation {
  AppNavigation._();

  static const int dashboard = 0;
  static const int fleet = 1;
  static const int drivers = 2;
  static const int liveMap = 3;
  static const int monitoring = 4;
  static const int alerts = 5;
  static const int business = 6;
  static const int analytics = 7;
  static const int system = 8;
  static const int settings = 9;

  static const List<NavGroup> groups = [
    NavGroup(
      titleKey: 'group.main',
      icon: Icons.home_rounded,
      accent: Color(0xFF00E5FF),
      items: [
        NavEntry(labelKey: 'nav.dashboard', icon: Icons.dashboard_rounded, index: dashboard),
      ],
    ),
    NavGroup(
      titleKey: 'group.operations',
      icon: Icons.local_shipping_rounded,
      accent: Color(0xFF00E676),
      items: [
        NavEntry(labelKey: 'nav.fleet', icon: Icons.local_shipping_rounded, index: fleet, showFleetBadge: true),
        NavEntry(labelKey: 'nav.drivers', icon: Icons.people_rounded, index: drivers),
        NavEntry(labelKey: 'nav.liveMap', icon: Icons.map_rounded, index: liveMap),
      ],
    ),
    NavGroup(
      titleKey: 'group.monitoring',
      icon: Icons.radar_rounded,
      accent: Color(0xFFFF9100),
      items: [
        NavEntry(labelKey: 'nav.monitoring', icon: Icons.monitor_heart_outlined, index: monitoring),
        NavEntry(labelKey: 'nav.alerts', icon: Icons.notifications_active_rounded, index: alerts, showAlertsBadge: true),
      ],
    ),
    NavGroup(
      titleKey: 'group.business',
      icon: Icons.business_center_rounded,
      accent: Color(0xFF7C4DFF),
      items: [
        NavEntry(labelKey: 'nav.business', icon: Icons.business_rounded, index: business),
        NavEntry(labelKey: 'nav.analytics', icon: Icons.analytics_rounded, index: analytics),
      ],
    ),
    NavGroup(
      titleKey: 'group.system',
      icon: Icons.admin_panel_settings_rounded,
      accent: Color(0xFF448AFF),
      items: [
        NavEntry(labelKey: 'nav.system', icon: Icons.dns_rounded, index: system),
        NavEntry(labelKey: 'nav.settings', icon: Icons.settings_rounded, index: settings),
      ],
    ),
  ];

  static String titleFor(int index, String Function(String key) navLabel, String Function(int) pageTitle) {
    return pageTitle(index);
  }
}
