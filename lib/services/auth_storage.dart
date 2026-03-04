/// Lưu trữ JWT token và thông tin user đăng nhập
class AuthStorage {
  AuthStorage._();

  static String? _token;
  static String? _username;
  static String? _role;

  /// Lưu token sau khi login thành công
  static void saveToken(String token) {
    _token = token;
  }

  /// Lưu username
  static void saveUsername(String username) {
    _username = username;
  }

  /// Lưu role
  static void saveRole(String role) {
    _role = role;
  }

  /// Lấy token hiện tại
  static String? get token => _token;

  /// Lấy username hiện tại
  static String? get username => _username;

  /// Lấy role hiện tại
  static String? get role => _role;

  /// Kiểm tra có phải Admin không
  static bool get isAdmin => _role == 'Admin';

  /// Kiểm tra có phải Shipper không
  static bool get isShipper => _role == 'Shipper';

  /// Kiểm tra đã đăng nhập chưa
  static bool get isLoggedIn => _token != null;

  /// Xóa token khi logout
  static void clear() {
    _token = null;
    _username = null;
    _role = null;
  }
}
