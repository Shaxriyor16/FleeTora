import 'package:flutter/material.dart';
import '../../theme/fleet_theme_colors.dart';

/// Text without debug yellow underlines (desktop/web safe).
class FleetText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const FleetText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;
    final base = style ?? TextStyle(color: c.textPrimary, fontSize: 14);
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent),
    );
  }
}
