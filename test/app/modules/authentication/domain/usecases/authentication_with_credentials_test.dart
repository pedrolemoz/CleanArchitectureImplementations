import 'package:clean_architecture_implementations/app/core/domain/entities/user.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/errors/authentication_failures.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/parameters/authentication_with_credentials_parameters.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/repositories/login_repository.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/usecases/authentication_with_credentials.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/utils/validators/authentication_validators.dart';
import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginRepositorySpy extends Mock implements LoginRepository {}

class AuthenticationValidatorsSpy extends Mock
    implements AuthenticationValidators {}

class UserFake extends Fake implements User {}

void main() {
  late LoginRepository repositorySpy;
  late AuthenticationValidators validatorsSpy;
  late AuthenticationWithCredentials usecase;

  setUp(() {
    registerFallbackValue(UserFake());
    repositorySpy = LoginRepositorySpy();
    validatorsSpy = AuthenticationValidatorsSpy();
    usecase = AuthenticationWithCredentialsImplementation(
      repositorySpy,
      validatorsSpy,
    );
  });

  test(
      'AuthenticationWithCredentialsImplementation should respect AuthenticationWithCredentials abstraction',
      () {
    // Assert
    expect(usecase, isA<AuthenticationWithCredentials>());
  });

  test('Should return User in success case', () async {
    // Arrange
    final tUser = UserFake();
    final tEmail = faker.internet.email();
    final tPassword = faker.internet.password();
    final tParameters = AuthenticationWithCredentialsParameters(
      email: tEmail,
      password: tPassword,
    );

    when(() => validatorsSpy.hasValidEmailAddress(tEmail)).thenReturn(true);
    when(() => validatorsSpy.hasValidPassword(tPassword)).thenReturn(true);
    when(() => repositorySpy.authenticationWithCredentials(tParameters))
        .thenAnswer((_) async => Right(tUser));

    // Act
    final result = await usecase(tParameters);

    // Assert
    expect(
      result.fold(id, id),
      isA<User>().having(
        (success) => success,
        'Has the expected entity',
        tUser,
      ),
    );
    verify(() => repositorySpy.authenticationWithCredentials(tParameters));
    verify(() => validatorsSpy.hasValidEmailAddress(tEmail));
    verify(() => validatorsSpy.hasValidPassword(tPassword));
    verifyNoMoreInteractions(repositorySpy);
    verifyNoMoreInteractions(validatorsSpy);
  });

  test(
      'Should return InvalidEmailFailure if the entered email does not match the requeriments',
      () async {
    // Arrange
    const tEmail = 'invalid-email#company.com';
    final tPassword = faker.internet.password();
    final tParameters = AuthenticationWithCredentialsParameters(
      email: tEmail,
      password: tPassword,
    );

    when(() => validatorsSpy.hasValidEmailAddress(tEmail)).thenReturn(false);

    // Act
    final result = await usecase(tParameters);

    // Assert
    expect(result.fold(id, id), isA<InvalidEmailFailure>());
    verify(() => validatorsSpy.hasValidEmailAddress(tEmail));
    verifyNoMoreInteractions(validatorsSpy);
    verifyZeroInteractions(repositorySpy);
  });

  test(
      'Should return InvalidPasswordFailure if the entered password does not match the requeriments',
      () async {
    // Arrange
    final tEmail = faker.internet.email();
    const tPassword = '';
    final tParameters = AuthenticationWithCredentialsParameters(
      email: tEmail,
      password: tPassword,
    );

    when(() => validatorsSpy.hasValidEmailAddress(tEmail)).thenReturn(true);
    when(() => validatorsSpy.hasValidPassword(tPassword)).thenReturn(false);

    // Act
    final result = await usecase(tParameters);

    // Assert
    expect(result.fold(id, id), isA<InvalidPasswordFailure>());
    verify(() => validatorsSpy.hasValidEmailAddress(tEmail));
    verify(() => validatorsSpy.hasValidPassword(tPassword));
    verifyNoMoreInteractions(validatorsSpy);
    verifyZeroInteractions(repositorySpy);
  });

  test('Should return AuthenticationFailure when an unexpected error occurs',
      () async {
    // Arrange
    final tEmail = faker.internet.email();
    final tPassword = faker.internet.password();
    final tParameters = AuthenticationWithCredentialsParameters(
      email: tEmail,
      password: tPassword,
    );
    const tErrorMessage = 'Unexpected error';

    when(() => validatorsSpy.hasValidEmailAddress(tEmail)).thenReturn(true);
    when(() => validatorsSpy.hasValidPassword(tPassword)).thenReturn(true);
    when(() => repositorySpy.authenticationWithCredentials(tParameters))
        .thenThrow(Exception(tErrorMessage));

    // Act
    final result = await usecase(tParameters);

    // Assert
    expect(
      result.fold(id, id),
      isA<AuthenticationFailure>().having(
        (failure) => failure.message,
        'Has the error message from exception',
        'Exception: $tErrorMessage',
      ),
    );
    verify(() => validatorsSpy.hasValidEmailAddress(tEmail));
    verify(() => validatorsSpy.hasValidPassword(tPassword));
    verify(() => repositorySpy.authenticationWithCredentials(tParameters));
    verifyNoMoreInteractions(validatorsSpy);
    verifyNoMoreInteractions(repositorySpy);
  });
}
