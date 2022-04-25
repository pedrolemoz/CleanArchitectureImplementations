import 'package:clean_architecture_implementations/app/core/domain/entities/user.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/handlers/core_exceptions_handler.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/handlers/core_exceptions_handler_implementation.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/errors/authentication_failures.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/parameters/authentication_with_credentials_parameters.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/repositories/login_repository.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/datasources/login_datasource.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/errors/authentication_exceptions.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/repositories/login_repository_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginDataSourceSpy extends Mock implements LoginDataSource {}

class UserFake extends Fake implements User {}

class AuthenticationWithCredentialsParametersFake extends Fake
    implements AuthenticationWithCredentialsParameters {}

void main() {
  late CoreExceptionsHandler coreExceptionsHandler;
  late LoginDataSource dataSourceSpy;
  late LoginRepository repository;

  final tParameters = AuthenticationWithCredentialsParametersFake();
  final tUser = UserFake();

  setUp(() {
    registerFallbackValue(AuthenticationWithCredentialsParametersFake());
    registerFallbackValue(UserFake());
    dataSourceSpy = LoginDataSourceSpy();
    coreExceptionsHandler = CoreExceptionsHandlerImplementation();
    repository = LoginRepositoryImplementation(
      dataSourceSpy,
      coreExceptionsHandler,
    );
  });

  test(
      'LoginRepositoryImplementation should respect LoginRepository abstraction',
      () async {
    // Assert
    expect(repository, isA<LoginRepository>());
  });

  test('Should return User in success case', () async {
    // Arrange
    when(() => dataSourceSpy.authenticationWithCredentials(tParameters))
        .thenAnswer((_) async => tUser);

    // Act
    final result = await repository.authenticationWithCredentials(tParameters);

    // Assert
    expect(
      result.fold(id, id),
      isA<User>().having(
        (success) => success,
        'Has the expected entity',
        tUser,
      ),
    );
    verify(() => dataSourceSpy.authenticationWithCredentials(tParameters));
    verifyNoMoreInteractions(dataSourceSpy);
  });

  test(
      'Should return InvalidCredentialsFailure when the DataSource throw InvalidCredentialsException',
      () async {
    // Arrange
    when(() => dataSourceSpy.authenticationWithCredentials(tParameters))
        .thenThrow(InvalidCredentialsException());

    // Act
    final result = await repository.authenticationWithCredentials(tParameters);

    // Assert
    expect(result.fold(id, id), isA<InvalidCredentialsFailure>());
    verify(() => dataSourceSpy.authenticationWithCredentials(tParameters));
    verifyNoMoreInteractions(dataSourceSpy);
  });

  test(
      'Should return NoUserFoundFailure when the DataSource throw NoUserFoundException',
      () async {
    // Arrange
    when(() => dataSourceSpy.authenticationWithCredentials(tParameters))
        .thenThrow(NoUserFoundException());

    // Act
    final result = await repository.authenticationWithCredentials(tParameters);

    // Assert
    expect(result.fold(id, id), isA<NoUserFoundFailure>());
    verify(() => dataSourceSpy.authenticationWithCredentials(tParameters));
    verifyNoMoreInteractions(dataSourceSpy);
  });

  test(
      'Should return AuthenticationFailure when the DataSource throw an unexpected exception',
      () async {
    // Arrange
    const tErrorMessage = 'Unexpected error';
    final tException = Exception(tErrorMessage);
    when(() => dataSourceSpy.authenticationWithCredentials(tParameters))
        .thenThrow(tException);

    // Act
    final result = await repository.authenticationWithCredentials(tParameters);

    // Assert
    expect(
      result.fold(id, id),
      isA<AuthenticationFailure>().having(
        (failure) => failure.message,
        'Has the error message from exception',
        'Exception: $tErrorMessage',
      ),
    );
    verify(() => dataSourceSpy.authenticationWithCredentials(tParameters));
    verifyNoMoreInteractions(dataSourceSpy);
  });
}
