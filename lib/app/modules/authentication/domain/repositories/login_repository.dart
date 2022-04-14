import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/failure.dart';
import '../parameters/authentication_with_credentials_parameters.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> authenticationWithCredentials(
    AuthenticationWithCredentialsParameters parameters,
  );
}
