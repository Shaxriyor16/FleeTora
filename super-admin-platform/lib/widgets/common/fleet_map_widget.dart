import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../models/dashboard_models.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/fleet_theme_colors.dart';
import 'driver_map_marker.dart';
import 'vehicle_map_marker.dart';

class FleetMapWidget extends StatefulWidget {
  final List<FleetMapMarker> markers;
  final List<FleetMapDriverMarker> driverMarkers;
  final List<FleetMapRoute> routes;
  final void Function(FleetMapDriverMarker)? onDriverTap;
  final void Function(double lat, double lng)? onMapClick;
  final double? height;
  final double? width;
  final LatLng? initialCenter;

  const FleetMapWidget({
    super.key,
    this.height,
    this.width,
    this.markers = const [],
    this.driverMarkers = const [],
    this.routes = const [],
    this.onDriverTap,
    this.onMapClick,
    this.initialCenter,
  });

  @override
  State<FleetMapWidget> createState() => _FleetMapWidgetState();
}

class _FleetMapWidgetState extends State<FleetMapWidget> {
  final MapController _mapController = MapController();

  LatLng _calculateCenter() {
    final points = <LatLng>[
      ...widget.markers.map((m) => LatLng(m.lat, m.lng)),
      ...widget.driverMarkers.map((d) => LatLng(d.lat, d.lng)),
    ];
    if (points.isEmpty) {
      return widget.initialCenter ?? const LatLng(39.8283, -98.5795);
    }
    double latSum = 0, lngSum = 0;
    for (final p in points) {
      latSum += p.latitude;
      lngSum += p.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final mapBg = context.fleetColors.mapBackground;
    final tileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: mapBg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _calculateCenter(),
              initialZoom: widget.markers.length > 1 ? 4 : 5,
              minZoom: 3,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (tapPosition, point) {
                if (widget.onMapClick != null) {
                  widget.onMapClick!(point.latitude, point.longitude);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.fleetora.app',
              ),
              PolylineLayer(
                polylines: widget.routes.map((r) {
                  return Polyline(
                    points: r.points.map((p) => LatLng(p.lat, p.lng)).toList(),
                    color: r.color,
                    strokeWidth: 3,
                  );
                }).toList(),
              ),
              MarkerLayer(
                markers: [
                  ...widget.markers.map((m) {
                    final vehicleColor = VehicleMapMarker.colorForStatus(m.status);
                    return Marker(
                      point: LatLng(m.lat, m.lng),
                      width: 52,
                      height: 64,
                      child: VehicleMapMarker(
                        label: m.label,
                        bodyColor: vehicleColor,
                        size: m.size.clamp(32, 48),
                        rotation: (m.lng * 1000 + m.lat * 500) % 6.28,
                      ),
                    );
                  }),
                  ...widget.driverMarkers.map((d) {
                    return Marker(
                      point: LatLng(d.lat, d.lng),
                      width: 48,
                      height: 58,
                      child: GestureDetector(
                        onTap: () => widget.onDriverTap?.call(d),
                        child: DriverMapMarker(label: d.label, isLive: d.isLive),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xB00D1321),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
              ),
              child: Text(
                '© OpenStreetMap',
                style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5), fontSize: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FleetMapDriverMarker {
  final String id;
  final double lat;
  final double lng;
  final String label;
  final bool isLive;
  final DriverVerification? driver;

  FleetMapDriverMarker({
    required this.id,
    required this.lat,
    required this.lng,
    required this.label,
    this.isLive = true,
    this.driver,
  });
}

class FleetMapMarker {
  final String id;
  final double lat;
  final double lng;
  final String label;
  final Color color;
  final String status;
  final double size;

  FleetMapMarker({
    required this.id,
    required this.lat,
    required this.lng,
    this.label = '',
    this.color = AppColors.primary,
    this.status = 'active',
    this.size = 36,
  });
}

class FleetMapRoute {
  final String id;
  final List<FleetMapPoint> points;
  final Color color;

  FleetMapRoute({required this.id, required this.points, this.color = AppColors.primary});
}

class FleetMapPoint {
  final double lat;
  final double lng;
  FleetMapPoint({required this.lat, required this.lng});
}
