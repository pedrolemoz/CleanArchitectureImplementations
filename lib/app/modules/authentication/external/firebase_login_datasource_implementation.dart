import '../../../core/domain/entities/user.dart';
import '../../../core/external/checkers/network_connectivity_checker/abstractions/network_connectivity_checker.dart';
import '../../../core/infrastructure/exceptions/no_internet_connection_exception.dart';
import '../../../core/packages/firebase/firebase_authentication_client/abstraction/firebase_authentication_client.dart';
import '../../../core/packages/firebase/firebase_firestore_client/abstraction/firebase_firestore_client.dart';
import '../domain/parameters/authentication_with_credentials_parameters.dart';
import '../infrastructure/datasources/login_datasource.dart';
import '../infrastructure/mappers/user_mapper.dart';

class FirebaseLoginDataSourceImplementation implements LoginDataSource {
  final NetworkConnectivityChecker connectivityChecker;
  final FirebaseAuthenticationClient authenticationClient;
  final FirebaseFirestoreClient firestoreClient;

  const FirebaseLoginDataSourceImplementation(
    this.authenticationClient,
    this.firestoreClient,
    this.connectivityChecker,
  );

  @override
  Future<User> authenticationWithCredentials(
    AuthenticationWithCredentialsParameters parameters,
  ) async {
    if (await connectivityChecker.hasActiveNetwork()) {
      final user = await authenticationClient.authenticationWithCredentials(
        email: parameters.email,
        password: parameters.password,
      );

      final userData = await firestoreClient.getUserData(
        userUniqueIdentifier: user.uniqueIdentifier,
      );

      return UserMapper.fromFirebaseDocument(userData);
    }

    throw const NoInternetConnectionException();
  }
}
