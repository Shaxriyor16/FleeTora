import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_provider.dart';
import '../theme/fleet_theme_colors.dart';
import '../widgets/common/driver_passport_sheet.dart';
import '../widgets/common/fleet_map_widget.dart';
import '../widgets/common/fleet_panel_card.dart';
import '../widgets/common/fleet_text.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final s = provider.strings;
        final c = context.fleetColors;

        final truckMarkers = provider.fleetTrucks
            .map((t) => FleetMapMarker(
                  id: t.id,
                  lat: t.lat,
                  lng: t.lng,
                  label: t.name,
                  status: t.status,
                ))
            .toList();

        final driverMarkers = provider.liveDriversOnMap
            .map((d) => FleetMapDriverMarker(
                  id: d.id,
                  lat: d.lat,
                  lng: d.lng,
                  label: d.name.split(' ').first,
                  isLive: true,
                  driver: d,
                ))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FleetText(s.navLiveMap, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.textPrimary)),
                        const SizedBox(height: 4),
                        FleetText(
                          _t(s, '${truckMarkers.length} trucks • ${driverMarkers.length} drivers LIVE', '${truckMarkers.length} mashina • ${driverMarkers.length} haydovchi JONLI', '${truckMarkers.length} ТС • ${driverMarkers.length} водителей ОНЛАЙН'),
                          style: TextStyle(fontSize: 13, color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _legendChip(c, Icons.local_shipping_rounded, _t(s, 'Trucks', 'Mashinalar', 'Грузовики'), const Color(0xFFFFD600)),
                  const SizedBox(width: 8),
                  _legendChip(c, Icons.person_pin_circle, _t(s, 'Drivers', 'Haydovchilar', 'Водители'), const Color(0xFF2979FF)),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: FleetPanelCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: FleetMapWidget(
                      height: double.infinity,
                      markers: truckMarkers,
                      driverMarkers: driverMarkers,
                      onDriverTap: (m) {
                        if (m.driver != null) showDriverPassportSheet(context, m.driver!);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FleetText(
                _t(s, 'Tap a blue driver pin to view passport & photo', 'Ko\'k belgini bosing — pasport va rasm', 'Нажмите синий маркер — паспорт и фото'),
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _t(AppStrings s, String en, String uz, String ru) => switch (s.lang) {
        'uz' => uz,
        'ru' => ru,
        _ => en,
      };

  Widget _legendChip(FleetThemeColors c, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.glassBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          FleetText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c.textSecondary)),
        ],
      ),
    );
  }
}
