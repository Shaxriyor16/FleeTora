import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;
  final bool compact;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = AppSpacing.buttonHeightLg,
    this.compact = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final h = widget.compact ? AppSpacing.buttonHeightSm : widget.height;
    final scale = _enabled && _hovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: SizedBox(
          width: widget.width,
          height: h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.transparent,
              splashColor: AppColors.primary.withValues(alpha: 0.08),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: _decoration(),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(_foreground()),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: _foreground(), size: 18),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: _foreground(),
                                fontSize: widget.compact ? 13 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          color: _enabled && _hovered ? AppColors.primaryDark : AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: _enabled && _hovered ? const Color(0xFFF8FAFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.glassBorder),
        );
      case AppButtonVariant.danger:
        return BoxDecoration(
          color: _enabled && _hovered ? AppColors.errorDark : AppColors.error,
          borderRadius: BorderRadius.circular(10),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(
          color: _enabled && _hovered ? AppColors.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        );
    }
  }

  Color _foreground() {
    if (!_enabled) return AppColors.textMuted;
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }
}
