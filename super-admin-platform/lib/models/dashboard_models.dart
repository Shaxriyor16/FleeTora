class FleetStats {
  final int totalTrucks;
  final int onlineDrivers;
  final int activeDeliveries;
  final int aiAlerts;
  final double fuelAvg;
  final double revenue;
  final double fuelChange;
  final double revenueChange;
  final double riskScore;
  final int suspiciousActivities;

  FleetStats({
    this.totalTrucks = 1284,
    this.onlineDrivers = 892,
    this.activeDeliveries = 3456,
    this.aiAlerts = 23,
    this.fuelAvg = 2.4,
    this.revenue = 12.8,
    this.fuelChange = -3.2,
    this.revenueChange = 8.7,
    this.riskScore = 94.2,
    this.suspiciousActivities = 7,
  });

  Map<String, dynamic> toMap() => {
    'totalTrucks': totalTrucks, 'onlineDrivers': onlineDrivers,
    'activeDeliveries': activeDeliveries, 'aiAlerts': aiAlerts,
    'fuelAvg': fuelAvg, 'revenue': revenue,
    'fuelChange': fuelChange, 'revenueChange': revenueChange,
    'riskScore': riskScore, 'suspiciousActivities': suspiciousActivities,
  };
}

class AiAlert {
  final String id;
  final String title;
  final String description;
  final String type;
  final String severity;
  final String time;
  final bool isActive;

  AiAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.severity = 'warning',
    this.time = '2m ago',
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'description': description,
    'type': type, 'severity': severity, 'time': time, 'isActive': isActive,
  };
}

class FleetTruck {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final double speed;
  final double fuel;
  final String status;
  final String driver;
  final String route;

  FleetTruck({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.speed = 0,
    this.fuel = 100,
    this.status = 'active',
    this.driver = 'Unknown',
    this.route = 'Unknown',
  });

  factory FleetTruck.fromMap(String id, Map<String, dynamic> map) => FleetTruck(
    id: id, name: map['name'] as String? ?? '',
    lat: (map['lat'] as num?)?.toDouble() ?? 0,
    lng: (map['lng'] as num?)?.toDouble() ?? 0,
    speed: (map['speed'] as num?)?.toDouble() ?? 0,
    fuel: (map['fuel'] as num?)?.toDouble() ?? 100,
    status: map['status'] as String? ?? 'active',
    driver: map['driver'] as String? ?? 'Unknown',
    route: map['route'] as String? ?? 'Unknown',
  );

  Map<String, dynamic> toMap() => {
    'name': name, 'lat': lat, 'lng': lng,
    'speed': speed, 'fuel': fuel, 'status': status,
    'driver': driver, 'route': route,
  };
}

class Company {
  final String id;
  final String name;
  final String email;
  final String logo;
  final String status;
  final double trustScore;
  final double revenue;
  final int trucks;
  final int drivers;
  final bool isSuspended;

  Company({
    required this.id,
    required this.name,
    required this.email,
    this.logo = '',
    this.status = 'pending',
    this.trustScore = 0,
    this.revenue = 0,
    this.trucks = 0,
    this.drivers = 0,
    this.isSuspended = false,
  });

  factory Company.fromMap(String id, Map<String, dynamic> map) => Company(
    id: id, name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    logo: map['logo'] as String? ?? '',
    status: map['status'] as String? ?? 'pending',
    trustScore: (map['trustScore'] as num?)?.toDouble() ?? 0,
    revenue: (map['revenue'] as num?)?.toDouble() ?? 0,
    trucks: map['trucks'] as int? ?? 0,
    drivers: map['drivers'] as int? ?? 0,
    isSuspended: map['isSuspended'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'name': name, 'email': email, 'logo': logo,
    'status': status, 'trustScore': trustScore, 'revenue': revenue,
    'trucks': trucks, 'drivers': drivers, 'isSuspended': isSuspended,
  };
}

class DriverVerification {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String documentType;
  final String passportNumber;
  final String dateOfBirth;
  final String nationality;
  final String passportIssued;
  final String passportExpiry;
  final String licenseNumber;
  final double aiConfidence;
  final double fraudProbability;
  final String riskLevel;
  final String status;
  final String imageUrl;
  final double lat;
  final double lng;
  final double speedKmh;
  final String lastSeen;
  final String assignedTruckId;

  DriverVerification({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.documentType = 'Passport',
    this.passportNumber = '',
    this.dateOfBirth = '',
    this.nationality = '',
    this.passportIssued = '',
    this.passportExpiry = '',
    this.licenseNumber = '',
    this.aiConfidence = 0,
    this.fraudProbability = 0,
    this.riskLevel = 'low',
    this.status = 'pending',
    this.imageUrl = '',
    this.lat = 0,
    this.lng = 0,
    this.speedKmh = 0,
    this.lastSeen = '',
    this.assignedTruckId = '',
  });

  bool get hasPassportData => passportNumber.isNotEmpty;
  bool get isLiveOnMap => status == 'verified' && lat != 0 && lng != 0;

