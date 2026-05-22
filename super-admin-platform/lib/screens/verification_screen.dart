import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/common/glass_card.dart';

import '../widgets/common/status_indicator.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

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
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildAiVerificationPanel(provider)),
                      const SizedBox(width: 20),
                      Expanded(flex: 1, child: _buildVerificationStats(provider)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailedQueue(provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VERIFICATION HUB', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('AI-Powered Identity Verification', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              StatusIndicator(color: AppColors.success, size: 6),
              SizedBox(width: 8),
              Text('AI System Online', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiVerificationPanel(AppProvider provider) {
    final flagged = provider.flaggedVerifications;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Verification Engine', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Real-time document analysis & face matching', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (flagged.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fraud Alert', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('${flagged.length} verification(s) flagged for suspicious activity', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  SizedBox(width: 12),
                  Text('No suspicious verifications detected', style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          const SizedBox(height: 20),
          const Text('RECENT VERIFICATIONS', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
          const SizedBox(height: 12),
          ...provider.verifications.take(4).map((v) => _buildVerificationMiniRow(v, provider)),
        ],
      ),
    );
  }

  Widget _buildVerificationMiniRow(DriverVerification verification, AppProvider provider) {
    Color riskColor;
    switch (verification.riskLevel) {
      case 'low': riskColor = AppColors.success; break;
      case 'medium': riskColor = AppColors.warning; break;
      case 'high': riskColor = AppColors.error; break;
      default: riskColor = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                verification.name.split(' ').map((n) => n[0]).join(),
                style: TextStyle(color: riskColor, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verification.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Text('${verification.aiConfidence.toStringAsFixed(1)}% match', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    const SizedBox(width: 8),
                    RiskBadgeSmall(level: verification.riskLevel),
                  ],
                ),
              ],
            ),
          ),
          if (verification.status == 'pending')
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => provider.approveVerification(verification.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.check, color: AppColors.success, size: 14),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => provider.rejectVerification(verification.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.close, color: AppColors.error, size: 14),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                StatusIndicator(color: verification.status == 'verified' ? AppColors.success : AppColors.error, size: 6),
                const SizedBox(width: 6),
                Text(verification.status.toUpperCase(), style: TextStyle(
                  color: verification.status == 'verified' ? AppColors.success : AppColors.error,
                  fontSize: 10, fontWeight: FontWeight.w600,
                )),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationStats(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: AppColors.accent, size: 16),
              SizedBox(width: 8),
              Text('AI METRICS', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 20),
          _buildMetricBar('Avg. Confidence', 89.4, AppColors.primary),
          const SizedBox(height: 14),
          _buildMetricBar('Fraud Detection', 96.2, AppColors.success),
          const SizedBox(height: 14),
          _buildMetricBar('False Positive', 2.1, AppColors.warning),
          const SizedBox(height: 14),
          _buildMetricBar('Processing Speed', 99.8, AppColors.accent),
          const SizedBox(height: 20),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 16),
          _buildStatsRow('Total Scanned', '1,847'),
          const SizedBox(height: 10),
          _buildStatsRow('Verified', '1,623'),
          const SizedBox(height: 10),
          _buildStatsRow('Flagged', '${provider.flaggedVerifications.length}'),
          const SizedBox(height: 10),
          _buildStatsRow('Pending', '${provider.pendingVerifications.length}'),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppColors.glassBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDetailedQueue(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VERIFICATION DETAILS', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          ...provider.verifications.map((v) => _buildDetailedRow(v)),
        ],
      ),
    );
  }

  Widget _buildDetailedRow(DriverVerification verification) {
    Color riskColor;
    switch (verification.riskLevel) {
      case 'low': riskColor = AppColors.success; break;
      case 'medium': riskColor = AppColors.warning; break;
      case 'high': riskColor = AppColors.error; break;
      default: riskColor = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.glassBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(Icons.description, color: verification.status == 'verified' ? AppColors.success : AppColors.warning, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verification.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Row(
                  children: [
                    Text('${verification.documentType} • ', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('AI: ${verification.aiConfidence.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                    const Text(' • Fraud: ', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('${verification.fraudProbability.toStringAsFixed(1)}%', style: TextStyle(color: riskColor, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          RiskBadgeSmall(level: verification.riskLevel),
        ],
      ),
    );
  }
}

class RiskBadgeSmall extends StatelessWidget {
  final String level;

  const RiskBadgeSmall({super.key, required this.level});

  Color get _color {
    switch (level.toLowerCase()) {
      case 'low': return AppColors.success;
      case 'medium': return AppColors.warning;
      case 'high': return AppColors.error;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(level.toUpperCase(), style: TextStyle(color: _color, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}
