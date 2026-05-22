import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/status_indicator.dart';

class AiCenterScreen extends StatelessWidget {
  const AiCenterScreen({super.key});

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
                  _buildHeader(provider),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildAiMonitoringPanel(provider)),
                      const SizedBox(width: 20),
                      Expanded(flex: 1, child: _buildAiMetricsPanel()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildAiAlertsTimeline(provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI SECURITY CENTER', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Intelligent Threat Detection', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              StatusIndicator(color: AppColors.success, size: 6),
              const SizedBox(width: 8),
              const Text('AI Engine Active', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiMonitoringPanel(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.accent.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Neural Monitor', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Real-time anomaly detection across all systems', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
              const Spacer(),
              _buildNeuralPulse(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildDetectionCard('Suspicious Drivers', '${provider.flaggedVerifications.length}', Icons.person_off, AppColors.error),
              const SizedBox(width: 12),
              _buildDetectionCard('Fake Documents', '3', Icons.description, AppColors.error),
              const SizedBox(width: 12),
              _buildDetectionCard('Unusual Routes', '5', Icons.route, AppColors.warning),
              const SizedBox(width: 12),
              _buildDetectionCard('Fuel Theft', '2', Icons.local_gas_station, AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),
          const Text('AI ANALYSIS SUMMARY', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
          const SizedBox(height: 12),
          _buildAnalysisRow('Duplicate Face Detection', 'No matches found', AppColors.success, 0.0),
          const SizedBox(height: 8),
          _buildAnalysisRow('Document Forgery Scan', '2 suspicious documents', AppColors.warning, 0.4),
          const SizedBox(height: 8),
          _buildAnalysisRow('Behavioral Pattern Analysis', '1 anomaly detected', AppColors.warning, 0.6),
          const SizedBox(height: 8),
          _buildAnalysisRow('Cross-Reference Check', 'All clear', AppColors.success, 0.0),
        ],
      ),
    );
  }

  Widget _buildNeuralPulse() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.fiber_manual_record, color: AppColors.primary, size: 12),
      ),
    );
  }

  Widget _buildDetectionCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String status, Color statusColor, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glassBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
          if (progress > 0)
            SizedBox(
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.glassBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 4,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Row(
            children: [
              StatusIndicator(color: statusColor, size: 5),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiMetricsPanel() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: AppColors.accent, size: 16),
              SizedBox(width: 8),
              Text('AI PERFORMANCE', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 24),
          _buildMetricLarge('Detection Rate', '99.7%', AppColors.success),
          const SizedBox(height: 20),
          _buildMetricLarge('False Positives', '0.3%', AppColors.warning),
          const SizedBox(height: 20),
          _buildMetricLarge('Response Time', '1.2s', AppColors.primary),
          const SizedBox(height: 20),
          _buildMetricLarge('Models Active', '7', AppColors.accent),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 16),
          const Text('CURRENT STATUS', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
          const SizedBox(height: 12),
          _buildStatusRow('Fraud Detection', 'Active'),
          _buildStatusRow('Face Recognition', 'Active'),
          _buildStatusRow('Route Analysis', 'Active'),
          _buildStatusRow('Behavioral AI', 'Learning'),
        ],
      ),
    );
  }

  Widget _buildMetricLarge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          StatusIndicator(color: status == 'Active' ? AppColors.success : AppColors.warning, size: 5),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const Spacer(),
          Text(status, style: TextStyle(
            color: status == 'Active' ? AppColors.success : AppColors.warning,
            fontSize: 10, fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  Widget _buildAiAlertsTimeline(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: AppColors.warning, size: 16),
              SizedBox(width: 8),
              Text('AI ALERT TIMELINE', style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              Spacer(),
              Text('View All →', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.aiAlerts.map((alert) => _buildTimelineItem(alert)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(AiAlert alert) {
    IconData icon;
    Color color;
    switch (alert.type) {
      case 'fuel': icon = Icons.local_gas_station; color = AppColors.warning; break;
      case 'driver': icon = Icons.person; color = AppColors.error; break;
      case 'route': icon = Icons.route; color = AppColors.warning; break;
      case 'fraud': icon = Icons.security; color = AppColors.error; break;
      default: icon = Icons.info; color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Container(width: 1, height: 20, color: AppColors.glassBorder),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(alert.title, style: TextStyle(color: alert.severity == 'critical' ? AppColors.error : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    const Spacer(),
                    Text(alert.time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(alert.description, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (alert.severity == 'critical' ? AppColors.error : color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert.severity.toUpperCase(),
              style: TextStyle(
                color: alert.severity == 'critical' ? AppColors.error : color,
                fontSize: 9, fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
