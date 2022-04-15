import 'package:http/http.dart' as http;

import '../../../external/checkers/network_connectivity_checker/abstractions/network_connectivity_checker.dart';
import '../../../infrastructure/exceptions/no_internet_connection_exception.dart';
import '../../../infrastructure/exceptions/server_exception.dart';
import '../abstraction/http_client.dart';
import '../entities/http_response.dart';

class HttpClientImplementation implements HttpClient {
  final http.Client httpClient;
  final NetworkConnectivityChecker connectivityChecker;

  const HttpClientImplementation(this.httpClient, this.connectivityChecker);

  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    if (await connectivityChecker.hasActiveNetwork()) {
      try {
        final response = await httpClient.get(Uri.parse(url), headers: headers);

        return HttpResponse(
          url: url,
          data: response.body,
          statusCode: response.statusCode,
        );
      } catch (exception) {
        throw ServerException(data: exception.toString());
      }
    }

    throw const NoInternetConnectionException();
  }

  @override
  Future<HttpResponse> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    if (await connectivityChecker.hasActiveNetwork()) {
      try {
        final response = await httpClient.post(
          Uri.parse(url),
          body: body,
          headers: headers,
        );

        return HttpResponse(
          url: url,
          data: response.body,
          statusCode: response.statusCode,
        );
      } catch (exception) {
        throw ServerException(data: exception.toString());
      }
    }

    throw const NoInternetConnectionException();
  }
}
