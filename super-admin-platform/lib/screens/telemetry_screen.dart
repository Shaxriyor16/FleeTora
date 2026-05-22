import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_provider.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/fleet_panel_card.dart';
import '../widgets/common/fleet_stat_card.dart';
import '../widgets/common/fleet_text.dart';
import '../widgets/common/module_hub_card.dart';
import '../widgets/common/status_indicator.dart';

class TelemetryScreen extends StatelessWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final s = provider.strings;
        final c = context.fleetColors;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(s, c),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 900;
                  final gaugeRow = [
                    FleetStatCard(icon: Icons.local_gas_station_rounded, label: s.fuelLevel, value: provider.simulatedFuel, accent: c.accentCyan, suffix: '%', decimals: 1),
                    FleetStatCard(icon: Icons.thermostat_rounded, label: s.engineTemp, value: provider.simulatedTemp, accent: c.accentOrange, suffix: '°C', decimals: 1),
                    FleetStatCard(icon: Icons.battery_charging_full_rounded, label: s.battery, value: 85, accent: c.accentGreen, suffix: '%'),
                    FleetStatCard(icon: Icons.tire_repair_rounded, label: s.tirePressure, value: 95, accent: c.accentPurple, suffix: '%'),
                  ];
                  if (narrow) {
                    return Column(
                      children: [
                        for (var i = 0; i < gaugeRow.length; i++) ...[
                          gaugeRow[i],
                          if (i < gaugeRow.length - 1) const SizedBox(height: 10),
                        ],
                      ],
                    );
                  }
                  return Row(
                    children: [
                      for (var i = 0; i < gaugeRow.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: gaugeRow[i]),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              ModuleHubCard(
                icon: Icons.local_gas_station_rounded,
                title: s.fuelAnalytics,
                subtitle: _t(s, 'Fleet avg 2.4 \$/gal • 3 anomalies today', 'O\'rtacha 2.4 \$/gal • 3 anomaliya', 'Среднее 2.4 \$/gal • 3 аномалии'),
                accent: c.accentOrange,
                actions: [
                  ModuleHubAction(label: s.export, icon: Icons.download_rounded, onTap: () => showHubSnack(context, s, s.fuelAnalytics)),
                ],
                child: Column(
                  children: [
                    _fuelBar(s, c, 'TK-4421', 0.72, c.accentGreen),
                    const SizedBox(height: 8),
                    _fuelBar(s, c, 'TK-2234', 0.34, c.accentRed),
                    const SizedBox(height: 8),
                    _fuelBar(s, c, 'TK-3312', 0.58, c.accentOrange),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stack = constraints.maxWidth < 1000;
                  final diagnostics = _buildEngineDiagnostics(provider, s, c);
                  final behavior = _buildDriverBehavior(s, c);
                  if (stack) {
                    return Column(children: [diagnostics, const SizedBox(height: 14), behavior]);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: diagnostics),
                      const SizedBox(width: 14),
                      Expanded(flex: 2, child: behavior),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              _buildTelemetryLog(s, c),
            ],
          ),
        );
      },
    );
  }

  static String _t(AppStrings s, String en, String uz, String ru) {
    return switch (s.lang) {
      'uz' => uz,
      'ru' => ru,
      _ => en,
    };
  }

  Widget _buildHeader(AppStrings s, FleetThemeColors c) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FleetText(s.liveTelemetry, style: TextStyle(color: c.brandPrimary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
              const SizedBox(height: 4),
              FleetText(s.vehicleDiagnostics, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.textPrimary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: c.brandPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.brandPrimary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, color: c.brandPrimary, size: 10),
              const SizedBox(width: 6),
              FleetText(s.live, style: TextStyle(color: c.brandPrimary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fuelBar(AppStrings s, FleetThemeColors c, String truck, double level, Color color) {
    return Row(
      children: [
        SizedBox(width: 64, child: FleetText(truck, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: level, minHeight: 8, backgroundColor: c.surfaceLight, valueColor: AlwaysStoppedAnimation(color)),
          ),
        ),
        const SizedBox(width: 10),
        FleetText('${(level * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildEngineDiagnostics(AppProvider provider, AppStrings s, FleetThemeColors c) {
    return FleetPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.precision_manufacturing, color: c.brandPrimary, size: 18),
              const SizedBox(width: 8),
              FleetText(s.engineDiagnostics, style: TextStyle(color: c.brandPrimary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
              const Spacer(),
              StatusIndicator(color: c.accentGreen, size: 6),
              const SizedBox(width: 6),
              FleetText(s.engineOptimal, style: TextStyle(color: c.accentGreen, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          _diagRow(c, 'RPM', '${provider.simulatedRpm}', _t(s, 'Normal', 'Normal', 'Норма'), c.accentGreen),
          _diagRow(c, _t(s, 'Oil', 'Moy', 'Масло'), '88%', _t(s, 'OK', 'OK', 'OK'), c.accentGreen),
          _diagRow(c, _t(s, 'Coolant', 'Sovutish', 'Охлаждение'), '${provider.simulatedTemp.toStringAsFixed(1)}°C', _t(s, 'Normal', 'Normal', 'Норма'), c.accentGreen),
          _diagRow(c, _t(s, 'Fuel press.', 'Bosim', 'Давление'), '94%', _t(s, 'Optimal', 'Optimal', 'Оптимум'), c.accentGreen),
          _diagRow(c, _t(s, 'Errors', 'Xatolar', 'Ошибки'), '0', _t(s, 'None', 'Yo\'q', 'Нет'), c.accentGreen),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.accentGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.accentGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: c.accentGreen, size: 16),
                const SizedBox(width: 8),
                FleetText(s.allSystemsOk, style: TextStyle(color: c.accentGreen, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _diagRow(FleetThemeColors c, String label, String value, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: FleetText(label, style: TextStyle(color: c.textMuted, fontSize: 12))),
          FleetText(value, style: TextStyle(color: c.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FleetText(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverBehavior(AppStrings s, FleetThemeColors c) {
    return FleetPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: c.accentPurple, size: 18),
              const SizedBox(width: 8),
              FleetText(s.driverBehavior, style: TextStyle(color: c.accentPurple, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 16),
          _behavior(c, _t(s, 'Acceleration', 'Tezlanish', 'Разгон'), 85, c.accentGreen),
          _behavior(c, _t(s, 'Braking', 'Tormoz', 'Торможение'), 78, c.accentOrange),
          _behavior(c, _t(s, 'Cornering', 'Burilish', 'Повороты'), 92, c.accentGreen),
          _behavior(c, _t(s, 'Speed', 'Tezlik', 'Скорость'), 88, c.accentCyan),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: c.accentGreen, size: 14),
                  const SizedBox(width: 6),
                  FleetText('4.8 / 5.0', style: TextStyle(color: c.accentGreen, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _behavior(FleetThemeColors c, String label, int score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FleetText(label, style: TextStyle(color: c.textSecondary, fontSize: 11)),
              FleetText('$score%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 5,
              backgroundColor: c.surfaceLight,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryLog(AppStrings s, FleetThemeColors c) {
    final logs = [
      (_t(s, 'Engine Start', 'Dvigatel yoqildi', 'Запуск двигателя'), 'TK-4421', '2m', c.accentGreen, Icons.play_arrow_rounded),
      (_t(s, 'Fuel Warning', 'Yoqilg\'i ogohlantirish', 'Предупр. топливо'), 'TK-2234', '15m', c.accentOrange, Icons.warning_amber_rounded),
      (_t(s, 'Tire Check', 'Shina tekshiruvi', 'Проверка шин'), 'TK-3312', '1h', c.accentCyan, Icons.check_circle_outline),
    ];
    return FleetPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt, color: c.brandPrimary, size: 18),
              const SizedBox(width: 8),
              FleetText(s.telemetryLog, style: TextStyle(color: c.brandPrimary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 12),
          for (final log in logs) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: log.$4.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9)),
                    child: Icon(log.$5, color: log.$4, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: FleetText(log.$1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.textPrimary))),
                  FleetText(log.$2, style: TextStyle(fontSize: 11, color: c.textMuted)),
                  const SizedBox(width: 12),
                  FleetText(log.$3, style: TextStyle(fontSize: 10, color: c.textMuted)),
                ],
              ),
            ),
            if (log != logs.last) Divider(height: 1, color: c.glassBorder),
          ],
        ],
      ),
    );
  }
}
