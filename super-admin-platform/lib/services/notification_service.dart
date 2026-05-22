import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  NotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  Timer? _orderCheckTimer;
  int _lastOrderCount = 0;

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (!kIsWeb) {
      await localNotifier.setup(
        appName: 'Fleetora Enterprise OS',
      );
    }

    _isInitialized = true;
  }

  Future<void> showNewOrderNotification(String orderId, String driverName) async {
    if (!_isInitialized) await initialize();

    if (!kIsWeb) {
      final notification = LocalNotification(
        title: 'New Order Received',
        body: 'Order #$orderId assigned to $driverName',
      );
      await notification.show();
    }

    await _playNotificationSound();
  }

  Future<void> playAlertSound() => _playNotificationSound();

  Future<void> _playNotificationSound() async {
    if (kIsWeb) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/dispatch.wav'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }

  void stopSound() {
    _audioPlayer.stop();
  }

  void startOrderMonitoring(void Function(int) onNewOrder) {
    _orderCheckTimer?.cancel();
    _orderCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final currentOrderCount = _generateRandomOrderCount();
      if (currentOrderCount > _lastOrderCount) {
        final newOrders = currentOrderCount - _lastOrderCount;
        for (int i = 0; i < newOrders; i++) {
          final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
          final driverName = _getRandomDriverName();
          showNewOrderNotification(orderId, driverName);
          onNewOrder(newOrders);
        }
        _lastOrderCount = currentOrderCount;
      }
    });
  }

  void stopOrderMonitoring() {
    _orderCheckTimer?.cancel();
  }

  int _generateRandomOrderCount() {
    return _lastOrderCount + (DateTime.now().millisecond % 3 == 0 ? 1 : 0);
  }

  String _getRandomDriverName() {
    final drivers = ['John Smith', 'Mike Ross', 'Lisa Park', 'Sarah Connor', 'Alex Kim'];
    return drivers[DateTime.now().millisecond % drivers.length];
  }

  void dispose() {
    _orderCheckTimer?.cancel();
    _audioPlayer.dispose();
  }
}
