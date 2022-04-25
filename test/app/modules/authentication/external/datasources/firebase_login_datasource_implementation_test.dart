import 'package:clean_architecture_implementations/app/core/domain/entities/user.dart';
import 'package:clean_architecture_implementations/app/core/external/checkers/network_connectivity_checker/abstractions/network_connectivity_checker.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/exceptions/no_internet_connection_exception.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/exceptions/unable_to_get_user_data_exception.dart';
import 'package:clean_architecture_implementations/app/core/packages/firebase/firebase_authentication_client/abstraction/firebase_authentication_client.dart';
import 'package:clean_architecture_implementations/app/core/packages/firebase/firebase_authentication_client/entities/firebase_user.dart';
import 'package:clean_architecture_implementations/app/core/packages/firebase/firebase_firestore_client/abstraction/firebase_firestore_client.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/domain/parameters/authentication_with_credentials_parameters.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/external/firebase_login_datasource_implementation.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/datasources/login_datasource.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/errors/authentication_exceptions.dart';
import 'package:clean_architecture_implementations/app/modules/authentication/infrastructure/mappers/user_mapper.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/user_data_mock.dart';

class FirebaseAuthenticationClientSpy extends Mock
    implements FirebaseAuthenticationClient {}

class FirebaseFirestoreClientSpy extends Mock
    implements FirebaseFirestoreClient {}

class NetworkConnectivityCheckerSpy extends Mock
    implements NetworkConnectivityChecker {}

void main() {
  late LoginDataSource dataSource;
  late FirebaseAuthenticationClient authenticationClientSpy;
  late FirebaseFirestoreClient firestoreClientSpy;
  late NetworkConnectivityChecker connectivityCheckerSpy;

  final tEmail = faker.internet.email();
  final tPassword = faker.internet.password(length: 16);
  final tParameters = AuthenticationWithCredentialsParameters(
    email: tEmail,
    password: tPassword,
  );
  final tUniqueIdentifier = faker.guid.guid();
  final tFirebaseUser = FirebaseUser(uniqueIdentifier: tUniqueIdentifier);
  final tUser = UserMapper.fromFirebaseDocument(userDataMock);

  setUp(() {
    connectivityCheckerSpy = NetworkConnectivityCheckerSpy();
    authenticationClientSpy = FirebaseAuthenticationClientSpy();
    firestoreClientSpy = FirebaseFirestoreClientSpy();
    dataSource = FirebaseLoginDataSourceImplementation(
      authenticationClientSpy,
      firestoreClientSpy,
      connectivityCheckerSpy,
    );
  });

  test(
      'FirebaseLoginDataSourceImplementation should respect LoginDataSource abstraction',
      () {
    // Assert
    expect(dataSource, isA<LoginDataSource>());
  });

  test(
      'Should return User if the device has internet connection, user exists and has correct credentials',
      () async {
    // Arrange
    when(() => connectivityCheckerSpy.hasActiveNetwork())
        .thenAnswer((_) async => true);
    when(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    ).thenAnswer((_) async => tFirebaseUser);
    when(
      () => firestoreClientSpy.getUserData(
        userUniqueIdentifier: tFirebaseUser.uniqueIdentifier,
      ),
    ).thenAnswer((_) async => userDataMock);

    // Act
    final result = await dataSource.authenticationWithCredentials(tParameters);

    // Assert
    expect(
      result,
      isA<User>()
          .having(
            (success) => success,
            'Has the expected entity',
            tUser,
          )
          .having(
            (success) => success.userName.fullName,
            'Has the expected full name',
            tUser.userName.fullName,
          ),
    );
    verify(() => connectivityCheckerSpy.hasActiveNetwork());
    verify(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    );
    verify(
      () => firestoreClientSpy.getUserData(
        userUniqueIdentifier: tFirebaseUser.uniqueIdentifier,
      ),
    );
    verifyNoMoreInteractions(connectivityCheckerSpy);
    verifyNoMoreInteractions(authenticationClientSpy);
    verifyNoMoreInteractions(firestoreClientSpy);
  });

  test(
      'Should throw NoInternetConnectionException if the device does not have internet connection',
      () async {
    // Arrange
    when(() => connectivityCheckerSpy.hasActiveNetwork())
        .thenAnswer((_) async => false);

    // Act
    final call = dataSource.authenticationWithCredentials;

    // Assert
    await expectLater(
      () => call(tParameters),
      throwsA(isA<NoInternetConnectionException>()),
    );
    verify(() => connectivityCheckerSpy.hasActiveNetwork());
    verifyNoMoreInteractions(connectivityCheckerSpy);
    verifyZeroInteractions(authenticationClientSpy);
    verifyZeroInteractions(firestoreClientSpy);
  });

  test(
      'Should throw NoUserFoundException if the device has internet connection, but the user does not exist',
      () async {
    // Arrange
    when(() => connectivityCheckerSpy.hasActiveNetwork())
        .thenAnswer((_) async => true);
    when(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    ).thenThrow(NoUserFoundException());

    // Act
    final call = dataSource.authenticationWithCredentials;

    // Assert
    await expectLater(
      () => call(tParameters),
      throwsA(isA<NoUserFoundException>()),
    );
    verify(() => connectivityCheckerSpy.hasActiveNetwork());
    verify(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    );
    verifyNoMoreInteractions(connectivityCheckerSpy);
    verifyNoMoreInteractions(authenticationClientSpy);
    verifyZeroInteractions(firestoreClientSpy);
  });

  test(
      'Should throw UnableToGetUserDataException if the device has internet connection, user has correct credentials, but does not have valid data stored',
      () async {
    // Arrange
    when(() => connectivityCheckerSpy.hasActiveNetwork())
        .thenAnswer((_) async => true);
    when(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    ).thenAnswer((_) async => tFirebaseUser);
    when(
      () => firestoreClientSpy.getUserData(
        userUniqueIdentifier: tFirebaseUser.uniqueIdentifier,
      ),
    ).thenThrow(const UnableToGetUserDataException());

    // Act
    final call = dataSource.authenticationWithCredentials;

    // Assert
    await expectLater(
      () => call(tParameters),
      throwsA(isA<UnableToGetUserDataException>()),
    );
    verify(() => connectivityCheckerSpy.hasActiveNetwork());
    verify(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    );
    verify(
      () => firestoreClientSpy.getUserData(
        userUniqueIdentifier: tFirebaseUser.uniqueIdentifier,
      ),
    );
    verifyNoMoreInteractions(connectivityCheckerSpy);
    verifyNoMoreInteractions(authenticationClientSpy);
    verifyNoMoreInteractions(firestoreClientSpy);
  });

  test('Should throw AuthenticationException when an unexpected error occurs',
      () async {
    // Arrange
    const tExceptionMessage = 'Unknown error';
    when(() => connectivityCheckerSpy.hasActiveNetwork())
        .thenAnswer((_) async => true);
    when(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    ).thenThrow(Exception(tExceptionMessage));

    // Act
    final call = dataSource.authenticationWithCredentials;

    // Assert
    await expectLater(
      () => call(tParameters),
      throwsA(
        isA<Exception>().having(
          (exception) => exception.toString(),
          'Has the exception message',
          'Exception: $tExceptionMessage',
        ),
      ),
    );
    verify(() => connectivityCheckerSpy.hasActiveNetwork());
    verify(
      () => authenticationClientSpy.authenticationWithCredentials(
        email: tEmail,
        password: tPassword,
      ),
    );
    verifyNoMoreInteractions(connectivityCheckerSpy);
    verifyNoMoreInteractions(authenticationClientSpy);
    verifyZeroInteractions(firestoreClientSpy);
  });
}
