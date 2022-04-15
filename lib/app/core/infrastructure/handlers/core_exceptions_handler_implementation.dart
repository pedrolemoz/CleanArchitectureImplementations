import 'package:dartz/dartz.dart';

import '../../domain/errors/failure.dart';
import '../../domain/errors/global_failures.dart';
import '../exceptions/no_internet_connection_exception.dart';
import '../exceptions/server_exception.dart';
import 'core_exceptions_handler.dart';

class CoreExceptionsHandlerImplementation implements CoreExceptionsHandler {
  @override
  Future<Either<Failure, Type>> handleException<Type>(
    Object exception, {
    Future<Either<Failure, Type>> Function()? onExceptionMismatch,
    Future<Either<Failure, Type>> Function(Object, Failure)? onServerException,
    Future<Either<Failure, Type>> Function(Object, Failure)?
        onNoInternetConnectionException,
  }) async {
    switch (exception.runtimeType) {
      case ServerException:
        final failure = ServerFailure(message: exception.toString());

        if (onServerException != null) {
          return await onServerException(
            exception as ServerException,
            failure,
          );
        }
        return Left(failure);
      case NoInternetConnectionException:
        final failure = NoInternetConnectionFailure();

        if (onNoInternetConnectionException != null) {
          return await onNoInternetConnectionException(
            exception as NoInternetConnectionException,
            failure,
          );
        }
        return Left(failure);
      default:
        return onExceptionMismatch != null
            ? await onExceptionMismatch()
            : Left(UnknownFailure());
    }
  }
}
