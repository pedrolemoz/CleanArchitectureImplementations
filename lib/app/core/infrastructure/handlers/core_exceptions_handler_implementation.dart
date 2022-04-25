import 'package:dartz/dartz.dart';

import '../../domain/errors/failure.dart';
import '../../domain/errors/global_failures.dart';
import '../exceptions/no_internet_connection_exception.dart';
import '../exceptions/server_exception.dart';
import '../exceptions/unable_to_get_user_data_exception.dart';
import 'core_exceptions_handler.dart';

class CoreExceptionsHandlerImplementation implements CoreExceptionsHandler {
  @override
  Future<Either<Failure, Type>> handleException<Type>(
    Object exception, {
    Future<Either<Failure, Type>> Function()? onExceptionMismatch,
  }) async {
    switch (exception.runtimeType) {
      case ServerException:
        final failure = ServerFailure(message: exception.toString());

        return Left(failure);
      case NoInternetConnectionException:
        return Left(NoInternetConnectionFailure());
      case UnableToGetUserDataException:
        return Left(UnableToGetUserDataFailure());
      default:
        return onExceptionMismatch != null
            ? await onExceptionMismatch()
            : Left(Failure(message: exception.toString()));
    }
  }
}
