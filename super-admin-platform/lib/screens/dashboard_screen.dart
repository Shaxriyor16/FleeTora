import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/fleet_map_widget.dart';
import '../widgets/common/fleet_panel_card.dart';
import '../widgets/common/fleet_stat_card.dart';
import '../widgets/common/responsive_container.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final c = context.fleetColors;
        return SingleChildScrollView(
          child: ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, provider, c),
                const SizedBox(height: 22),
                _buildStatRow(provider, c),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildMapSection(context, c)),
                    const SizedBox(width: 18),
                    Expanded(flex: 5, child: _buildAlertsSection(provider, c)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _buildRevenueChart(c)),
                    const SizedBox(width: 18),
                    Expanded(flex: 4, child: _buildActivityFeed(c)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider, FleetThemeColors c) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Super Admin',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.accentGreen,
                      boxShadow: [
                        BoxShadow(
                          color: c.accentGreen.withValues(alpha: 0.45),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All systems operational • ${DateTime.now().toString().substring(0, 16)}',
                    style: TextStyle(color: c.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildDateChip(context, c),
        const SizedBox(width: 10),
        _buildRefreshButton(context, provider, c),
      ],
    );
  }

  Widget _buildDateChip(BuildContext context, FleetThemeColors c) {
    return Material(
      color: c.card,
      elevation: c.isDark ? 0 : 1,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              backgroundColor: c.card,
              title: Text('Select period', style: TextStyle(color: c.textPrimary)),
              children: ['Q1 2026', 'Q2 2026', 'Q3 2026', 'Q4 2026']
                  .map((q) => SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Period: $q')));
                        },
                        child: Text(q, style: TextStyle(color: c.textPrimary)),
                      ))
                  .toList(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.glassBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: c.brandPrimary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Q3 2026 • Week 21',
                style: TextStyle(color: c.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context, AppProvider provider, FleetThemeColors c) {
    return Material(
      color: c.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          provider.refreshDashboard();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dashboard refreshed')));
        },
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.glassBorder),
          ),
          child: Icon(Icons.refresh_rounded, color: c.textSecondary, size: 20),
        ),
      ),
    );
  }

  Widget _buildStatRow(AppProvider provider, FleetThemeColors c) {
    final stats = provider.fleetStats;
    return Row(
      children: [
        Expanded(
          child: FleetStatCard(
            icon: Icons.local_shipping_rounded,
            label: 'Total Trucks',
            value: stats.totalTrucks.toDouble(),
            accent: c.accentCyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FleetStatCard(
            icon: Icons.people_rounded,
            label: 'Online Drivers',
            value: stats.onlineDrivers.toDouble(),
            accent: c.accentGreen,
            trend: '+4%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FleetStatCard(
            icon: Icons.inventory_2_outlined,
            label: 'Active Deliveries',
            value: stats.activeDeliveries.toDouble(),
            accent: c.accentPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FleetStatCard(
            icon: Icons.warning_amber_rounded,
            label: 'AI Alerts',
            value: stats.aiAlerts.toDouble(),
            accent: c.accentOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FleetStatCard(
            icon: Icons.payments_outlined,
            label: 'Revenue',
            value: stats.revenue,
            prefix: '\$',
            suffix: 'M',
            accent: c.accentGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FleetStatCard(
            icon: Icons.local_gas_station_rounded,
            label: 'Fuel Avg',
            value: stats.fuelAvg,
            suffix: ' \$/gal',
            decimals: 1,
            accent: c.accentBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, FleetThemeColors c) {
    return FleetPanelCard(
      padding: EdgeInsets.zero,
      height: 340,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FleetMapWidget(height: 340, width: double.infinity),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: c.isDark ? Colors.black.withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.glassBorder),
                boxShadow: c.isDark
                    ? null
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_rounded, color: c.brandPrimary, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    'FLEET MAP',
                    style: TextStyle(
                      color: c.brandPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(AppProvider provider, FleetThemeColors c) {
    return FleetPanelCard(
      height: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FleetPanelHeader(
            icon: Icons.notifications_active_rounded,
            title: 'AI ALERTS',
            accent: c.accentOrange,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: c.accentRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${provider.criticalAlerts.length} critical',
                style: TextStyle(color: c.accentRed, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: provider.aiAlerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: c.accentGreen, size: 36),
                        const SizedBox(height: 8),
                        Text('No active alerts', style: TextStyle(color: c.textMuted, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: provider.aiAlerts.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: c.glassBorder),
                    itemBuilder: (context, index) => _AlertTile(alert: provider.aiAlerts[index], colors: c),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(FleetThemeColors c) {
    return FleetPanelCard(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FleetPanelHeader(
            icon: Icons.trending_up_rounded,
            title: 'REVENUE ANALYTICS',
            accent: c.accentCyan,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: c.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_upward_rounded, color: c.accentGreen, size: 12),
                  const SizedBox(width: 3),
                  Text('+8.7%', style: TextStyle(color: c.accentGreen, fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: _LineChartPainter(
                data: [12.4, 14.2, 13.8, 16.1, 18.5, 20.2, 22.8, 24.1, 26.3],
                color: c.accentCyan,
                fillColor: c.accentCyan,
                dotBackground: c.card,
                gridColor: c.glassBorder,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed(FleetThemeColors c) {
    final activities = [
      ('Truck #4421 fuel anomaly detected', '2m ago', Icons.local_gas_station_rounded, c.accentOrange),
      ('Driver Omar H. flagged for fraud', '15m ago', Icons.person_off_rounded, c.accentRed),
      ('Company SwiftFreight applied', '1h ago', Icons.business_rounded, c.accentBlue),
      ('Truck #3312 maintenance completed', '2h ago', Icons.build_rounded, c.accentGreen),
      ('Revenue target Q3 exceeded', '4h ago', Icons.trending_up_rounded, c.accentCyan),
      ('New driver verification pending', '6h ago', Icons.verified_rounded, c.accentPurple),
    ];

    return FleetPanelCard(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FleetPanelHeader(
            icon: Icons.history_rounded,
            title: 'RECENT ACTIVITY',
            accent: c.accentPurple,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: c.glassBorder),
              itemBuilder: (context, index) {
                final (text, time, icon, color) = activities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(icon, color: color, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(time, style: TextStyle(color: c.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final AiAlert alert;
  final FleetThemeColors colors;

  const _AlertTile({required this.alert, required this.colors});

  @override
  Widget build(BuildContext context) {
    Color alertColor;
    IconData alertIcon;
    switch (alert.type) {
      case 'critical':
        alertColor = colors.accentRed;
        alertIcon = Icons.error_rounded;
        break;
      case 'fuel':
        alertColor = colors.accentOrange;
        alertIcon = Icons.local_gas_station_rounded;
        break;
      case 'driver':
        alertColor = colors.accentRed;
        alertIcon = Icons.person_rounded;
        break;
      case 'route':
        alertColor = colors.accentOrange;
        alertIcon = Icons.route_rounded;
        break;
      case 'fraud':
        alertColor = colors.accentRed;
        alertIcon = Icons.security_rounded;
        break;
      default:
        alertColor = colors.accentBlue;
        alertIcon = Icons.info_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(alertIcon, color: alertColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    color: alert.severity == 'critical' ? colors.accentRed : colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  alert.description,
                  style: TextStyle(color: colors.textMuted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(alert.time, style: TextStyle(color: colors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final Color fillColor;
  final Color dotBackground;
  final Color gridColor;

  _LineChartPainter({
    required this.data,
    required this.color,
    required this.fillColor,
    required this.dotBackground,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()..color = gridColor.withValues(alpha: 0.5)..strokeWidth = 1,
      );
    }

    final maxVal = data.reduce((a, b) => a > b ? a : b) * 1.15;
    final minVal = data.reduce((a, b) => a < b ? a : b) * 0.85;
    final range = maxVal - minVal;
    final stepX = size.width / (data.length - 1);

    final points = data.asMap().entries.map((e) {
      final x = e.key * stepX;
      final y = size.height - ((e.value - minVal) / range) * size.height * 0.82 - 12;
      return Offset(x, y);
    }).toList();

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final cx = (points[i - 1].dx + points[i].dx) / 2;
        fillPath.cubicTo(cx, points[i - 1].dy, cx, points[i].dy, points[i].dx, points[i].dy);
      }
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fillColor.withValues(alpha: 0.22), fillColor.withValues(alpha: 0.02)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final linePath = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final cx = (points[i - 1].dx + points[i].dx) / 2;
        linePath.cubicTo(cx, points[i - 1].dy, cx, points[i].dy, points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(linePath, Paint()..color = color..strokeWidth = 2.5..style = PaintingStyle.stroke);

    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = dotBackground);
      canvas.drawCircle(point, 3.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.color != color || old.dotBackground != dotBackground;
}