  factory DriverVerification.fromMap(String id, Map<String, dynamic> map) => DriverVerification(
    id: id,
    name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
    documentType: map['documentType'] as String? ?? 'Passport',
    passportNumber: map['passportNumber'] as String? ?? '',
    dateOfBirth: map['dateOfBirth'] as String? ?? '',
    nationality: map['nationality'] as String? ?? '',
    passportIssued: map['passportIssued'] as String? ?? '',
    passportExpiry: map['passportExpiry'] as String? ?? '',
    licenseNumber: map['licenseNumber'] as String? ?? '',
    aiConfidence: (map['aiConfidence'] as num?)?.toDouble() ?? 0,
    fraudProbability: (map['fraudProbability'] as num?)?.toDouble() ?? 0,
    riskLevel: map['riskLevel'] as String? ?? 'low',
    status: map['status'] as String? ?? 'pending',
    imageUrl: map['imageUrl'] as String? ?? '',
    lat: (map['lat'] as num?)?.toDouble() ?? 0,
    lng: (map['lng'] as num?)?.toDouble() ?? 0,
    speedKmh: (map['speedKmh'] as num?)?.toDouble() ?? 0,
    lastSeen: map['lastSeen'] as String? ?? '',
    assignedTruckId: map['assignedTruckId'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'documentType': documentType,
    'passportNumber': passportNumber,
    'dateOfBirth': dateOfBirth,
    'nationality': nationality,
    'passportIssued': passportIssued,
    'passportExpiry': passportExpiry,
    'licenseNumber': licenseNumber,
    'aiConfidence': aiConfidence,
    'fraudProbability': fraudProbability,
    'riskLevel': riskLevel,
    'status': status,
    'imageUrl': imageUrl,
    'lat': lat,
    'lng': lng,
    'speedKmh': speedKmh,
    'lastSeen': lastSeen,
    'assignedTruckId': assignedTruckId,
  };
}

class TelemetryData {
  final double fuelLevel;
  final double engineTemp;
  final int rpm;
  final double batteryStatus;
  final double tirePressure;
  final double oilPressure;
  final int errorCodes;
  final String engineHealth;
  final String driverBehavior;

  TelemetryData({
    this.fuelLevel = 78.5,
    this.engineTemp = 92.3,
    this.rpm = 1850,
    this.batteryStatus = 85.0,
    this.tirePressure = 95.0,
    this.oilPressure = 88.0,
    this.errorCodes = 0,
    this.engineHealth = 'optimal',
    this.driverBehavior = 'normal',
  });

  factory TelemetryData.fromMap(Map<String, dynamic> map) => TelemetryData(
    fuelLevel: (map['fuelLevel'] as num?)?.toDouble() ?? 0,
    engineTemp: (map['engineTemp'] as num?)?.toDouble() ?? 0,
    rpm: map['rpm'] as int? ?? 0,
    batteryStatus: (map['batteryStatus'] as num?)?.toDouble() ?? 0,
    tirePressure: (map['tirePressure'] as num?)?.toDouble() ?? 0,
    oilPressure: (map['oilPressure'] as num?)?.toDouble() ?? 0,
    errorCodes: map['errorCodes'] as int? ?? 0,
    engineHealth: map['engineHealth'] as String? ?? 'optimal',
    driverBehavior: map['driverBehavior'] as String? ?? 'normal',
  );

  Map<String, dynamic> toMap() => {
    'fuelLevel': fuelLevel, 'engineTemp': engineTemp, 'rpm': rpm,
    'batteryStatus': batteryStatus, 'tirePressure': tirePressure,
    'oilPressure': oilPressure, 'errorCodes': errorCodes,
    'engineHealth': engineHealth, 'driverBehavior': driverBehavior,
  };
}

class Incident {
  final String id;
  final String type;
  final String severity;
  final String description;
  final String location;
  final String time;
  final String status;
  final String driverName;
  final String truckId;

  Incident({
    required this.id,
    required this.type,
    required this.severity,
    required this.description,
    required this.location,
    required this.time,
    this.status = 'active',
    this.driverName = 'Unknown',
    this.truckId = 'Unknown',
  });

  factory Incident.fromMap(String id, Map<String, dynamic> map) => Incident(
    id: id, type: map['type'] as String? ?? 'Unknown',
    severity: map['severity'] as String? ?? 'medium',
    description: map['description'] as String? ?? '',
    location: map['location'] as String? ?? '',
    time: map['time'] as String? ?? '',
    status: map['status'] as String? ?? 'active',
    driverName: map['driverName'] as String? ?? 'Unknown',
    truckId: map['truckId'] as String? ?? 'Unknown',
  );

  Map<String, dynamic> toMap() => {
    'type': type, 'severity': severity, 'description': description,
    'location': location, 'time': time, 'status': status,
    'driverName': driverName, 'truckId': truckId,
  };
}

class AnalyticsData {
  final List<double> revenue;
  final List<double> fuelCost;
  final List<double> driverPerformance;
  final List<double> fleetEfficiency;
  final List<double> aiRiskMetrics;
  final List<String> months;

  AnalyticsData({
    this.revenue = const [12.4, 14.2, 13.8, 16.1, 18.5, 20.2, 22.8, 24.1, 26.3],
    this.fuelCost = const [8.2, 7.9, 8.5, 7.2, 6.8, 6.5, 5.9, 5.5, 5.1],
    this.driverPerformance = const [72, 75, 78, 82, 85, 88, 90, 92, 94],
    this.fleetEfficiency = const [65, 68, 72, 75, 78, 82, 85, 87, 90],
    this.aiRiskMetrics = const [15, 12, 18, 10, 8, 6, 4, 3, 2],
    this.months = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
  });
}
