import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../l10n/app_strings.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/module_hub_card.dart';
import '../widgets/common/neon_button.dart';
import '../widgets/common/status_indicator.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

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
                      Expanded(child: _buildStatsCard('Total Companies', '${provider.companies.length}', Icons.business, AppColors.primary)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatsCard('Active', '${provider.activeCompanies.length}', Icons.check_circle, AppColors.success)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatsCard('Pending', '${provider.pendingCompanies.length}', Icons.hourglass_empty, AppColors.warning)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatsCard('Suspended', '${provider.suspendedCompanies.length}', Icons.cancel, AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildPendingApprovals(context, provider),
                  const SizedBox(height: 20),
                  _buildCompanyList(provider),
                  const SizedBox(height: 20),
                  _buildClientsHub(context, provider),
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
            Text('COMPANY MANAGEMENT', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Enterprise Partners', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _showAddCompanyDialog(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: AppColors.primary, size: 16),
                SizedBox(width: 6),
                Text('Add Company', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(String label, String value, IconData icon, Color color) {
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

  Widget _buildPendingApprovals(BuildContext context, AppProvider provider) {
    final pending = provider.pendingCompanies;
    if (pending.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.hourglass_empty, color: AppColors.warning, size: 16),
            SizedBox(width: 8),
            Text('PENDING APPROVALS', style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 12),
        ...pending.map((company) => _buildApprovalCard(context, company, provider)),
      ],
    );
  }

  Widget _buildApprovalCard(BuildContext context, Company company, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  company.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, color: AppColors.textMuted, size: 12),
                      const SizedBox(width: 4),
                      Text(company.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            _buildTrustScore(company.trustScore),
            const SizedBox(width: 20),
            SizedBox(
              width: 100,
              child: NeonButton(
                label: 'Arizalar',
                icon: Icons.description,
                color: AppColors.accent,
                onPressed: () => _showArizaModal(context, company, provider),
                height: 36,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 36,
              height: 36,
              child: NeonButton(
                label: '',
                icon: Icons.close,
                color: AppColors.error,
                onPressed: () => provider.rejectCompany(company.id),
                height: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustScore(double score) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = AppColors.success;
    } else if (score >= 50) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return Column(
      children: [
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: scoreColor, fontWeight: FontWeight.w700, fontSize: 18)),
        Text('Trust Score', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }

  void _showArizaModal(BuildContext context, Company company, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _CompanyArizaModal(company: company, provider: provider),
    );
  }

  void _showAddCompanyDialog(BuildContext context, AppProvider provider) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 30, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('New Application', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Fill in the company details to submit an application.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Company Name', hintText: 'Enter company name'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', hintText: 'Enter email address'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      label: 'Cancel',
                      color: AppColors.textMuted,
                      onPressed: () => Navigator.of(context).pop(),
                      height: 42,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonButton(
                      label: 'Submit',
                      icon: Icons.send,
                      color: AppColors.primary,
                      onPressed: () {
                        if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                          provider.addCompany(name: nameController.text.trim(), email: emailController.text.trim());
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Application submitted: ${nameController.text}')),
                          );
                        }
                      },
                      height: 42,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyList(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              const Text('ALL COMPANIES', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              const Spacer(),
              GestureDetector(
                onTap: () => provider.openSearch(),
                child: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.companies.map((c) => _buildCompanyRow(c, provider)),
        ],
      ),
    );
  }

  Widget _buildCompanyRow(Company company, AppProvider provider) {
    Color statusColor;
    switch (company.status) {
      case 'active': statusColor = AppColors.success; break;
      case 'pending': statusColor = AppColors.warning; break;
      case 'suspended': statusColor = AppColors.error; break;
      default: statusColor = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Text(company.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13)),
          const Spacer(),
          Text('\$${company.revenue.toStringAsFixed(1)}M', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 24),
          Text('${company.trucks} trucks', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(width: 24),
          Text('${company.drivers} drivers', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(width: 24),
          Row(
            children: [
              StatusIndicator(color: statusColor, size: 6),
              const SizedBox(width: 6),
              Text(company.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          if (company.status == 'active') ...[
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => provider.suspendCompany(company.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Suspend', style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClientsHub(BuildContext context, AppProvider provider) {
    final s = provider.strings;
    final c = context.fleetColors;
    return ModuleHubCard(
      icon: Icons.groups_rounded,
      title: s.clientsPartners,
      subtitle: _hubT(s, 'SLA tracking & contract renewals', 'SLA va shartnomalar', 'SLA и контракты'),
      accent: c.accentBlue,
      actions: [
        ModuleHubAction(
          label: _hubT(s, 'Add client', 'Mijoz qo\'shish', 'Добавить клиента'),
          icon: Icons.person_add,
          onTap: () => provider.addNotification(_hubT(s, 'Client form opened', 'Mijoz formasi', 'Форма клиента')),
        ),
      ],
      child: Row(
        children: [
          _clientStat(c, _hubT(s, 'Active', 'Faol', 'Активные'), '24'),
          _clientStat(c, _hubT(s, 'Pending', 'Kutilmoqda', 'Ожидание'), '3'),
          _clientStat(c, _hubT(s, 'Renewals', 'Yangilanish', 'Продления'), '5'),
        ],
      ),
    );
  }

  Widget _clientStat(FleetThemeColors c, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: c.textPrimary, decoration: TextDecoration.none)),
          Text(label, style: TextStyle(fontSize: 11, color: c.textMuted, decoration: TextDecoration.none)),
        ],
      ),
    );
  }

  static String _hubT(AppStrings s, String en, String uz, String ru) => switch (s.lang) {
        'uz' => uz,
        'ru' => ru,
        _ => en,
      };
}

class _CompanyArizaModal extends StatelessWidget {
  final Company company;
  final AppProvider provider;

  const _CompanyArizaModal({required this.company, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 30, spreadRadius: 5)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      company.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(company.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.glassBorder, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                _infoItem('Trust Score', '${company.trustScore}%', company.trustScore >= 70 ? AppColors.success : AppColors.warning),
                const SizedBox(width: 24),
                _infoItem('Revenue', '\$${company.revenue.toStringAsFixed(1)}M', AppColors.textPrimary),
                const SizedBox(width: 24),
                _infoItem('Trucks', '${company.trucks}', AppColors.textPrimary),
                const SizedBox(width: 24),
                _infoItem('Drivers', '${company.drivers}', AppColors.textPrimary),
              ],
            ),
            const SizedBox(height: 16),
            _buildAiAnalysis(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    label: 'Approve',
                    icon: Icons.check,
                    color: AppColors.success,
                    onPressed: () {
                      provider.approveCompany(company.id);
                      provider.addNotification('Application approved: ${company.name}');
                      Navigator.of(context).pop();
                    },
                    height: 42,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    label: 'Reject',
                    icon: Icons.close,
                    color: AppColors.error,
                    onPressed: () {
                      provider.rejectCompany(company.id);
                      provider.addNotification('Application rejected: ${company.name}');
                      Navigator.of(context).pop();
                    },
                    height: 42,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildAiAnalysis() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Risk Analysis', style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  company.trustScore >= 70
                      ? 'Low risk profile. Documentation appears legitimate.'
                      : 'Medium risk. Manual review recommended.',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          RiskBadgeSmall(score: company.trustScore),
        ],
      ),
    );
  }
}

class RiskBadgeSmall extends StatelessWidget {
  final double score;
  const RiskBadgeSmall({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 70 ? AppColors.success : score >= 50 ? AppColors.warning : AppColors.error;
    final label = score >= 70 ? 'Low Risk' : score >= 50 ? 'Medium' : 'High Risk';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}
