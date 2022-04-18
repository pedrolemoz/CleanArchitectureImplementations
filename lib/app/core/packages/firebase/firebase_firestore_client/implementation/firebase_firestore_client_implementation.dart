import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../modules/authentication/infrastructure/errors/authentication_exceptions.dart';
import '../../../../infrastructure/exceptions/unable_to_get_user_data_exception.dart';
import '../abstraction/firebase_firestore_client.dart';

class FirebaseFirestoreClientImplementation implements FirebaseFirestoreClient {
  @override
  Future<Map<String, dynamic>> getUserData({
    required String userUniqueIdentifier,
  }) async {
    try {
      final firestoreService = FirebaseFirestore.instance;

      final userDocument = await firestoreService
          .collection('data')
          .doc(userUniqueIdentifier)
          .get();

      final userData = userDocument.data();

      if (userData == null || userData.isEmpty) {
        throw const UnableToGetUserDataException();
      }

      return userData;
    } catch (exception) {
      throw AuthenticationException(message: exception.toString());
    }
  }
}
