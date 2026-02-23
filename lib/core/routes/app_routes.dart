import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';

/// App route configuration
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/order/:id';
  static const String map = '/map';
  static const String chat = '/chat';
  static const String chatDetail = '/chat/:id';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Admin routes
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';

  // Shipper routes
  static const String shipperDeliveries = '/shipper/deliveries';
  static const String shipperDeliveryDetail = '/shipper/delivery/:id';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      // TODO: Add more routes as screens are implemented
    ],
  );
}
