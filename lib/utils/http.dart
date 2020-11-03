import 'package:dio/dio.dart';

class HttpConfig {
  static const baseUrl = "http://api.xiaoniuguo.com";

  static const monitorReport = "/monitor/report";
}

class HttpUtil {

  static const GET = "GET";
  static const POST = "POST";
  static const UPDATE = "UPDATE";
  static const DELETE = "DELETE";

  /// dio 缓存，通过 baseUrl 区分
  static final Map<String, Dio> _dioCache = Map<String, Dio>();

  /// 请求头
  static Map<String, dynamic> _headers() {
    var map = new Map<String, dynamic>();
    return map;
  }

  static Future<Dio> _getDio({String baseUrl}) async {
    baseUrl ??= HttpConfig.baseUrl;
    if (_dioCache[baseUrl] != null) {
      return _dioCache[baseUrl];
    }
    // options
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        headers: _headers()
    );
    final dio = Dio(options);
    _dioCache[baseUrl] = dio;
    return dio;
  }

  static get(String apiPath, { Map<String, dynamic> query, String baseUrl }) async {
    return await http(apiPath, GET, query: query, baseUrl: baseUrl);
  }

  static post(String apiPath, { dynamic body, String baseUrl }) async {
    return await http(apiPath, POST, body: body, baseUrl: baseUrl);
  }

  static http(String apiPath, String method, {
    Map<String, dynamic> query,
    dynamic body,
    String baseUrl,
  }) async {
    try {
      final dio = await _getDio(baseUrl: baseUrl);
      Response response;
      switch (method) {
        case GET:
          response = await dio.get(apiPath, queryParameters: query);
          break;
        case POST:
          response = await dio.post(apiPath, data: body);
          break;
      }
      return response.toString();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}