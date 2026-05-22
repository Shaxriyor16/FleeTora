import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../l10n/app_strings.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/module_hub_card.dart';
import '../widgets/common/status_indicator.dart';
import '../widgets/common/fleet_map_widget.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final filteredTrucks = _activeFilter == 'All'
            ? provider.fleetTrucks
            : provider.fleetTrucks.where((t) => t.status == _activeFilter.toLowerCase()).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFleetHeader(context, provider),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 440,
                    child: _buildLiveMap(filteredTrucks),
                  ),
                  const SizedBox(height: 20),
                  _buildFleetTable(provider, filteredTrucks),
                  const SizedBox(height: 20),
                  _buildOperationsHub(context, provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFleetHeader(BuildContext context, AppProvider provider) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FLEET COMMAND', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Live Fleet Tracking', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        _buildFilterChip('All', _activeFilter == 'All'),
        const SizedBox(width: 8),
        _buildFilterChip('Active', _activeFilter == 'Active'),
        const SizedBox(width: 8),
        _buildFilterChip('Idle', _activeFilter == 'Idle'),
        const SizedBox(width: 8),
        _buildFilterChip('Maintenance', _activeFilter == 'Maintenance'),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            provider.exportFleetReport();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fleet report exported successfully')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.download_rounded, color: AppColors.primary, size: 14),
                SizedBox(width: 6),
                Text('Export Report', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.glassBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveMap(List<FleetTruck> trucks) {
    final markers = trucks.map((truck) {
      Color color;
      switch (truck.status) {
        case 'active': color = AppColors.success; break;
        case 'idle': color = AppColors.warning; break;
        case 'maintenance': color = AppColors.error; break;
        default: color = AppColors.primary;
      }
      return FleetMapMarker(
        id: truck.id,
        lat: truck.lat,
        lng: truck.lng,
        label: truck.name,
        color: color,
        status: truck.status,
      );
    }).toList();

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FleetMapWidget(
              height: 440,
              width: double.infinity,
              markers: markers,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.fiber_manual_record, color: AppColors.primary, size: 10),
                      SizedBox(width: 6),
                      Text('LIVE TRACKING', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${trucks.length} vehicles tracked',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendRow(AppColors.success, 'Active'),
                  const SizedBox(height: 4),
                  _legendRow(AppColors.warning, 'Idle'),
                  const SizedBox(height: 4),
                  _legendRow(AppColors.error, 'Alert'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }

  Widget _buildFleetTable(AppProvider provider, List<FleetTruck> trucks) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              const Text('FLEET VEHICLES', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              const Spacer(),
              GestureDetector(
                onTap: () => provider.selectIndex(7),
                child: const Text('View Analytics →', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...trucks.map((truck) => _buildTruckRow(truck, provider)),
          if (trucks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No vehicles match filter', style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
            ),
        ],
      ),
    );
  }

  Widget _buildTruckRow(FleetTruck truck, AppProvider provider) {
    Color statusColor;
    switch (truck.status) {
      case 'active': statusColor = AppColors.success; break;
      case 'idle': statusColor = AppColors.warning; break;
      default: statusColor = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.glassBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(truck.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(truck.driver, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: Text('${truck.speed.toStringAsFixed(0)} mph', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.local_gas_station_rounded, color: truck.fuel < 20 ? AppColors.error : AppColors.success, size: 14),
                const SizedBox(width: 4),
                Text('${truck.fuel.toStringAsFixed(0)}%', style: TextStyle(color: truck.fuel < 20 ? AppColors.error : AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                StatusIndicator(color: statusColor, size: 6),
                const SizedBox(width: 6),
                Text(truck.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              provider.addNotification('Viewing details: ${truck.name}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${truck.name} - ${truck.driver} • ${truck.route}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
                  backgroundColor: AppColors.surface,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Details', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsHub(BuildContext context, AppProvider provider) {
    final s = provider.strings;
    final c = context.fleetColors;
    return ModuleHubRow(
      cards: [
        ModuleHubCard(
          icon: Icons.alt_route_rounded,
          title: s.routesPlanning,
          subtitle: s.routesDesc,
          accent: c.accentCyan,
          actions: [
            ModuleHubAction(
              label: _t(s, 'New route', 'Yangi marshrut', 'Новый маршрут'),
              icon: Icons.add_road,
              onTap: () => showHubSnack(context, s, s.routesPlanning),
            ),
            ModuleHubAction(
              label: _t(s, 'Optimize', 'Optimallashtirish', 'Оптимизация'),
              icon: Icons.auto_fix_high,
              onTap: () => provider.selectIndex(3),
            ),
          ],
        ),
        ModuleHubCard(
          icon: Icons.build_circle_outlined,
          title: s.maintenanceHub,
          subtitle: s.maintenanceDesc,
          accent: c.accentOrange,
          actions: [
            ModuleHubAction(
              label: _t(s, 'Work orders', 'Buyurtmalar', 'Заказы'),
              icon: Icons.assignment,
              onTap: () => showHubSnack(context, s, s.maintenanceHub),
            ),
            ModuleHubAction(
              label: _t(s, 'Schedule', 'Jadval', 'График'),
              icon: Icons.event,
              onTap: () => provider.addNotification(_t(s, 'Maintenance scheduled', 'Xizmat rejalashtirildi', 'ТО запланировано')),
            ),
          ],
        ),
      ],
    );
  }

  static String _t(AppStrings s, String en, String uz, String ru) => switch (s.lang) {
        'uz' => uz,
        'ru' => ru,
        _ => en,
      };
}
