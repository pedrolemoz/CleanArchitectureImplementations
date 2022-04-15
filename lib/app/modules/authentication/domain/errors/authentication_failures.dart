import '../../../../core/domain/errors/failure.dart';

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({String? message}) : super(message: message);
}

class InvalidEmailFailure extends AuthenticationFailure {}

class InvalidPasswordFailure extends AuthenticationFailure {}

class InvalidCredentialsFailure extends AuthenticationFailure {}

class NoUserFoundFailure extends AuthenticationFailure {}
