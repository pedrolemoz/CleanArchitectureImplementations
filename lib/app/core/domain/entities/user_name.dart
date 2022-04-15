class UserName {
  final String firstName;
  final String lastName;

  const UserName({required this.firstName, required this.lastName});

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserName &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode => firstName.hashCode ^ lastName.hashCode;
}
