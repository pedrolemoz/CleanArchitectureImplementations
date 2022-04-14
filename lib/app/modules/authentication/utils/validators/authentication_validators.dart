abstract class AuthenticationValidators {
  bool hasValidEmailAddress(String email);
  bool hasValidPassword(String password);
}

class AuthenticationValidatorsImplementation
    implements AuthenticationValidators {
  const AuthenticationValidatorsImplementation();

  @override
  bool hasValidEmailAddress(String email) {
    return email.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  @override
  bool hasValidPassword(String password) => password.length >= 16;
}
