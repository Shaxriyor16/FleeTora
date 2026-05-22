import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/common/driver_passport_sheet.dart';
import '../widgets/common/driver_registration_dialog.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/status_indicator.dart';

class DriversScreen extends StatelessWidget {
  const DriversScreen({super.key});

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
                  _buildHeader(context, provider),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildDriverStatCard('Total Drivers', '${provider.verifications.length}', Icons.people, AppColors.primary)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildDriverStatCard('Verified', '${provider.verifiedDrivers.length}', Icons.verified, AppColors.success)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildDriverStatCard('Pending', '${provider.pendingVerifications.length}', Icons.pending, AppColors.warning)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildDriverStatCard('Flagged', '${provider.flaggedVerifications.length}', Icons.flag, AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildVerificationQueue(context, provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DRIVER CENTER', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Driver Management', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => showDriverRegistrationDialog(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.person_add, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Driver KYC Register', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverStatCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationQueue(BuildContext context, AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text('VERIFICATION QUEUE', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              Spacer(),
              Icon(Icons.filter_list, color: AppColors.textMuted, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.verifications.map((v) => _buildDriverVerificationRow(context, v, provider)),
        ],
      ),
    );
  }

  Widget _buildDriverVerificationRow(BuildContext context, DriverVerification verification, AppProvider provider) {
    Color riskColor;
    switch (verification.riskLevel) {
      case 'low': riskColor = AppColors.success; break;
      case 'medium': riskColor = AppColors.warning; break;
      case 'high': riskColor = AppColors.error; break;
      default: riskColor = AppColors.textMuted;
    }

    Color statusColor;
    switch (verification.status) {
      case 'verified': statusColor = AppColors.success; break;
      case 'pending': statusColor = AppColors.warning; break;
      case 'flagged': statusColor = AppColors.error; break;
      default: statusColor = AppColors.textMuted;
    }

    return InkWell(
      onTap: () => showDriverPassportSheet(context, verification),
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  riskColor.withValues(alpha: 0.2),
                  riskColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: riskColor.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Text(
                verification.name.split(' ').map((n) => n[0]).join(),
                style: TextStyle(color: riskColor, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verification.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(verification.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                if (verification.passportNumber.isNotEmpty)
                  Text('Passport: ${verification.passportNumber}', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(verification.documentType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                Text('${verification.aiConfidence.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          RiskBadge(level: verification.riskLevel, score: verification.fraudProbability),
          const SizedBox(width: 16),
          Row(
            children: [
              StatusIndicator(color: statusColor, size: 6),
              const SizedBox(width: 6),
              Text(verification.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              if (verification.status != 'verified')
                GestureDetector(
                  onTap: () => provider.approveVerification(verification.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Approve', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              if (verification.status == 'pending') ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => provider.rejectVerification(verification.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Reject', style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class RiskBadge extends StatelessWidget {
  final String level;
  final double? score;

  const RiskBadge({super.key, required this.level, this.score});

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: _color)),
          const SizedBox(width: 6),
          Text(level.toUpperCase(), style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
        ],
      ),
    );
  }
}
