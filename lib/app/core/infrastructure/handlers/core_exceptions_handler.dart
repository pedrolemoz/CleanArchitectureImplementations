import 'package:dartz/dartz.dart';

import '../../domain/errors/failure.dart';

abstract class CoreExceptionsHandler {
  Future<Either<Failure, Type>> handleException<Type>(
    Object exception, {
    Future<Either<Failure, Type>> Function()? onExceptionMismatch,
  });
}
