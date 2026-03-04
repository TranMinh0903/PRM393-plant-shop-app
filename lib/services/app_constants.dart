import 'package:flutter/material.dart';

/// App color constants - matching the Plant Shop design
class AppColors {
  AppColors._();

  // Primary - Vibrant green
  static const Color primary = Color(0xFF13EC13);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // Sage palette
  static const Color sage100 = Color(0xFFE8F3E8);
  static const Color sage200 = Color(0xFFCCE4CC);
  static const Color sage300 = Color(0xFFB0D4B0);
  static const Color sage400 = Color(0xFF8AB88A);
  static const Color sage500 = Color(0xFF618961);
  static const Color sage700 = Color(0xFF3D5C3D);
  static const Color sage800 = Color(0xFF2D402D);

  // Earth palette
  static const Color earth100 = Color(0xFFFDF8F4);
  static const Color earth800 = Color(0xFF4A3B32);

  // Background
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF6F8F6);

  // Text
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
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

  // Home
  static const String goodMorning = 'Good Morning 🌿';
  static const String findYourPlant = 'Find your plant';
  static const String searchHint = 'Search plants, pots...';
  static const String popularPlants = 'Popular Plants';
  static const String seeAll = 'See all';
  static const String newArrival = 'New Arrival';
  static const String shopNow = 'Shop Now';

  // Categories
  static const String all = 'All';
  static const String indoor = 'Indoor';
  static const String outdoor = 'Outdoor';
  static const String office = 'Office';
  static const String garden = 'Garden';

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

  // Nav
  static const String home = 'Home';
  static const String saved = 'Saved';
  static const String ordersNav = 'Orders';
  static const String profile = 'Profile';
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
  static const double radiusFull = 9999.0;

  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;

  // Home specific
  static const double searchBarHeight = 56.0;
  static const double bannerHeight = 160.0;
  static const double categoryChipHeight = 40.0;
  static const double bottomNavHeight = 80.0;
  static const double cartFabSize = 56.0;
}
