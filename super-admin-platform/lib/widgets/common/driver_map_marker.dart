import 'package:flutter/material.dart';

/// Blue person marker for live driver tracking on the map.
class DriverMapMarker extends StatelessWidget {
  final String label;
  final bool isLive;
  final double size;

  const DriverMapMarker({
    super.key,
    required this.label,
    this.isLive = true,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    const body = Color(0xFF2979FF);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(size, size * 1.1),
              painter: _DriverPinPainter(color: body),
            ),
            if (isLive)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00E676),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: body,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _DriverPinPainter extends CustomPainter {
  final Color color;
  _DriverPinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final headR = size.width * 0.22;
    canvas.drawCircle(Offset(cx, headR + 4), headR, Paint()..color = color);
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - headR * 0.9, headR * 2 + 2, headR * 1.8, headR * 1.6),
      Radius.circular(headR * 0.4),
    );
    canvas.drawRRect(body, Paint()..color = color);
    final pin = Path()
      ..moveTo(cx - headR * 0.5, size.height - 4)
      ..lineTo(cx, size.height)
      ..lineTo(cx + headR * 0.5, size.height - 4)
      ..close();
    canvas.drawPath(pin, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _DriverPinPainter old) => old.color != color;
}
