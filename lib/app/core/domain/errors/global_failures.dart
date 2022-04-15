import 'failure.dart';

class ServerFailure extends Failure {
  const ServerFailure({String? message}) : super(message: message);
}

class NoInternetConnectionFailure extends Failure {}

class UnknownFailure extends Failure {}
