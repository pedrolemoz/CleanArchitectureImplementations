import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/errors/failure.dart';
import '../../../../core/infrastructure/handlers/core_exceptions_handler.dart';
import '../../domain/errors/authentication_failures.dart';
import '../../domain/parameters/authentication_with_credentials_parameters.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_datasource.dart';
import '../errors/authentication_exceptions.dart';

class LoginRepositoryImplementation implements LoginRepository {
  final LoginDataSource dataSource;
  final CoreExceptionsHandler coreExceptionsHandler;

  const LoginRepositoryImplementation(
    this.dataSource,
    this.coreExceptionsHandler,
  );

  @override
  Future<Either<Failure, User>> authenticationWithCredentials(
    AuthenticationWithCredentialsParameters parameters,
  ) async {
    try {
      final result = await dataSource.authenticationWithCredentials(parameters);

      return Right(result);
    } on InvalidCredentialsException {
      return Left(InvalidCredentialsFailure());
    } on NoUserFoundException {
      return Left(NoUserFoundFailure());
    } catch (exception) {
      return coreExceptionsHandler.handleException<User>(
        exception,
        onExceptionMismatch: () async => Left(
          AuthenticationFailure(message: exception.toString()),
        ),
      );
    }
  }
}
