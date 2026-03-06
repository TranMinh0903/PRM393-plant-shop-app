/// Cấu hình API endpoints
class ApiConfig {
  ApiConfig._();

  /// 🌐 Ngrok - dùng cho thuyết trình (ai cũng truy cập được)
  static const String baseUrl = 'https://horrendously-thiocyano-elana.ngrok-free.dev/api/v1';

  /// 🏠 Docker trên máy mình (Android Emulator)
  // static const String baseUrl = 'http://10.0.2.2:9090/api/v1';

  /// 📱 Thiết bị thật - đổi IP máy tính
  // static const String baseUrl = 'http://192.168.1.x:9090/api/v1';

  /// 💻 Web browser
  // static const String baseUrl = 'http://localhost:9090/api/v1';
}

/// Cấu hình Cloudinary
class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'dndfromwh';
  static const String uploadPreset = 'itdm5qle';
  static const String folder = 'treeshop';
  static const String uploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
