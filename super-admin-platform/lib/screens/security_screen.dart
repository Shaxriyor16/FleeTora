import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/glass_card.dart';
import '../l10n/app_strings.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/module_hub_card.dart';
import '../widgets/common/screen_scaffold.dart';
import '../widgets/common/status_indicator.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return ScreenScaffold(
          children: [
            _buildHeader(provider),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildSecurityOverview(provider)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(flex: 1, child: _buildSessionManagement(context, provider)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildAuditLog(context, provider),
            const SizedBox(height: AppSpacing.lg),
            _buildUsersHub(context, provider),
          ],
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
            Text('SECURITY CENTER', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Enterprise Security', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const StatusIndicator(color: AppColors.success, size: 6),
              const SizedBox(width: 8),
              Text('Security Level: High • ${provider.activeSessions} sessions', style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityOverview(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Label('SECURITY OVERVIEW', icon: Icons.shield, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildSecurityCard('Active Sessions', '${provider.activeSessions}', Icons.laptop, AppColors.primary),
              const SizedBox(width: 12),
              _buildSecurityCard('MFA Enabled', '100%', Icons.fingerprint, AppColors.success),
              const SizedBox(width: 12),
              _buildSecurityCard('Suspicious Logins', '3', Icons.warning, AppColors.warning),
              const SizedBox(width: 12),
              _buildSecurityCard('Blocked Attempts', '28', Icons.block, AppColors.error),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('SECURITY PROTOCOLS', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 12),
          _buildProtocolRow('Biometric Authentication', true),
          _buildProtocolRow('Multi-Factor Authentication', true),
          _buildProtocolRow('End-to-End Encryption', true),
          _buildProtocolRow('Session Timeout (15 min)', true),
          _buildProtocolRow('IP Whitelisting', false),
          _buildProtocolRow('Device Monitoring', true),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(String label, String value, IconData icon, Color color) {
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
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolRow(String label, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(enabled ? Icons.check_circle : Icons.cancel, color: enabled ? AppColors.success : AppColors.textMuted, size: 16),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const Spacer(),
          Text(enabled ? 'Active' : 'Inactive', style: TextStyle(color: enabled ? AppColors.success : AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSessionManagement(BuildContext context, AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Label('ACTIVE SESSIONS', icon: Icons.devices, color: AppColors.accent),
          const SizedBox(height: AppSpacing.md),
          _SessionRow(device: 'Windows PC #1', role: 'Admin', ip: '192.168.1.1', trusted: true, onRevoke: () => provider.revokeSession('Windows PC #1')),
          const SizedBox(height: 10),
          _SessionRow(device: 'MacBook Pro', role: 'Admin', ip: '192.168.1.2', trusted: true, onRevoke: () => provider.revokeSession('MacBook Pro')),
          const SizedBox(height: 10),
          _SessionRow(device: 'Mobile iOS', role: 'Viewer', ip: '10.0.0.5', trusted: true, onRevoke: () => provider.revokeSession('Mobile iOS')),
          const SizedBox(height: 10),
          _SessionRow(device: 'Unknown Device', role: 'Guest', ip: '203.0.113.5', trusted: false, onRevoke: () => provider.revokeSession('Unknown Device')),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Revoke All Sessions',
            icon: Icons.logout,
            variant: AppButtonVariant.danger,
            compact: true,
            onPressed: provider.activeSessions > 1
                ? () {
                    provider.revokeAllSessions();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All other sessions revoked')));
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLog(BuildContext context, AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _Label('AUDIT LOG', icon: Icons.history, color: AppColors.primary),
              const Spacer(),
              AppButton(
                label: 'Export',
                icon: Icons.download,
                variant: AppButtonVariant.secondary,
                compact: true,
                width: 110,
                onPressed: () {
                  provider.downloadAuditLog();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Audit log download started')));
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAuditEntry('Admin Login', 'Successful login from Windows PC #1', '2 min ago', Icons.login, AppColors.success),
          _buildAuditEntry('Permission Change', 'User role updated: Viewer → Admin', '1h ago', Icons.admin_panel_settings, AppColors.warning),
          _buildAuditEntry('Failed Login', 'Failed attempt from IP 203.0.113.5', '3h ago', Icons.login, AppColors.error),
          _buildAuditEntry('Company Approved', 'SwiftFreight Inc. approved by Admin', '1d ago', Icons.business, AppColors.primary),
          _buildAuditEntry('Settings Change', 'Security policy updated', '2d ago', Icons.settings, AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildAuditEntry(String action, String details, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.glassBorder))),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                Text(details, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildUsersHub(BuildContext context, AppProvider provider) {
    final s = provider.strings;
    final c = context.fleetColors;
    return ModuleHubCard(
      icon: Icons.manage_accounts_rounded,
      title: s.usersRoles,
      subtitle: _hubT(s, 'Admin users, roles & permissions', 'Adminlar va rollar', 'Роли и доступ'),
      accent: c.accentBlue,
      actions: [
        ModuleHubAction(
          label: _hubT(s, 'Invite user', 'Taklif', 'Пригласить'),
          icon: Icons.person_add_alt_1,
          onTap: () => provider.addNotification(_hubT(s, 'Invite sent', 'Taklif yuborildi', 'Приглашение отправлено')),
        ),
        ModuleHubAction(
          label: _hubT(s, 'Role matrix', 'Rollar', 'Матрица ролей'),
          icon: Icons.grid_view,
          onTap: () => showHubSnack(context, s, s.usersRoles),
        ),
      ],
      child: Column(
        children: [
          _userRow(c, 'Super Admin', 'admin@fleetora.app', _hubT(s, 'Owner', 'Egasi', 'Владелец')),
          const SizedBox(height: 8),
          _userRow(c, 'Ops Manager', 'ops@fleetora.app', _hubT(s, 'Editor', 'Tahrirchi', 'Редактор')),
          const SizedBox(height: 8),
          _userRow(c, 'Analyst', 'analyst@fleetora.app', _hubT(s, 'Viewer', 'Ko\'ruvchi', 'Просмотр')),
        ],
      ),
    );
  }

  Widget _userRow(FleetThemeColors c, String name, String email, String role) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: c.brandPrimary.withValues(alpha: 0.15),
          child: Text(name[0], style: TextStyle(color: c.brandPrimary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.textPrimary, decoration: TextDecoration.none)),
              Text(email, style: TextStyle(fontSize: 11, color: c.textMuted, decoration: TextDecoration.none)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: c.surfaceLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: c.glassBorder),
          ),
          child: Text(role, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c.textSecondary, decoration: TextDecoration.none)),
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

class _SessionRow extends StatelessWidget {
  final String device;
  final String role;
  final String ip;
  final bool trusted;
  final VoidCallback onRevoke;

  const _SessionRow({
    required this.device,
    required this.role,
    required this.ip,
    required this.trusted,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: trusted ? AppColors.glassBorder : AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            device.contains('Windows') ? Icons.laptop_windows : device.contains('Mac') ? Icons.laptop_mac : Icons.phone_android,
            color: trusted ? AppColors.textSecondary : AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                Text('$role • $ip', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          TextButton(onPressed: onRevoke, child: const Text('Revoke', style: TextStyle(fontSize: 11))),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _Label(this.text, {required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
      ],
    );
  }
}
