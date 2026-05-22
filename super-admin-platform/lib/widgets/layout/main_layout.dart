import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/app_provider.dart';
import '../common/animated_background.dart';
import 'sidebar.dart';
import 'topbar.dart';
import 'notifications_panel.dart';
import '../common/ai_assistant_overlay.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/fleet_screen.dart';
import '../../screens/drivers_screen.dart';
import '../../screens/live_map_screen.dart';
import '../../screens/telemetry_screen.dart';
import '../../screens/incidents_screen.dart';
import '../../screens/companies_screen.dart';
import '../../screens/analytics_screen.dart';
import '../../screens/security_screen.dart';
import '../../screens/settings_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static Widget _screenForIndex(int index) {
    switch (index) {
      case AppNavigation.dashboard:
        return const DashboardScreen();
      case AppNavigation.fleet:
        return const FleetScreen();
      case AppNavigation.drivers:
        return const DriversScreen();
      case AppNavigation.liveMap:
        return const LiveMapScreen();
      case AppNavigation.monitoring:
        return const TelemetryScreen();
      case AppNavigation.alerts:
        return const IncidentsScreen();
      case AppNavigation.business:
        return const CompaniesScreen();
      case AppNavigation.analytics:
        return const AnalyticsScreen();
      case AppNavigation.system:
        return const SecurityScreen();
      case AppNavigation.settings:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return AnimatedBackground(
          child: Stack(
            children: [
              Row(
                children: [
                  const Sidebar(),
                  Expanded(
                    child: Column(
                      children: [
                        const TopBar(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 320),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(opacity: animation, child: child),
                                child: KeyedSubtree(
                                  key: ValueKey('${provider.selectedIndex}_${provider.selectedLanguage}'),
                                  child: _screenForIndex(provider.selectedIndex),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (provider.showNotificationsPanel)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: provider.closeNotificationsPanel,
                    behavior: HitTestBehavior.opaque,
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.12),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 88, right: 24),
                          child: GestureDetector(
                            onTap: () {},
                            child: NotificationsPanel(
                              provider: provider,
                              onClose: provider.closeNotificationsPanel,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (provider.isAiAssistantOpen)
                AiAssistantOverlay(onClose: () => provider.toggleAiAssistant()),
            ],
          ),
        );
      },
    );
  }
}
