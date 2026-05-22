import '../models/dashboard_models.dart';
import 'firebase_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  static FirestoreService get instance => _instance;
  FirestoreService._internal();

  final FirebaseService _fb = FirebaseService.instance;

  Future<List<Company>> getCompanies() => _fb.getCompanies();
  Future<void> addCompany(Company company) => _fb.addCompany(company);
  Future<void> updateCompany(String id, Map<String, dynamic> data) => _fb.updateCompany(id, data);
  Future<void> deleteCompany(String id) => _fb.deleteCompany(id);

  Future<List<DriverVerification>> getVerifications() => _fb.getVerifications();
  Future<void> addVerification(DriverVerification v) => _fb.addVerification(v);
  Future<void> updateVerification(String id, Map<String, dynamic> data) => _fb.updateVerification(id, data);
  Future<void> deleteVerification(String id) => _fb.deleteVerification(id);

  Future<List<Incident>> getIncidents() => _fb.getIncidents();
  Future<void> addIncident(Incident incident) => _fb.addIncident(incident);
  Future<void> updateIncident(String id, Map<String, dynamic> data) => _fb.updateIncident(id, data);

  Future<List<FleetTruck>> getFleetTrucks() => _fb.getFleetTrucks();
  Future<void> updateTruck(String id, Map<String, dynamic> data) => _fb.updateTruck(id, data);
}
