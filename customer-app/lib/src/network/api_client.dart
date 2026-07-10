import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API client provider — a singleton Dio instance configured for the backend.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  late final Dio dio;

  ApiClient(Ref ref) {
    dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8000/api/v1',
        ),
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Bearer token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid — trigger logout
          _handleUnauthorized();
        } else {
          // Report non-401 API errors to Sentry
          Sentry.captureException(
            error,
            stackTrace: error.stackTrace,
            hint: Hint.withMap({
              'url': error.requestOptions.uri.toString(),
              'method': error.requestOptions.method,
              'status_code': error.response?.statusCode,
              'response_body': error.response?.data?.toString(),
            }),
          );
        }
        return handler.next(error);
      },
    ));

    // Log interceptor for debugging — only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  /// Handle 401 unauthorized errors by clearing auth state.
  void _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    // The authProvider state will be reset via the router redirect logic
  }
}
