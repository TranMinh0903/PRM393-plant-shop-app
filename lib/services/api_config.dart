/// Cấu hình API endpoints
class ApiConfig {
  ApiConfig._();

  /// Base URL cho Android Emulator (10.0.2.2 = localhost của máy host)
  static const String baseUrl =
      'https://horrendously-thiocyano-elana.ngrok-free.dev/api/v1';

  /// Dùng cho thiết bị thật - đổi IP thành IP máy tính của bạn
  // static const String baseUrl = 'http://192.168.1.x:9090/api/v1';

  /// Dùng cho Web
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
