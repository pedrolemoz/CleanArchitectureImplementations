class User {
  final String email;
  final String firstName;
  final String gender;
  final String lastName;
  final String password;
  final String cpf;
  final String newsletter;
  final String birthDate;
  final String id;

  const User({
    required this.email,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.password,
    required this.cpf,
    required this.newsletter,
    required this.birthDate,
    required this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.firstName == firstName &&
        other.gender == gender &&
        other.lastName == lastName &&
        other.password == password &&
        other.cpf == cpf &&
        other.newsletter == newsletter &&
        other.birthDate == birthDate &&
        other.id == id;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        firstName.hashCode ^
        gender.hashCode ^
        lastName.hashCode ^
        password.hashCode ^
        cpf.hashCode ^
        newsletter.hashCode ^
        birthDate.hashCode ^
        id.hashCode;
  }
}
