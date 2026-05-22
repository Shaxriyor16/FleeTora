import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_strings.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/fleet_theme_colors.dart';
import '../common/app_button.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool _showProfileMenu = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.fleetColors;
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            height: AppSpacing.navHeight,
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.glassBorder, width: 1)),
              boxShadow: colors.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  _IconButton(icon: Icons.menu_rounded, onTap: provider.toggleSidebar, colors: colors),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    provider.strings.pageTitle(provider.selectedIndex),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Spacer(),
                  _buildLiveIndicator(provider.strings),
                  const SizedBox(width: AppSpacing.md),
                  AppButton(
                    label: provider.strings.aiAssistant,
                    icon: Icons.auto_awesome_rounded,
                    onPressed: provider.toggleAiAssistant,
                    compact: true,
                    width: 150,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildThemeToggle(provider, colors),
                  const SizedBox(width: AppSpacing.sm),
                  _buildProfileAvatar(provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveIndicator(AppStrings s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success)),
          const SizedBox(width: 8),
          Text(
            s.live,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(AppProvider provider, FleetThemeColors colors) {
    final isDark = provider.isDarkMode;
    final s = provider.strings;
    return Tooltip(
      message: isDark ? s.lightMode : s.darkMode,
      child: Material(
        color: colors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: provider.toggleTheme,
          child: Container(
            width: 88,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Row(
              children: [
                _ThemeChip(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
                  active: isDark,
                  onTap: isDark ? null : provider.toggleTheme,
                  colors: colors,
                ),
                _ThemeChip(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  active: !isDark,
                  onTap: !isDark ? null : provider.toggleTheme,
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(AppProvider provider) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _showProfileMenu = !_showProfileMenu;
            provider.closeNotificationsPanel();
          }),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary,
            ),
            child: const Center(
              child: Text('SA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ),
        if (_showProfileMenu)
          Positioned(
            right: 0,
            top: 48,
            child: _ProfileMenu(
              provider: provider,
              onClose: () => setState(() => _showProfileMenu = false),
            ),
          ),
      ],
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final FleetThemeColors colors;

  const _ThemeChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: active ? AppColors.primary.withValues(alpha: colors.isDark ? 0.2 : 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Icon(
              icon,
              size: 18,
              color: active ? AppColors.primary : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final FleetThemeColors colors;

  const _IconButton({required this.icon, required this.onTap, required this.colors});

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _hovered ? widget.colors.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.colors.glassBorder),
          ),
          child: Icon(widget.icon, color: widget.colors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final AppProvider provider;
  final VoidCallback onClose;

  const _ProfileMenu({required this.provider, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Profile Settings', Icons.person_rounded),
      ('Account Security', Icons.security_rounded),
      ('Billing & Plans', Icons.credit_card_rounded),
      ('Help & Support', Icons.headset_mic_rounded),
      ('Sign Out', Icons.logout_rounded),
    ];

    final colors = context.fleetColors;
    return Material(
      color: colors.surface,
      elevation: 8,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              dense: true,
              title: Text('Super Admin', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('admin@fleetora.io', style: TextStyle(fontSize: 11)),
            ),
            Divider(height: 1, color: colors.glassBorder),
            ...items.map((item) => ListTile(
              dense: true,
              leading: Icon(item.$2, size: 18, color: item.$1 == 'Sign Out' ? AppColors.error : colors.textSecondary),
              title: Text(item.$1, style: TextStyle(fontSize: 13, color: item.$1 == 'Sign Out' ? AppColors.error : colors.textPrimary)),
              onTap: () {
                onClose();
                if (item.$1 == 'Sign Out') {
                  _showSignOutDialog(context, provider);
                } else {
                  provider.navigateFromProfile(item.$1);
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will be logged out of Fleetora Enterprise OS.'),
        actions: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, compact: true, width: 100, onPressed: () => Navigator.pop(ctx)),
          AppButton(
            label: 'Sign Out',
            variant: AppButtonVariant.danger,
            compact: true,
            width: 110,
            onPressed: () {
              Navigator.pop(ctx);
              provider.addNotification('Signed out successfully');
            },
          ),
        ],
      ),
    );
  }
}
