class AuthenticationEvents {
  const AuthenticationEvents();
}

class AuthenticationWithCredentialsEvent extends AuthenticationEvents {
  final String email;
  final String password;

  const AuthenticationWithCredentialsEvent({
    required this.email,
    required this.password,
  });
}
