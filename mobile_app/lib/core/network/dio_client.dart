import 'package:dio/dio.dart';

class DioClient {
  static Dio create({String? baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? _defaultBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );

    return dio;
  }

  static String _defaultBaseUrl() {
    return "http://10.0.2.2:8000";
  }
}
