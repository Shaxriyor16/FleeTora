import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/fleet_theme_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final double blurIntensity;
  final Color? borderColor;
  final Color? bgColor;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 16,
    this.blurIntensity = 30,
    this.borderColor,
    this.bgColor,
    this.shadows,
    this.margin,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.fleetColors;
    final isLight = !palette.isDark;

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows ??
            (isLight
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : []),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isLight ? 8 : blurIntensity, sigmaY: isLight ? 8 : blurIntensity),
          child: Container(
            height: height,
            width: width,
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bgColor ?? palette.glassBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? palette.glassBorder,
                width: 0.5,
              ),
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isLight
                        ? [
                            Colors.white.withValues(alpha: 0.95),
                            Colors.white.withValues(alpha: 0.85),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.06),
                            Colors.white.withValues(alpha: 0.01),
                          ],
                  ),
            ),
            child: onTap != null
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(borderRadius),
                      splashColor: AppColors.primary.withValues(alpha: 0.05),
                      highlightColor: Colors.transparent,
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}

class GlassCardReveal extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? accentColor;

  const GlassCardReveal({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 16,
    this.onTap,
    this.accentColor,
  });

  @override
  State<GlassCardReveal> createState() => _GlassCardRevealState();
}

class _GlassCardRevealState extends State<GlassCardReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) { _isHovered = true; _controller.forward(); },
      onExit: (_) { _isHovered = false; _controller.reverse(); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final accent = widget.accentColor ?? AppColors.primary;
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: widget.padding ?? const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.glassBg,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.15 + (0.25 * _glowAnimation.value)),
                          width: _isHovered ? 1.0 : 0.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.02),
                            accent.withValues(alpha: 0.03 * _glowAnimation.value),
                          ],
                        ),
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
