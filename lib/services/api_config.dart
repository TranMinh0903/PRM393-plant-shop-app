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
