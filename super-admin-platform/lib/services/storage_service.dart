import 'firebase_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;
  StorageService._internal();

  final FirebaseService _fb = FirebaseService.instance;

  Future<String?> uploadFile(String path, List<int> bytes) => _fb.uploadFile(path, bytes);
}
