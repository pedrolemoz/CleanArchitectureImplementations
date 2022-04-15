abstract class FirebaseFirestoreClient {
  Future<Map<String, dynamic>> getUserData({
    required String userUniqueIdentifier,
  });
}
