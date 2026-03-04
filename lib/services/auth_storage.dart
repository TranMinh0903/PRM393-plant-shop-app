/// Lưu trữ JWT token và thông tin user đăng nhập
class AuthStorage {
  AuthStorage._();

  static String? _token;
  static String? _username;

  /// Lưu token sau khi login thành công
  static void saveToken(String token) {
    _token = token;
  }

  /// Lưu username
  static void saveUsername(String username) {
    _username = username;
  }

  /// Lấy token hiện tại
  static String? get token => _token;

  /// Lấy username hiện tại
  static String? get username => _username;

  /// Kiểm tra đã đăng nhập chưa
  static bool get isLoggedIn => _token != null;

  /// Xóa token khi logout
  static void clear() {
    _token = null;
    _username = null;
  }
}
