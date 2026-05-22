import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/fleet_theme_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final palette = provider.isDarkMode ? FleetThemeColors.dark : FleetThemeColors.light;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1 + _controller.value * 0.2, -1 + _controller.value * 0.1),
                  end: Alignment(1 - _controller.value * 0.1, 1 - _controller.value * 0.2),
                  colors: palette.backgroundGradient,
                ),
              ),
              child: Stack(
                children: [
                  ...List.generate(3, (i) => Positioned(
                    left: sin(_controller.value * 2 + i * 2.1) * 200 + 100,
                    top: cos(_controller.value * 1.7 + i * 1.3) * 150 + 100,
                    child: Container(
                      width: 300 + i * 100,
                      height: 300 + i * 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: provider.isDarkMode ? 0.03 - i * 0.01 : 0.06 - i * 0.015),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  )),
                  widget.child,
                ],
              ),
            );
          },
        );
      },
    );
  }
}
