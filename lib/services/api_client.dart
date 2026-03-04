import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_storage.dart';

/// HTTP client wrapper cho BE Tree API
class ApiClient {
  ApiClient._();

  /// Headers mặc định, tự động gắn JWT token nếu có
  static Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = AuthStorage.token;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// GET request
  static Future<http.Response> get(String path,
      {Map<String, String>? queryParams}) {
    var uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return http.get(uri, headers: _headers());
  }

  /// POST request
  static Future<http.Response> post(String path, dynamic body) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
  }

  /// PUT request
  static Future<http.Response> put(String path, dynamic body) {
    return http.put(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
  }

  /// DELETE request
  static Future<http.Response> delete(String path) {
    return http.delete(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(),
    );
  }
}
