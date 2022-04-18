import 'package:magnet_ui/magnet_ui.dart';

class AuthenticatingUserState implements ProcessingState {
  @override
  final String? message;

  AuthenticatingUserState([this.message]);
}

class SuccessfullyAuthenticatedUserState implements SuccessState {
  @override
  final String? message;

  SuccessfullyAuthenticatedUserState([this.message]);
}

class InvalidEmailState implements ErrorState {
  @override
  final String? message;

  InvalidEmailState([this.message]);
}

class InvalidPasswordState implements ErrorState {
  @override
  final String? message;

  InvalidPasswordState([this.message]);
}

class InvalidCredentialsState implements ErrorState {
  @override
  final String? message;

  InvalidCredentialsState([this.message]);
}

class NoUserFoundState implements ErrorState {
  @override
  final String? message;

  NoUserFoundState([this.message]);
}
