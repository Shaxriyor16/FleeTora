import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_models.dart';
import 'firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  static FirebaseService get instance => _instance;
  FirebaseService._internal();

  String get apiKey => DefaultFirebaseOptions.currentPlatform.apiKey;
  String get projectId => DefaultFirebaseOptions.currentPlatform.projectId;
  String get dbUrl => DefaultFirebaseOptions.currentPlatform.databaseURL ?? 'https://$projectId-default-rtdb.europe-west1.firebasedatabase.app';
  String get bucket => DefaultFirebaseOptions.currentPlatform.storageBucket;

  String _authUrl(String path) => 'https://identitytoolkit.googleapis.com/v1/accounts:$path?key=$apiKey';
  String _firestoreUrl(String collection) => 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection';
  String _rtdbUrl(String path) => '$dbUrl/$path.json';

  Future<String?> signIn(String email, String password) async {
    final res = await http.post(
      Uri.parse(_authUrl('signInWithPassword')),
      body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return null;
    return _authErrorMessage(res.body, 'Auth failed');
  }

  Future<String?> register(String email, String password) async {
    final res = await http.post(
      Uri.parse(_authUrl('signUp')),
      body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return null;
    return _authErrorMessage(res.body, 'Registration failed');
  }

  String _authErrorMessage(String body, String fallback) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final code = json['error']?['message'] as String? ?? fallback;
      return switch (code) {
        'EMAIL_NOT_FOUND' => 'Email topilmadi. Demo hisobdan foydalaning yoki ro\'yxatdan o\'ting.',
        'INVALID_PASSWORD' => 'Parol noto\'g\'ri.',
        'INVALID_LOGIN_CREDENTIALS' => 'Email yoki parol noto\'g\'ri.',
        'EMAIL_EXISTS' => 'Bu email allaqachon ro\'yxatdan o\'tgan.',
        'WEAK_PASSWORD' => 'Parol kamida 6 belgidan iborat bo\'lishi kerak.',
        'INVALID_EMAIL' => 'Email formati noto\'g\'ri.',
        'TOO_MANY_ATTEMPTS_TRY_LATER' => 'Juda ko\'p urinish. Biroz kutib qayta urinib ko\'ring.',
        _ => code,
      };
    } catch (_) {
      return fallback;
    }
  }

  Future<List<Company>> getCompanies() async {
    final res = await http.get(Uri.parse(_firestoreUrl('companies')));
    if (res.statusCode != 200) return [];
    return _parseFirestoreDocs<Company>(res.body, Company.fromMap);
  }

  Future<void> addCompany(Company company) async {
    await http.post(
      Uri.parse(_firestoreUrl('companies')),
      body: jsonEncode({'fields': _toFirestoreFields(company.toMap())}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> updateCompany(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('${_firestoreUrl('companies')}/$id'),
      body: jsonEncode({'fields': _toFirestoreFields(data)}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> deleteCompany(String id) async {
    await http.delete(Uri.parse('${_firestoreUrl('companies')}/$id'));
  }

  Future<List<FleetTruck>> getFleetTrucks() async {
    final res = await http.get(Uri.parse(_firestoreUrl('fleet')));
    if (res.statusCode != 200) return [];
    return _parseFirestoreDocs<FleetTruck>(res.body, FleetTruck.fromMap);
  }

  Future<void> updateTruck(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('${_firestoreUrl('fleet')}/$id'),
      body: jsonEncode({'fields': _toFirestoreFields(data)}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<DriverVerification>> getVerifications() async {
    final res = await http.get(Uri.parse(_firestoreUrl('drivers')));
    if (res.statusCode != 200) return [];
    return _parseFirestoreDocs<DriverVerification>(res.body, DriverVerification.fromMap);
  }

  Future<void> addVerification(DriverVerification v) async {
    await http.post(
      Uri.parse(_firestoreUrl('drivers')),
      body: jsonEncode({'fields': _toFirestoreFields(v.toMap())}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> updateVerification(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('${_firestoreUrl('drivers')}/$id'),
      body: jsonEncode({'fields': _toFirestoreFields(data)}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> deleteVerification(String id) async {
    await http.delete(Uri.parse('${_firestoreUrl('drivers')}/$id'));
  }

  Future<List<Incident>> getIncidents() async {
    final res = await http.get(Uri.parse(_firestoreUrl('incidents')));
    if (res.statusCode != 200) return [];
    return _parseFirestoreDocs<Incident>(res.body, Incident.fromMap);
  }

  Future<void> addIncident(Incident incident) async {
    await http.post(
      Uri.parse(_firestoreUrl('incidents')),
      body: jsonEncode({'fields': _toFirestoreFields(incident.toMap())}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> updateIncident(String id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('${_firestoreUrl('incidents')}/$id'),
      body: jsonEncode({'fields': _toFirestoreFields(data)}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> writeTelemetry(String truckId, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse(_rtdbUrl('telemetry/$truckId')),
      body: jsonEncode(data),
    );
  }

  Future<Map<String, dynamic>> readTelemetry(String truckId) async {
    final res = await http.get(Uri.parse(_rtdbUrl('telemetry/$truckId')));
    if (res.statusCode != 200) return {};
    return jsonDecode(res.body) as Map<String, dynamic>? ?? {};
  }

  Stream<int> streamActiveSessions() {
    return Stream.periodic(const Duration(seconds: 10), (_) => 12);
  }

  List<T> _parseFirestoreDocs<T>(String body, T Function(String id, Map<String, dynamic>) fromMap) {
    final json = jsonDecode(body);
    final docs = json['documents'] as List<dynamic>?;
    if (docs == null) return [];
    return docs.map((doc) {
      final name = doc['name'] as String;
      final id = name.split('/').last;
      final fields = _fromFirestoreFields(doc['fields'] as Map<String, dynamic>? ?? {});
      return fromMap(id, fields);
    }).toList();
  }

  Map<String, dynamic> _fromFirestoreFields(Map<String, dynamic> fields) {
    final result = <String, dynamic>{};
    fields.forEach((key, value) {
      if (value is Map) {
        if (value.containsKey('stringValue')) {
          result[key] = value['stringValue'];
        } else if (value.containsKey('integerValue')) {
          result[key] = int.tryParse(value['integerValue'] ?? '0') ?? 0;
        } else if (value.containsKey('doubleValue')) {
          result[key] = (value['doubleValue'] as num?)?.toDouble() ?? 0.0;
        } else if (value.containsKey('booleanValue')) {
          result[key] = value['booleanValue'];
        } else if (value.containsKey('arrayValue')) {
          result[key] = value['arrayValue']['values'] ?? [];
        } else if (value.containsKey('mapValue')) {
          result[key] = _fromFirestoreFields(value['mapValue']['fields'] as Map<String, dynamic>? ?? {});
        }
      }
    });
    return result;
  }

  Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is String) {
        result[key] = {'stringValue': value};
      } else if (value is int) {
        result[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        result[key] = {'doubleValue': value};
      } else if (value is bool) {
        result[key] = {'booleanValue': value};
      } else if (value == null) {
        result[key] = {'nullValue': null};
      }
    });
    return result;
  }

  Future<String?> uploadFile(String path, List<int> bytes) async {
    final encoded = Uri.encodeComponent(path);
    final res = await http.post(
      Uri.parse('https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encoded'),
      body: bytes,
    );
    if (res.statusCode == 200) {
      final name = jsonDecode(res.body)['name'] as String;
      return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/${Uri.encodeComponent(name)}?alt=media';
    }
    return null;
  }
}
