import 'firebase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;
  AuthService._internal();

  final FirebaseService _fb = FirebaseService.instance;

  Future<String?> signInWithEmail(String email, String password) async {
    return _fb.signIn(email, password);
  }

  Future<String?> registerWithEmail(String email, String password) async {
    return _fb.register(email, password);
  }
}
