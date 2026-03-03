import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/network/auth_storage.dart';

/// Service xử lý authentication với BE Tree API
class AuthService {
  AuthService._();

  /// Đăng nhập - POST /authentication/login
  /// Trả về true nếu login thành công, false nếu thất bại
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await ApiClient.post('/authentication/login', {
        'username': username,
        'password': password,
      });

      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && body['isSuccess'] == true) {
        // Lưu JWT token
        final token = body['data']['token'];
        AuthStorage.saveToken(token);
        AuthStorage.saveUsername(username);
        return {'success': true, 'message': 'Đăng nhập thành công!'};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể kết nối đến server. Kiểm tra API đang chạy.',
      };
    }
  }

  /// Đăng ký - POST /authentication/register
  static Future<Map<String, dynamic>> register(
      String username, String password, String email) async {
    try {
      final response = await ApiClient.post('/authentication/register', {
        'username': username,
        'password': password,
        'email': email,
      });

      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && body['isSuccess'] == true) {
        return {'success': true, 'message': 'Đăng ký thành công!'};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Đăng ký thất bại',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể kết nối đến server.',
      };
    }
  }

  /// Đăng xuất
  static void logout() {
    AuthStorage.clear();
  }
}
