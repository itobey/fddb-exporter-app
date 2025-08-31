import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A very small HttpOverrides-based fake that returns canned responses by URL and method.
class FakeHttpOverrides extends HttpOverrides {
  final Map<String, _FakeHttpResponseSpec> routes;

  FakeHttpOverrides(this.routes);

  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient(routes);
}

class _FakeHttpClient implements HttpClient {
  final Map<String, _FakeHttpResponseSpec> routes;
  _FakeHttpClient(this.routes);

  // Helper to create a request that knows the URL and method
  _FakeHttpClientRequest _buildRequest(Uri url, String method) {
    final key = '${method.toUpperCase()} ${url.toString()}';
    final spec = routes[key];
    if (spec == null) {
      return _FakeHttpClientRequest(url, _FakeHttpClientResponse(
        statusCode: 404,
        body: utf8.encode(jsonEncode({'error': 'not found'})),
        rawHeaders: {HttpHeaders.contentTypeHeader: 'application/json'},
      ));
    }
    return _FakeHttpClientRequest(url, _FakeHttpClientResponse(
      statusCode: spec.statusCode,
      body: spec.bodyBytes,
      rawHeaders: spec.headers,
    ));
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _buildRequest(url, method);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _buildRequest(url, 'GET');

  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _buildRequest(url, 'POST');

  @override
  void close({bool force = false}) {}

  // Unused methods can throw or delegate to defaults as they are not needed in our tests
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  final Uri url;
  final _FakeHttpClientResponse response;
  final BytesBuilder _builder = BytesBuilder();

  bool followRedirects = true;
  int maxRedirects = 5;
  bool persistentConnection = false;
  int _contentLength = -1;
  final _Headers _reqHeaders = _Headers({});

  _FakeHttpClientRequest(this.url, this.response);

  @override
  Uri get uri => url;

  @override
  HttpHeaders get headers => _reqHeaders;

  @override
  set contentLength(int value) => _contentLength = value;
  @override
  int get contentLength => _contentLength;

  @override
  void write(Object? obj) {
    if (obj != null) {
      _builder.add(utf8.encode(obj.toString()));
    }
  }

  @override
  void add(List<int> data) => _builder.add(data);

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final chunk in stream) {
      _builder.add(chunk);
    }
  }

  @override
  Future<HttpClientResponse> close() async => response;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  final int statusCode;
  final List<int> body;
  final Map<String, String> rawHeaders;

  _FakeHttpClientResponse({
    required this.statusCode,
    required this.body,
    required this.rawHeaders,
  });

  @override
  int get contentLength => body.length;

  @override
  X509Certificate? get certificate => null;

  @override
  HttpConnectionInfo? get connectionInfo => null;


  @override
  Future<Socket> detachSocket() => throw UnimplementedError();

  @override
  HttpHeaders get headers => _Headers(rawHeaders);

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => '';

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  List<Cookie> get cookies => const [];

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) => Future<HttpClientResponse>.value(this);

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final controller = StreamController<List<int>>();
    final sub = controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    controller.add(body);
    controller.close();
    return sub;
  }
}

class _Headers implements HttpHeaders {
  final Map<String, List<String>> _map = {};
  _Headers(Map<String, String> input) {
    input.forEach((k, v) => _map[k] = [v]);
  }
  @override
  List<String>? operator [](String name) => _map[name];

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    final key = name;
    final list = _map.putIfAbsent(key, () => <String>[]);
    list.add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _map[name] = [value.toString()];
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _map.forEach(action);
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpResponseSpec {
  final int statusCode;
  final List<int> bodyBytes;
  final Map<String, String> headers;
  _FakeHttpResponseSpec({required this.statusCode, required this.bodyBytes, this.headers = const {HttpHeaders.contentTypeHeader: 'application/json'}});
}

/// Helper to create a route spec map key
String routeKey(String method, String url) => '${method.toUpperCase()} $url';

/// Helper to build a spec
_FakeHttpResponseSpec jsonOk(Object jsonObj) => _FakeHttpResponseSpec(statusCode: 200, bodyBytes: utf8.encode(jsonEncode(jsonObj)));
_FakeHttpResponseSpec jsonWithStatus(int status, Object jsonObj) => _FakeHttpResponseSpec(statusCode: status, bodyBytes: utf8.encode(jsonEncode(jsonObj)));