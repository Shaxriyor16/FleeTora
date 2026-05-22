import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;
import '../models/dashboard_models.dart';
import '../l10n/app_strings.dart';
import '../services/notification_service.dart';
import '../services/firestore_service.dart';
import '../services/realtime_service.dart';

class AppProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  bool _isAiAssistantOpen = false;
  bool _showNotificationsPanel = false;
  bool _isDarkMode = true;
  String _selectedLanguage = 'en';
  final List<String> _notifications = [];
  final List<AiAlert> _aiAlerts = [];
  final List<Company> _companies = [];
  final List<DriverVerification> _verifications = [];
  final List<Incident> _incidents = [];
  final List<FleetTruck> _fleetTrucks = [];
  final FleetStats _fleetStats = FleetStats();
  final AnalyticsData _analytics = AnalyticsData();
  double _simulatedFuel = 78.5;
  double _simulatedTemp = 92.3;
  int _simulatedRpm = 1850;
  int _activeSessions = 12;
  int _refreshTick = 0;
  Timer? _simulationTimer;

  final Map<String, bool> _notificationPrefs = {
    'push': true,
    'email': true,
    'sms': false,
    'aiSounds': true,
    'weeklyReports': true,
    'criticalOnly': false,
  };

  AppProvider() {
    _seedDemoAlerts();
    _seedDemoFleetAndDrivers();
    _startSimulation();
    _initializeNotifications();
    syncFromFirestore();
  }

  void _seedDemoFleetAndDrivers() {
    if (_fleetTrucks.isEmpty) {
      _fleetTrucks.addAll([
        FleetTruck(id: 'TK-4421', name: 'TK-4421', lat: 37.7749, lng: -122.4194, speed: 62, fuel: 78, status: 'active', driver: 'Omar H.', route: 'SF → LA'),
        FleetTruck(id: 'TK-2234', name: 'TK-2234', lat: 34.0522, lng: -118.2437, speed: 45, fuel: 55, status: 'active', driver: 'Lisa Park', route: 'LA Hub'),
        FleetTruck(id: 'TK-3312', name: 'TK-3312', lat: 36.7783, lng: -119.4179, speed: 0, fuel: 90, status: 'idle', driver: 'John Smith', route: 'Depot'),
      ]);
    }
    if (_verifications.isEmpty) {
      _verifications.addAll([
        DriverVerification(
          id: 'drv-1',
          name: 'Omar Hassan',
          email: 'omar.h@fleetora.app',
          phone: '+1 415 555 0142',
          passportNumber: 'AA1284567',
          dateOfBirth: '12.03.1990',
          nationality: 'UZ',
          passportIssued: '15.01.2018',
          passportExpiry: '15.01.2028',
          licenseNumber: 'DL-CA-884521',
          documentType: 'Passport',
          aiConfidence: 96.4,
          fraudProbability: 2.1,
          riskLevel: 'low',
          status: 'verified',
          imageUrl: 'https://i.pravatar.cc/200?u=omar-fleetora',
          lat: 37.7752,
          lng: -122.4188,
          speedKmh: 58,
          lastSeen: 'Just now',
          assignedTruckId: 'TK-4421',
        ),
        DriverVerification(
          id: 'drv-2',
          name: 'Lisa Park',
          email: 'lisa.p@fleetora.app',
          phone: '+1 310 555 0198',
          passportNumber: 'KR9023411',
          dateOfBirth: '08.07.1988',
          nationality: 'KR',
          passportIssued: '20.06.2019',
          passportExpiry: '20.06.2029',
          licenseNumber: 'DL-CA-772190',
          documentType: 'Passport',
          aiConfidence: 94.8,
          fraudProbability: 4.5,
          riskLevel: 'low',
          status: 'verified',
          imageUrl: 'https://i.pravatar.cc/200?u=lisa-fleetora',
          lat: 34.0518,
          lng: -118.2442,
          speedKmh: 42,
          lastSeen: 'Just now',
          assignedTruckId: 'TK-2234',
        ),
        DriverVerification(
          id: 'drv-3',
          name: 'John Smith',
          email: 'john.s@fleetora.app',
          phone: '+1 559 555 0111',
          passportNumber: 'US5543210',
          dateOfBirth: '22.11.1985',
          nationality: 'US',
          passportIssued: '10.02.2020',
          passportExpiry: '10.02.2030',
          licenseNumber: 'DL-CA-661002',
          documentType: 'Passport',
          aiConfidence: 88.2,
          fraudProbability: 12.0,
          riskLevel: 'medium',
          status: 'pending',
          imageUrl: 'https://i.pravatar.cc/200?u=john-fleetora',
          lat: 36.7780,
          lng: -119.4185,
          speedKmh: 0,
          lastSeen: '5m ago',
          assignedTruckId: 'TK-3312',
        ),
      ]);
    }
  }

  void _seedDemoAlerts() {
    if (_aiAlerts.isNotEmpty) return;
    _aiAlerts.addAll([
      AiAlert(id: '1', title: 'Fuel anomaly', description: 'Truck #4421 consumption +34%', type: 'fuel', severity: 'warning', time: '2m ago'),
      AiAlert(id: '2', title: 'Route deviation', description: 'TK-7789 off planned corridor', type: 'route', severity: 'warning', time: '8m ago'),
      AiAlert(id: '3', title: 'Fraud signal', description: 'Driver Omar H. duplicate docs', type: 'fraud', severity: 'critical', time: '15m ago'),
      AiAlert(id: '4', title: 'Maintenance due', description: 'Truck #3312 service in 48h', type: 'critical', severity: 'info', time: '1h ago'),
    ]);
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final rng = Random();
      _simulatedFuel = (_simulatedFuel - rng.nextDouble() * 0.5).clamp(0, 100);
      _simulatedTemp = _simulatedTemp + (rng.nextDouble() - 0.5) * 2;
      _simulatedRpm = 1500 + rng.nextInt(800);
      _tickLiveDriverPositions(rng);
      notifyListeners();
    });
  }

  void _tickLiveDriverPositions(Random rng) {
    for (var i = 0; i < _verifications.length; i++) {
      final d = _verifications[i];
      if (d.status != 'verified' || d.lat == 0) continue;
      final nlat = d.lat + (rng.nextDouble() - 0.5) * 0.008;
      final nlng = d.lng + (rng.nextDouble() - 0.5) * 0.008;
      final speed = (45 + rng.nextInt(25)).toDouble();
      _verifications[i] = DriverVerification(
        id: d.id,
        name: d.name,
        email: d.email,
        phone: d.phone,
        documentType: d.documentType,
        passportNumber: d.passportNumber,
        dateOfBirth: d.dateOfBirth,
        nationality: d.nationality,
        passportIssued: d.passportIssued,
        passportExpiry: d.passportExpiry,
        licenseNumber: d.licenseNumber,
        aiConfidence: d.aiConfidence,
        fraudProbability: d.fraudProbability,
        riskLevel: d.riskLevel,
        status: d.status,
        imageUrl: d.imageUrl,
        lat: nlat,
        lng: nlng,
        speedKmh: speed,
        lastSeen: 'Just now',
        assignedTruckId: d.assignedTruckId,
      );
    }
  }

  List<DriverVerification> get liveDriversOnMap =>
      _verifications.where((d) => d.isLiveOnMap).toList();

  DriverVerification? driverById(String id) {
    for (final d in _verifications) {
      if (d.id == id) return d;
    }
    return null;
  }

  void _initializeNotifications() {
    NotificationService.instance.initialize();
    NotificationService.instance.startOrderMonitoring((newOrders) {
      addNotification('$newOrders new order(s) received', playSound: true);
    });
  }

  void syncFromFirestore() {
    _loadFromFirestore();
    RealtimeService.instance.streamActiveSessions().listen((count) {
      _activeSessions = count;
      notifyListeners();
    });
  }

  Future<void> _loadFromFirestore() async {
    final companies = await FirestoreService.instance.getCompanies();
    if (companies.isNotEmpty) { _companies..clear()..addAll(companies); notifyListeners(); }
    final trucks = await FirestoreService.instance.getFleetTrucks();
    if (trucks.isNotEmpty) { _fleetTrucks..clear()..addAll(trucks); notifyListeners(); }
    final verifications = await FirestoreService.instance.getVerifications();
    if (verifications.isNotEmpty) { _verifications..clear()..addAll(verifications); notifyListeners(); }
    final incidents = await FirestoreService.instance.getIncidents();
    if (incidents.isNotEmpty) { _incidents..clear()..addAll(incidents); notifyListeners(); }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    NotificationService.instance.stopOrderMonitoring();
    super.dispose();
  }

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  void signIn() {
    _isSignedIn = true;
    syncFromFirestore();
    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  bool get isSidebarExpanded => _isSidebarExpanded;
  bool get isAiAssistantOpen => _isAiAssistantOpen;
  bool get showNotificationsPanel => _showNotificationsPanel;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  AppStrings get strings => AppStrings(_selectedLanguage);
  Locale get locale => strings.locale;
  int get fleetBadgeCount => 12;
  int get alertsBadgeCount => _aiAlerts.isEmpty ? 0 : 4;

  List<AiAlert> get allAlertsForPanel => List.unmodifiable(_aiAlerts.take(8));
  List<String> get notifications => _notifications;
  List<AiAlert> get aiAlerts => _aiAlerts;
  List<Company> get companies => _companies;
  List<DriverVerification> get verifications => _verifications;
  List<Incident> get incidents => _incidents;
  List<FleetTruck> get fleetTrucks => _fleetTrucks;
  FleetStats get fleetStats => _fleetStats;
  AnalyticsData get analytics => _analytics;
  double get simulatedFuel => _simulatedFuel;
  double get simulatedTemp => _simulatedTemp;
  int get simulatedRpm => _simulatedRpm;
  int get activeSessions => _activeSessions;
  int get refreshTick => _refreshTick;
  Map<String, bool> get notificationPrefs => Map.unmodifiable(_notificationPrefs);
  bool notificationEnabled(String key) => _notificationPrefs[key] ?? false;

  List<AiAlert> get criticalAlerts => _aiAlerts.where((a) => a.severity == 'critical').toList();
  List<Company> get pendingCompanies => _companies.where((c) => c.status == 'pending').toList();
  List<Company> get activeCompanies => _companies.where((c) => c.status == 'active').toList();
  List<Company> get suspendedCompanies => _companies.where((c) => c.status == 'suspended').toList();
  List<DriverVerification> get pendingVerifications => _verifications.where((v) => v.status == 'pending').toList();
  List<DriverVerification> get flaggedVerifications => _verifications.where((v) => v.status == 'flagged').toList();
  List<DriverVerification> get verifiedDrivers => _verifications.where((v) => v.status == 'verified').toList();

  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleSidebar() {
    _isSidebarExpanded = !_isSidebarExpanded;
    notifyListeners();
  }

  void toggleAiAssistant() {
    _isAiAssistantOpen = !_isAiAssistantOpen;
    if (_isAiAssistantOpen) _showNotificationsPanel = false;
    notifyListeners();
  }

  void toggleNotificationsPanel() {
    _showNotificationsPanel = !_showNotificationsPanel;
    if (_showNotificationsPanel) _isAiAssistantOpen = false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void closeNotificationsPanel() {
    if (_showNotificationsPanel) {
      _showNotificationsPanel = false;
      notifyListeners();
    }
  }

  void approveCompany(String id) {
    FirestoreService.instance.updateCompany(id, {'status': 'active'});
    addNotification('Company approved');
  }

  void rejectCompany(String id) {
    FirestoreService.instance.deleteCompany(id);
    addNotification('Company rejected');
  }

  void suspendCompany(String id) {
    FirestoreService.instance.updateCompany(id, {'status': 'suspended', 'isSuspended': true});
    addNotification('Company suspended');
  }

  void rejectVerification(String id) {
    FirestoreService.instance.deleteVerification(id);
    addNotification('Driver verification rejected');
  }

  void resolveIncident(String id) {
    FirestoreService.instance.updateIncident(id, {'status': 'resolved'});
    addNotification('Incident marked as resolved');
  }

  void addNotification(String notification, {bool playSound = true}) {
    _notifications.insert(0, notification);
    if (_notifications.length > 50) _notifications.removeLast();
    if (playSound && (_notificationPrefs['aiSounds'] ?? false)) {
      NotificationService.instance.playAlertSound();
    }
    notifyListeners();
  }

  void refreshDashboard() {
    _refreshTick++;
    _simulatedFuel = 78.5;
    _simulatedTemp = 92.3;
    _simulatedRpm = 1850;
    addNotification('Dashboard data refreshed', playSound: false);
    notifyListeners();
  }

  void addCompany({required String name, required String email}) {
    final company = Company(
      id: '',
      name: name,
      email: email,
      status: 'pending',
      trustScore: (55 + Random().nextInt(25)).toDouble(),
    );
    FirestoreService.instance.addCompany(company);
    addNotification('New application submitted: $name');
  }

  void inviteDriver({required String name, required String email}) {
    registerDriverWithDocuments(
      name: name,
      email: email,
      phone: '',
      passportNumber: '',
      dateOfBirth: '',
      nationality: '',
      passportIssued: '',
      passportExpiry: '',
      licenseNumber: '',
      imageUrl: '',
    );
  }

  /// Haydovchi ro'yxatdan o'tganda — pasport va KYC ma'lumotlari admin panelga tushadi.
  void registerDriverWithDocuments({
    required String name,
    required String email,
    required String phone,
    required String passportNumber,
    required String dateOfBirth,
    required String nationality,
    required String passportIssued,
    required String passportExpiry,
    required String licenseNumber,
    required String imageUrl,
  }) {
    final rng = Random();
    final ai = 85 + rng.nextDouble() * 14;
    final fraud = rng.nextDouble() * 18;
    final risk = fraud > 14 ? 'medium' : 'low';
    final baseLat = 37.77 + rng.nextDouble() * 0.5;
    final baseLng = -122.42 + rng.nextDouble() * 0.5;

    final v = DriverVerification(
      id: 'drv-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      passportNumber: passportNumber,
      dateOfBirth: dateOfBirth,
      nationality: nationality,
      passportIssued: passportIssued,
      passportExpiry: passportExpiry,
      licenseNumber: licenseNumber,
      documentType: 'Passport',
      aiConfidence: ai,
      fraudProbability: fraud,
      riskLevel: risk,
      status: 'pending',
      imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://i.pravatar.cc/200?u=${Uri.encodeComponent(email)}',
      lat: baseLat,
      lng: baseLng,
      speedKmh: 0,
      lastSeen: 'Just now',
      assignedTruckId: '',
    );
    _verifications.insert(0, v);
    FirestoreService.instance.addVerification(v);
    addNotification('New driver KYC: $name • Passport $passportNumber');
    notifyListeners();
  }

  void approveVerification(String id) {
    final idx = _verifications.indexWhere((v) => v.id == id);
    if (idx < 0) {
      FirestoreService.instance.updateVerification(id, {'status': 'verified'});
      addNotification('Driver verification approved');
      return;
    }
    final d = _verifications[idx];
    _verifications[idx] = DriverVerification(
      id: d.id,
      name: d.name,
      email: d.email,
      phone: d.phone,
      documentType: d.documentType,
      passportNumber: d.passportNumber,
      dateOfBirth: d.dateOfBirth,
      nationality: d.nationality,
      passportIssued: d.passportIssued,
      passportExpiry: d.passportExpiry,
      licenseNumber: d.licenseNumber,
      aiConfidence: d.aiConfidence,
      fraudProbability: d.fraudProbability,
      riskLevel: d.riskLevel,
      status: 'verified',
      imageUrl: d.imageUrl,
      lat: d.lat == 0 ? 37.78 : d.lat,
      lng: d.lng == 0 ? -122.41 : d.lng,
      speedKmh: 35,
      lastSeen: 'Just now',
      assignedTruckId: d.assignedTruckId,
    );
    FirestoreService.instance.updateVerification(id, {'status': 'verified'});
    addNotification('Driver verified — now visible LIVE on map');
    notifyListeners();
  }

  void toggleNotificationPref(String key) {
    if (_notificationPrefs.containsKey(key)) {
      _notificationPrefs[key] = !(_notificationPrefs[key] ?? false);
      notifyListeners();
    }
  }

  void saveSettings() {
    addNotification('Settings saved successfully');
    notifyListeners();
  }

  void revokeAllSessions() {
    _activeSessions = 1;
    addNotification('All sessions revoked except current device');
    notifyListeners();
  }

  void revokeSession(String deviceName) {
    if (_activeSessions > 1) _activeSessions--;
    addNotification('Session revoked: $deviceName');
    notifyListeners();
  }

  void downloadAuditLog() {
    addNotification('Audit log export started');
    notifyListeners();
  }

  void exportFleetReport() {
    addNotification('Fleet report exported');
    notifyListeners();
  }

  void openSearch() {
    addNotification('Search panel opened');
    notifyListeners();
  }

  void navigateFromProfile(String item) {
    switch (item) {
      case 'Profile Settings':
        selectIndex(9);
        break;
      case 'Account Security':
        selectIndex(8);
        break;
      case 'Billing & Plans':
        addNotification('Billing portal opened');
        break;
      case 'Help & Support':
        addNotification('Support chat opened');
        break;
      case 'Sign Out':
        addNotification('Sign out requested — confirm in dialog');
        break;
      default:
        addNotification('Navigated to $item');
    }
  }

  void markAllAlertsRead() {
    addNotification('All alerts marked as read');
    notifyListeners();
  }

  void dismissAlert(String id) {
    _aiAlerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
