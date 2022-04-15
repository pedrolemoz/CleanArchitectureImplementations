class HttpResponse {
  final String data;
  final int statusCode;
  final String url;

  const HttpResponse({
    required this.data,
    required this.statusCode,
    required this.url,
  });
}
