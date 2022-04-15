class AuthenticationException implements Exception {
  final String? message;

  const AuthenticationException({this.message});
}

class InvalidCredentialsException extends AuthenticationException {}

class NoUserFoundException extends AuthenticationException {}
