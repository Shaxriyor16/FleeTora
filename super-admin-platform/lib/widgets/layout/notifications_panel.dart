import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class NotificationsPanel extends StatelessWidget {
  final AppProvider provider;
  final VoidCallback onClose;

  const NotificationsPanel({super.key, required this.provider, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final alerts = provider.allAlertsForPanel;

    return Material(
      color: AppColors.surface,
      child: Container(
        width: 360,
        constraints: const BoxConstraints(maxHeight: 420),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Text('Alerts', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      provider.markAllAlertsRead();
                      onClose();
                    },
                    child: const Text('Mark read', style: TextStyle(fontSize: 13)),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.glassBorder),
            if (alerts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No alerts', style: TextStyle(color: AppColors.textMuted)),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  itemCount: alerts.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.glassBorder),
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    final isCritical = alert.severity == 'critical';
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      leading: Icon(
                        isCritical ? Icons.error_outline_rounded : Icons.info_outline_rounded,
                        color: isCritical ? AppColors.error : AppColors.warning,
                        size: 20,
                      ),
                      title: Text(alert.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      subtitle: Text(alert.time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => provider.dismissAlert(alert.id),
                      ),
                      onTap: () {
                        provider.selectIndex(5);
                        onClose();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
