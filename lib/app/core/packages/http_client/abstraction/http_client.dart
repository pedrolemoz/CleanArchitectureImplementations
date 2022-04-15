import '../entities/http_response.dart';

abstract class HttpClient {
  Future<HttpResponse> get(String url, {Map<String, String>? headers});

  Future<HttpResponse> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });
}
