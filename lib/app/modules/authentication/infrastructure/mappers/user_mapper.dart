import '../../../../core/domain/entities/user.dart';
import '../../../../core/domain/entities/user_name.dart';

class UserMapper {
  static User fromFirebaseDocument(Map<String, dynamic> document) {
    return User(
      userName: UserName(
        firstName: document['name']['first_name'],
        lastName: document['name']['last_name'],
      ),
      email: document['email'],
    );
  }
}
