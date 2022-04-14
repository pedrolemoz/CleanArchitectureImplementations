import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/usecases/async_usecase.dart';
import '../../utils/validators/authentication_validators.dart';
import '../errors/authentication_failures.dart';
import '../parameters/authentication_with_credentials_parameters.dart';
import '../repositories/login_repository.dart';

abstract class AuthenticationWithCredentials
    implements AsyncUsecase<User, AuthenticationWithCredentialsParameters> {}

class AuthenticationWithCredentialsImplementation
    implements AuthenticationWithCredentials {
  final LoginRepository repository;
  final AuthenticationValidators validators;

  const AuthenticationWithCredentialsImplementation(
    this.repository,
    this.validators,
  );

  @override
  Future<Either<Failure, User>> call(
    AuthenticationWithCredentialsParameters parameters,
  ) async {
    try {
      if (!validators.hasValidEmailAddress(parameters.email)) {
        return Left(InvalidEmailFailure());
      }

      if (!validators.hasValidPassword(parameters.password)) {
        return Left(InvalidPasswordFailure());
      }

      return await repository.authenticationWithCredentials(parameters);
    } catch (exception) {
      return Left(AuthenticationFailure(message: exception.toString()));
    }
  }
}
