import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import 'responsive_container.dart';

/// Standard scrollable page with centered 1200px content grid.
class ScreenScaffold extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ScreenScaffold({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContainer(
        maxWidth: maxWidth,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutterWide),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
