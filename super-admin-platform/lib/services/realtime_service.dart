import 'dart:async';
import 'firebase_service.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  static RealtimeService get instance => _instance;
  RealtimeService._internal();

  final FirebaseService _fb = FirebaseService.instance;

  Future<void> writeTelemetry(String truckId, Map<String, dynamic> data) => _fb.writeTelemetry(truckId, data);
  Future<Map<String, dynamic>> readTelemetry(String truckId) => _fb.readTelemetry(truckId);
  Stream<int> streamActiveSessions() => _fb.streamActiveSessions();
}
