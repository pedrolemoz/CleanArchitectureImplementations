import '../../../../core/domain/entities/user.dart';
import '../../domain/parameters/authentication_with_credentials_parameters.dart';

abstract class LoginDataSource {
  Future<User> authenticationWithCredentials(
    AuthenticationWithCredentialsParameters parameters,
  );
}
