import '../entities/firebase_user.dart';

abstract class FirebaseAuthenticationClient {
  Future<FirebaseUser> authenticationWithCredentials({
    required String email,
    required String password,
  });
}
