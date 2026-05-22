import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'app_button.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isLoading;
  final double width;
  final double height;

  const NeonButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
  });

  AppButtonVariant _variant() {
    if (color == AppColors.error || color == AppColors.errorDark) {
      return AppButtonVariant.danger;
    }
    if (color == AppColors.textMuted || color == AppColors.textSecondary) {
      return AppButtonVariant.secondary;
    }
    if (color == AppColors.primary || color == AppColors.success || color == AppColors.accent) {
      return color == AppColors.primary ? AppButtonVariant.primary : AppButtonVariant.secondary;
    }
    return AppButtonVariant.primary;
  }

  @override
  Widget build(BuildContext context) {
    final variant = color == AppColors.success
        ? AppButtonVariant.primary
        : color == AppColors.error
            ? AppButtonVariant.danger
            : color == AppColors.textMuted
                ? AppButtonVariant.secondary
                : color == AppColors.accent
                    ? AppButtonVariant.secondary
                    : _variant();

    return AppButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      variant: variant,
      isLoading: isLoading,
      width: width == double.infinity ? null : width,
      height: height,
      compact: height <= 40,
    );
  }
}
