import 'package:flutter/material.dart';

/// Top-down fleet vehicle marker (taxi / truck style).
class VehicleMapMarker extends StatelessWidget {
  final String label;
  final Color bodyColor;
  final double size;
  final double rotation;

  const VehicleMapMarker({
    super.key,
    required this.label,
    required this.bodyColor,
    this.size = 40,
    this.rotation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: rotation,
          child: CustomPaint(
            size: Size(size, size * 1.35),
            painter: _TopDownVehiclePainter(color: bodyColor),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  static Color colorForStatus(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFFFFD600);
      case 'idle':
        return const Color(0xFFFF9100);
      case 'offline':
      case 'error':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF42A5F5);
    }
  }
}

class _TopDownVehiclePainter extends CustomPainter {
  final Color color;

  _TopDownVehiclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, h * 0.92), width: w * 0.75, height: h * 0.12), shadow);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.22, w * 0.76, h * 0.58),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(body, Paint()..color = color);

    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(body.outerRect);
    canvas.drawRRect(body, highlight);

    final cabin = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.08, w * 0.6, h * 0.28),
      Radius.circular(w * 0.12),
    );
    canvas.drawRRect(cabin, Paint()..color = const Color(0xFF1A1A2E));

    final windshield = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.26, h * 0.11, w * 0.48, h * 0.14),
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(
      windshield,
      Paint()..color = const Color(0xFF4FC3F7).withValues(alpha: 0.55),
    );

    final wheelPaint = Paint()..color = const Color(0xFF263238);
    for (final dx in [w * 0.18, w * 0.72]) {
      for (final dy in [h * 0.32, h * 0.72]) {
        canvas.drawCircle(Offset(dx, dy), w * 0.09, wheelPaint);
        canvas.drawCircle(
          Offset(dx, dy),
          w * 0.05,
          Paint()..color = const Color(0xFF455A64),
        );
      }
    }

    final headlight = Paint()..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(Offset(w * 0.28, h * 0.84), w * 0.05, headlight);
    canvas.drawCircle(Offset(w * 0.72, h * 0.84), w * 0.05, headlight);
  }

  @override
  bool shouldRepaint(covariant _TopDownVehiclePainter oldDelegate) =>
      oldDelegate.color != color;
}
