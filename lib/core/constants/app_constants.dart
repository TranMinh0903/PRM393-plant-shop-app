import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  AppColors._();

  // Primary - Green theme for plant shop
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // Secondary
  static const Color secondary = Color(0xFF8D6E63);
  static const Color secondaryLight = Color(0xFFBE9C91);
  static const Color secondaryDark = Color(0xFF5F4339);

  // Background
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
}

/// App string constants
class AppStrings {
  AppStrings._();

  static const String appName = 'Plant Shop';
  static const String appTagline = 'Cây cảnh đẹp, giao tận nơi';

  // Auth
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String confirmPassword = 'Xác nhận mật khẩu';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String displayName = 'Tên hiển thị';
  static const String phone = 'Số điện thoại';

  // Product
  static const String products = 'Sản phẩm';
  static const String productDetail = 'Chi tiết sản phẩm';
  static const String addToCart = 'Thêm vào giỏ hàng';
  static const String search = 'Tìm kiếm cây cảnh...';

  // Cart
  static const String cart = 'Giỏ hàng';
  static const String checkout = 'Thanh toán';
  static const String totalPrice = 'Tổng tiền';
  static const String emptyCart = 'Giỏ hàng trống';

  // Order
  static const String orders = 'Đơn hàng';
  static const String orderDetail = 'Chi tiết đơn hàng';

  // Categories
  static const String indoor = 'Cây trong nhà';
  static const String outdoor = 'Cây ngoài trời';
  static const String office = 'Cây văn phòng';
}

/// App dimension constants
class AppDimens {
  AppDimens._();

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
}
