abstract class AuthenticationValidators {
  bool hasValidEmailAddress(String email);
  bool hasValidPassword(String password);
}

class AuthenticationValidatorsImplementation
    implements AuthenticationValidators {
  const AuthenticationValidatorsImplementation();

  @override
  bool hasValidEmailAddress(String email) =>
      email.isNotEmpty &&
      RegExp(r'^[a-z0-9.]+@[a-z0-9]+\.[a-z]+\.([a-z]+)?$').hasMatch(email);

  @override
  bool hasValidPassword(String password) =>
      password.isNotEmpty &&
      RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?/~_+-=|\]).{8,32}$')
          .hasMatch(password);
}
