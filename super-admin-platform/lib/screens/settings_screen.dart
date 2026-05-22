import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/screen_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final colors = context.fleetColors;
        return ScreenScaffold(
          children: [
            _buildHeader(context, provider),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildGeneralSettings(context, provider, colors)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(flex: 1, child: _buildAccountSettings(context, provider)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildNotificationSettings(context, provider, colors),
            const SizedBox(height: AppSpacing.lg),
            _buildDangerZone(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SYSTEM SETTINGS', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary, letterSpacing: 2)),
            const SizedBox(height: 4),
            Text('Platform Configuration', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
        const Spacer(),
        AppButton(
          label: 'Save Changes',
          icon: Icons.save_outlined,
          onPressed: () {
            provider.saveSettings();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings saved successfully')),
            );
          },
          compact: true,
          width: 160,
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(BuildContext context, AppProvider provider, FleetThemeColors colors) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(icon: Icons.tune, label: 'GENERAL SETTINGS', color: AppColors.primary),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingRow(context, 'Platform Name', 'Fleetora Enterprise OS'),
          _buildLanguageSelector(context, provider, colors),
          _buildThemeSelector(context, provider, colors),
          _buildSettingRow(context, 'Time Zone', 'UTC-5 (Eastern)'),
          _buildSettingRow(context, 'Date Format', 'MM/DD/YYYY'),
          _buildSettingRow(context, 'Currency', 'USD (\$)'),
          _buildSettingRow(context, 'Measurement', 'Imperial (mph, gal)'),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(icon: Icons.person, label: 'ACCOUNT', color: AppColors.accent),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [AppColors.accent, AppColors.primary]),
                  ),
                  child: const Center(child: Text('SA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24))),
                ),
                const SizedBox(height: 12),
                const Text('Super Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Text('admin@fleetora.io', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Change Password',
            icon: Icons.lock_outline,
            variant: AppButtonVariant.secondary,
            compact: true,
            onPressed: () => _showPasswordDialog(context),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Biometric Setup',
            icon: Icons.fingerprint,
            variant: AppButtonVariant.secondary,
            compact: true,
            onPressed: () {
              provider.addNotification('Biometric enrollment started');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric setup opened')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, AppProvider provider, FleetThemeColors colors) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(icon: Icons.notifications, label: 'NOTIFICATION PREFERENCES', color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          _buildToggleRow(context, provider, 'push', 'Push Notifications'),
          _buildToggleRow(context, provider, 'email', 'Email Alerts'),
          _buildToggleRow(context, provider, 'sms', 'SMS Emergency'),
          _buildToggleRow(context, provider, 'aiSounds', 'AI Alert Sounds'),
          _buildToggleRow(context, provider, 'weeklyReports', 'Weekly Reports'),
          _buildToggleRow(context, provider, 'criticalOnly', 'Critical Incidents Only'),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(icon: Icons.warning, label: 'DANGER ZONE', color: AppColors.error),
                const SizedBox(height: 8),
                Text(
                  'Permanently delete your account and all associated data.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          AppButton(
            label: 'Delete Account',
            variant: AppButtonVariant.danger,
            compact: true,
            width: 160,
            onPressed: () => _showDeleteDialog(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(BuildContext context, String label, String value) {
    final colors = context.fleetColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.glassBorder))),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 14))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppProvider provider, FleetThemeColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.glassBorder))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mavzu rejimi', style: TextStyle(color: colors.textSecondary, fontSize: 14)),
          const SizedBox(height: 10),
          Material(
            color: colors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Expanded(
                  child: _ThemeOption(
                    icon: Icons.dark_mode_rounded,
                    label: 'Qorong\'u',
                    selected: provider.isDarkMode,
                    onTap: provider.isDarkMode ? null : provider.toggleTheme,
                    colors: colors,
                  ),
                ),
                Expanded(
                  child: _ThemeOption(
                    icon: Icons.light_mode_rounded,
                    label: 'Yorug\'',
                    selected: !provider.isDarkMode,
                    onTap: !provider.isDarkMode ? null : provider.toggleTheme,
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppProvider provider, FleetThemeColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.glassBorder))),
      child: Row(
        children: [
          Expanded(child: Text('Til', style: TextStyle(color: colors.textSecondary, fontSize: 14))),
          Material(
            color: colors.surfaceLight,
            elevation: 0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.glassBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: provider.selectedLanguage,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.textPrimary),
                  dropdownColor: colors.surface,
                  iconEnabledColor: colors.textMuted,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: colors.textPrimary, decoration: TextDecoration.none))),
                    DropdownMenuItem(value: 'uz', child: Text('O\'zbekcha', style: TextStyle(color: colors.textPrimary, decoration: TextDecoration.none))),
                    DropdownMenuItem(value: 'ru', child: Text('Русский', style: TextStyle(color: colors.textPrimary, decoration: TextDecoration.none))),
                  ],
                  onChanged: (value) {
                    if (value != null) provider.setLanguage(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(BuildContext context, AppProvider provider, String key, String label) {
    final colors = context.fleetColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.glassBorder))),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 14))),
          Switch(
            value: provider.notificationEnabled(key),
            onChanged: (_) => provider.toggleNotificationPref(key),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final current = TextEditingController();
    final next = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: current, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            const SizedBox(height: 12),
            TextField(controller: next, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
          ],
        ),
        actions: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, compact: true, width: 90, onPressed: () => Navigator.pop(ctx)),
          AppButton(
            label: 'Update',
            compact: true,
            width: 100,
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().addNotification('Password updated');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed')));
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text('This action cannot be undone. All data will be permanently removed.'),
        actions: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, compact: true, width: 90, onPressed: () => Navigator.pop(ctx)),
          AppButton(
            label: 'Delete',
            variant: AppButtonVariant.danger,
            compact: true,
            width: 100,
            onPressed: () {
              Navigator.pop(ctx);
              provider.addNotification('Account deletion requested');
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final FleetThemeColors colors;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: colors.isDark ? 0.18 : 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected ? Border.all(color: AppColors.primary.withValues(alpha: 0.4)) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : colors.textMuted, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? colors.textPrimary : colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionLabel({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
      ],
    );
  }
}
