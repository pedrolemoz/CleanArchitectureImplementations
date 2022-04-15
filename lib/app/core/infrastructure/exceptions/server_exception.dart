class ServerException implements Exception {
  final String data;

  const ServerException({required this.data});
}
