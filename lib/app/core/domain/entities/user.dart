import 'user_name.dart';

class User {
  final UserName userName;
  final String email;

  const User({required this.userName, required this.email});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.userName == userName && other.email == email;
  }
}
