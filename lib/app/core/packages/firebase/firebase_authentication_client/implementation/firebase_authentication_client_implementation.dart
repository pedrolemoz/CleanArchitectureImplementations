import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../modules/authentication/infrastructure/errors/authentication_exceptions.dart';
import '../abstraction/firebase_authentication_client.dart';
import '../entities/firebase_user.dart';

class FirebaseAuthenticationClientImplementation
    implements FirebaseAuthenticationClient {
  @override
  Future<FirebaseUser> authenticationWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final authenticationService = FirebaseAuth.instance;

      final result = await authenticationService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return FirebaseUser(uniqueIdentifier: result.user!.uid);
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'user-not-found':
          throw NoUserFoundException();
        default:
          throw InvalidCredentialsException();
      }
    } catch (exception) {
      throw AuthenticationException(message: exception.toString());
    }
  }
}
