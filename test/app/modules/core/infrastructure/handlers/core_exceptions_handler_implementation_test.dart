import 'package:clean_architecture_implementations/app/core/domain/errors/failure.dart';
import 'package:clean_architecture_implementations/app/core/domain/errors/global_failures.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/exceptions/no_internet_connection_exception.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/exceptions/server_exception.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/exceptions/unable_to_get_user_data_exception.dart';
import 'package:clean_architecture_implementations/app/core/infrastructure/handlers/core_exceptions_handler_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final coreExceptionsHandler = CoreExceptionsHandlerImplementation();

  test(
      'Should return UnableToGetUserDataFailure when UnableToGetUserDataException is received',
      () async {
    // Act
    final result = await coreExceptionsHandler
        .handleException(const UnableToGetUserDataException());

    // Assert
    expect(result.fold(id, id), isA<UnableToGetUserDataFailure>());
  });

  test(
      'Should return NoInternetConnectionFailure when NoInternetConnectionException is received',
      () async {
    // Act
    final result = await coreExceptionsHandler
        .handleException(const NoInternetConnectionException());

    // Assert
    expect(result.fold(id, id), isA<NoInternetConnectionFailure>());
  });

  test('Should return ServerFailure when ServerException is received',
      () async {
    // Act
    final result = await coreExceptionsHandler
        .handleException(const ServerException(data: ''));

    // Assert
    expect(result.fold(id, id), isA<ServerFailure>());
  });

  test('Should return Failure when an unexpected exception is received',
      () async {
    // Act
    const tErrorMessage = 'Unexpected exception';
    final result =
        await coreExceptionsHandler.handleException(Exception(tErrorMessage));

    // Assert
    expect(
      result.fold(id, id),
      isA<Failure>().having(
        (failure) => failure.message,
        'Has the error message from exception',
        'Exception: $tErrorMessage',
      ),
    );
  });
}
