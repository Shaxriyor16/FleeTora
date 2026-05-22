import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../l10n/app_strings.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/module_hub_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildChartCard('Revenue Growth', provider.analytics.revenue, AppColors.primary, '\$M')),
                      const SizedBox(width: 14),
                      Expanded(child: _buildChartCard('Fuel Cost Trends', provider.analytics.fuelCost, AppColors.warning, '\$M')),
                      const SizedBox(width: 14),
                      Expanded(child: _buildChartCard('Fleet Efficiency', provider.analytics.fleetEfficiency, AppColors.success, '%')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildDetailedAnalytics(provider)),
                      const SizedBox(width: 20),
                      Expanded(flex: 2, child: _buildMetricsSummary(provider)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildPredictiveAnalytics(provider),
                  const SizedBox(height: 20),
                  _buildFinanceHub(context, provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ANALYTICS & BI', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Business Intelligence', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: const Text('Date range'),
                children: ['Last 3 Months', 'Last 6 Months', 'Last 9 Months', 'Last 12 Months'].map((p) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Showing: $p')));
                  },
                  child: Text(p),
                )).toList(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.date_range, color: AppColors.primary, size: 14),
                SizedBox(width: 6),
                Text('Last 9 Months', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, List<double> data, Color color, String unit) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: BarChartPainter(data: data, color: color),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${data.first.toStringAsFixed(1)}$unit', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text('${data.last.toStringAsFixed(1)}$unit', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalytics(AppProvider provider) {
    final analytics = provider.analytics;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: AppColors.accent, size: 16),
              SizedBox(width: 8),
              Text('PERFORMANCE OVERVIEW', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: MultiLinePainter(
                revenue: analytics.revenue,
                efficiency: analytics.fleetEfficiency,
                risk: analytics.aiRiskMetrics,
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppColors.primary, 'Revenue'),
              const SizedBox(width: 16),
              _legendDot(AppColors.success, 'Efficiency'),
              const SizedBox(width: 16),
              _legendDot(AppColors.warning, 'Risk'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildMetricsSummary(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text('KEY METRICS', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 24),
          _buildKpiRow('Revenue', '\$26.3M', '+8.7%', AppColors.success),
          const SizedBox(height: 16),
          _buildKpiRow('Fuel Cost', '\$5.1M', '-7.4%', AppColors.success),
          const SizedBox(height: 16),
          _buildKpiRow('Efficiency', '90%', '+3.4%', AppColors.primary),
          const SizedBox(height: 16),
          _buildKpiRow('Driver Perf.', '94%', '+2.1%', AppColors.accent),
          const SizedBox(height: 16),
          _buildKpiRow('Risk Score', '2.1%', '-45%', AppColors.success),
          const SizedBox(height: 16),
          _buildKpiRow('Maintenance', '12 trucks', '+3', AppColors.warning),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'AI Prediction: Revenue on track to exceed Q3 target by 12%',
              style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiRow(String label, String value, String change, Color changeColor) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: changeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                change.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
                color: changeColor, size: 10,
              ),
              const SizedBox(width: 2),
              Text(change, style: TextStyle(color: changeColor, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPredictiveAnalytics(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Predictive Insights', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  'Based on current trends, fleet efficiency will reach 94% by Q4. '
                  'Fuel costs projected to decrease further by 8%. '
                  'Driver performance improvement of 5% expected with new training program.',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Text('View Report', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceHub(BuildContext context, AppProvider provider) {
    final s = provider.strings;
    final c = context.fleetColors;
    return ModuleHubRow(
      cards: [
        ModuleHubCard(
          icon: Icons.account_balance_wallet_outlined,
          title: s.financeOverview,
          subtitle: _hubT(s, 'Revenue, payouts & billing', 'Daromad va to\'lovlar', 'Выручка и выплаты'),
          accent: c.accentGreen,
          actions: [
            ModuleHubAction(
              label: _hubT(s, 'Invoices', 'Hisob-fakturalar', 'Счета'),
              icon: Icons.receipt_long,
              onTap: () => showHubSnack(context, s, s.financeOverview),
            ),
          ],
        ),
        ModuleHubCard(
          icon: Icons.description_outlined,
          title: s.reportsCenter,
          subtitle: _hubT(s, 'PDF export & scheduled reports', 'PDF va rejalashtirilgan hisobotlar', 'PDF и отчёты'),
          accent: c.accentPurple,
          actions: [
            ModuleHubAction(
              label: s.export,
              icon: Icons.file_download_outlined,
              onTap: () => provider.exportFleetReport(),
            ),
          ],
        ),
      ],
    );
  }

  static String _hubT(AppStrings s, String en, String uz, String ru) => switch (s.lang) {
        'uz' => uz,
        'ru' => ru,
        _ => en,
      };
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  BarChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.reduce((a, b) => a > b ? a : b) * 1.2;
    final barWidth = (size.width - (data.length - 1) * 6) / data.length;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxVal) * size.height * 0.85;
      final x = i * (barWidth + 6);
      final y = size.height - barHeight;

      final paint = Paint()
        ..color = color.withValues(alpha: 0.3 + (0.5 * (i / data.length)))
        ..style = PaintingStyle.fill;

      final r = 4.0;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: Radius.circular(r),
        topRight: Radius.circular(r),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MultiLinePainter extends CustomPainter {
  final List<double> revenue;
  final List<double> efficiency;
  final List<double> risk;

  MultiLinePainter({required this.revenue, required this.efficiency, required this.risk});

  @override
  void paint(Canvas canvas, Size size) {
    void drawLine(List<double> data, Color color) {
      if (data.isEmpty) return;
      final maxVal = data.reduce((a, b) => a > b ? a : b) * 1.2;
      final stepX = size.width / (data.length - 1);

      final paint = Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;

      final points = data.asMap().entries.map((e) {
        final x = e.key * stepX;
        final y = size.height - ((e.value / maxVal) * size.height * 0.8) - 10;
        return Offset(x, y);
      }).toList();

      final fillPath = Path()
        ..moveTo(points.first.dx, size.height);
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          fillPath.lineTo(points[i].dx, points[i].dy);
        } else {
          final cx = (points[i - 1].dx + points[i].dx) / 2;
          fillPath.cubicTo(cx, points[i - 1].dy, cx, points[i].dy, points[i].dx, points[i].dy);
        }
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, paint);

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final linePath = Path();
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          linePath.moveTo(points[i].dx, points[i].dy);
        } else {
          final cx = (points[i - 1].dx + points[i].dx) / 2;
          linePath.cubicTo(cx, points[i - 1].dy, cx, points[i].dy, points[i].dx, points[i].dy);
        }
      }
      canvas.drawPath(linePath, linePaint);
    }

    drawLine(revenue.map((e) => e * 3).toList(), AppColors.primary);
    drawLine(efficiency, AppColors.success);
    drawLine(risk.map((e) => e * 5).toList(), AppColors.warning);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
