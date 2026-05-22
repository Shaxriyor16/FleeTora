import 'package:flutter/material.dart';
import '../../models/dashboard_models.dart';
import '../../theme/fleet_theme_colors.dart';
import 'fleet_text.dart';

/// Bottom sheet: driver photo + passport / license KYC data.
void showDriverPassportSheet(BuildContext context, DriverVerification driver) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DriverPassportSheet(driver: driver),
  );
}

class _DriverPassportSheet extends StatelessWidget {
  final DriverVerification driver;

  const _DriverPassportSheet({required this.driver});

  @override
  Widget build(BuildContext context) {
    final c = context.fleetColors;
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scroll) {
        return Container(
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: c.glassBorder),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: c.glassBorder, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DriverPhoto(driver: driver, colors: c),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FleetText(driver.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: c.textPrimary)),
                        const SizedBox(height: 4),
                        FleetText(driver.email, style: TextStyle(fontSize: 13, color: c.textMuted)),
                        if (driver.phone.isNotEmpty)
                          FleetText(driver.phone, style: TextStyle(fontSize: 13, color: c.textMuted)),
                        const SizedBox(height: 8),
                        if (driver.isLiveOnMap)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: c.accentGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.gps_fixed, size: 14, color: c.accentGreen),
                                const SizedBox(width: 6),
                                FleetText(
                                  'LIVE • ${driver.speedKmh.toStringAsFixed(0)} km/h',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.accentGreen),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _PassportCard(driver: driver, colors: c),
              const SizedBox(height: 16),
              _InfoGrid(driver: driver, colors: c),
              if (driver.assignedTruckId.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.glassBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_rounded, color: c.accentOrange, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FleetText('Assigned vehicle', style: TextStyle(fontSize: 11, color: c.textMuted)),
                            FleetText(driver.assignedTruckId, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DriverPhoto extends StatelessWidget {
  final DriverVerification driver;
  final FleetThemeColors colors;

  const _DriverPhoto({required this.driver, required this.colors});

  @override
  Widget build(BuildContext context) {
    final url = driver.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 88,
        height: 110,
        color: colors.surfaceLight,
        child: url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initials(),
              )
            : _initials(),
      ),
    );
  }

  Widget _initials() {
    final initials = driver.name.split(' ').where((p) => p.isNotEmpty).map((p) => p[0]).take(2).join();
    return Center(
      child: Text(
        initials,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors.brandPrimary, decoration: TextDecoration.none),
      ),
    );
  }
}

class _PassportCard extends StatelessWidget {
  final DriverVerification driver;
  final FleetThemeColors colors;

  const _PassportCard({required this.driver, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A237E).withValues(alpha: colors.isDark ? 0.9 : 0.85),
            const Color(0xFF0D47A1).withValues(alpha: colors.isDark ? 0.85 : 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_outlined, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              const FleetText('PASSPORT / ID', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              const Spacer(),
              FleetText(driver.nationality, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          FleetText(
            driver.passportNumber.isNotEmpty ? driver.passportNumber : '—',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _passportField('DOB', driver.dateOfBirth)),
              Expanded(child: _passportField('Issued', driver.passportIssued)),
              Expanded(child: _passportField('Expires', driver.passportExpiry)),
            ],
          ),
          const SizedBox(height: 10),
          FleetText('License: ${driver.licenseNumber}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _passportField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9, decoration: TextDecoration.none)),
        Text(value.isNotEmpty ? value : '—', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final DriverVerification driver;
  final FleetThemeColors colors;

  const _InfoGrid({required this.driver, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _chip('Document', driver.documentType, colors),
        _chip('AI match', '${driver.aiConfidence.toStringAsFixed(1)}%', colors),
        _chip('Fraud risk', '${driver.fraudProbability.toStringAsFixed(1)}%', colors),
        _chip('Status', driver.status.toUpperCase(), colors),
        if (driver.isLiveOnMap) _chip('GPS', '${driver.lat.toStringAsFixed(4)}, ${driver.lng.toStringAsFixed(4)}', colors),
      ],
    );
  }

  Widget _chip(String label, String value, FleetThemeColors c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FleetText(label, style: TextStyle(fontSize: 10, color: c.textMuted)),
          FleetText(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.textPrimary)),
        ],
      ),
    );
  }
}
