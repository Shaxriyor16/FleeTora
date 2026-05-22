import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_models.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/common/glass_card.dart';

import '../widgets/common/status_indicator.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('Active', '${provider.incidents.where((i) => i.status == 'active').length}', Icons.warning, AppColors.error)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatCard('Investigating', '${provider.incidents.where((i) => i.status == 'investigating').length}', Icons.search, AppColors.warning)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatCard('Monitoring', '${provider.incidents.where((i) => i.status == 'monitoring').length}', Icons.visibility, AppColors.info)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildStatCard('Resolved', '${provider.incidents.where((i) => i.status == 'resolved').length}', Icons.check_circle, AppColors.success)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildActiveIncidents(provider),
                  const SizedBox(height: 20),
                  _buildIncidentTimeline(provider),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(AppProvider provider) {
    final activeCount = provider.incidents.where((i) => i.status == 'active').length;
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('INCIDENT RESPONSE', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
            SizedBox(height: 4),
            Text('Emergency Command Center', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        if (activeCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const StatusIndicator(color: AppColors.error, size: 8),
                const SizedBox(width: 8),
                Text(
                  '$activeCount Active Emergency',
                  style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveIncidents(AppProvider provider) {
    final active = provider.incidents.where((i) => i.status != 'resolved').toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: AppColors.error, size: 16),
              SizedBox(width: 8),
              Text('ACTIVE INCIDENTS', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
        ),
        ...active.map((incident) => _buildIncidentCard(incident, provider)),
        if (active.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(32),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 48),
                  SizedBox(height: 12),
                  Text('No active incidents', style: TextStyle(color: AppColors.success, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('All systems are operational', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIncidentCard(Incident incident, AppProvider provider) {
    Color severityColor;
    IconData typeIcon;
    switch (incident.type.toLowerCase()) {
      case 'sos': severityColor = AppColors.neonRed; typeIcon = Icons.sos; break;
      case 'crash': severityColor = AppColors.error; typeIcon = Icons.car_crash; break;
      case 'theft': severityColor = AppColors.warning; typeIcon = Icons.lock; break;
      case 'breakdown': severityColor = AppColors.warning; typeIcon = Icons.build; break;
      case 'weather': severityColor = AppColors.info; typeIcon = Icons.thunderstorm; break;
      default: severityColor = AppColors.textMuted; typeIcon = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: severityColor.withValues(alpha: 0.3)),
              ),
              child: Icon(typeIcon, color: severityColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(incident.type, style: TextStyle(color: severityColor, fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: severityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(incident.severity.toUpperCase(), style: TextStyle(color: severityColor, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(incident.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('${incident.location} • ${incident.truckId} • ${incident.driverName}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (incident.status == 'active' ? AppColors.error : incident.status == 'investigating' ? AppColors.warning : AppColors.info).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    incident.status.toUpperCase(),
                    style: TextStyle(
                      color: incident.status == 'active' ? AppColors.error : incident.status == 'investigating' ? AppColors.warning : AppColors.info,
                      fontSize: 9, fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(incident.time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                const SizedBox(height: 8),
                if (incident.status != 'resolved')
                  GestureDetector(
                    onTap: () => provider.resolveIncident(incident.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Resolve', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentTimeline(AppProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text('INCIDENT TIMELINE', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.incidents.map((incident) => _buildTimelineEntry(incident)),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(Incident incident) {
    Color color;
    switch (incident.status) {
      case 'active': color = AppColors.error; break;
      case 'investigating': color = AppColors.warning; break;
      case 'monitoring': color = AppColors.info; break;
      default: color = AppColors.success;
    }

    IconData icon;
    switch (incident.type.toLowerCase()) {
      case 'sos': icon = Icons.sos; break;
      case 'crash': icon = Icons.car_crash; break;
      case 'theft': icon = Icons.lock; break;
      case 'breakdown': icon = Icons.build; break;
      default: icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              Container(width: 1, height: 24, color: AppColors.glassBorder),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(incident.type, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
                    const Spacer(),
                    Text(incident.time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  ],
                ),
                Text(incident.description, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
