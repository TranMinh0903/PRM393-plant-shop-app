import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/data/auth_service.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../shared/widgets/main_shell.dart';
import '../network/auth_storage.dart';

/// App route configuration
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String saved = '/saved';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String productDetail = '/product/:id';
  static const String checkout = '/checkout';
  static const String orderDetail = '/order/:id';
  static const String map = '/map';
  static const String chat = '/chat';
  static const String chatDetail = '/chat/:id';
  static const String notifications = '/notifications';

  // Admin routes
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';

  // Shipper routes
  static const String shipperDeliveries = '/shipper/deliveries';
  static const String shipperDeliveryDetail = '/shipper/delivery/:id';

  // Navigation keys for ShellRoute
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: login,
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),

      // Product detail (outside shell - full screen, no bottom nav)
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailPage(productId: id);
        },
      ),

      // Main Shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // Determine current tab index based on route
          int currentIndex = 0;
          final location = state.uri.toString();
          if (location == home) {
            currentIndex = 0;
          } else if (location == saved) {
            currentIndex = 1;
          } else if (location == cart) {
            currentIndex = 2;
          } else if (location == orders) {
            currentIndex = 3;
          } else if (location == profile) {
            currentIndex = 4;
          }

          return MainShell(
            currentIndex: currentIndex,
            onTabChanged: (index) {
              switch (index) {
                case 0:
                  context.go(home);
                  break;
                case 1:
                  context.go(saved);
                  break;
                case 2:
                  context.go(cart);
                  break;
                case 3:
                  context.go(orders);
                  break;
                case 4:
                  context.go(profile);
                  break;
              }
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: saved,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(
                icon: Icons.favorite,
                title: 'Saved Plants',
              ),
            ),
          ),
          GoRoute(
            path: cart,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(
                icon: Icons.shopping_cart,
                title: 'Shopping Cart',
              ),
            ),
          ),
          GoRoute(
            path: orders,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(
                icon: Icons.local_shipping,
                title: 'My Orders',
              ),
            ),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}

/// Temporary placeholder page for tabs not yet implemented
class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PlaceholderPage({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF618961)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon...',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF618961),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile page with logout button
class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Avatar
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: Color(0xFF557A55),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AuthStorage.username ?? 'Plant Lover',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'TreeShop Member',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF557A55),
                ),
              ),
              const SizedBox(height: 40),

              // Menu items
              _buildMenuItem(Icons.person_outline, 'Edit Profile', () {}),
              _buildMenuItem(Icons.location_on_outlined, 'My Addresses', () {}),
              _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
              _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),

              const Spacer(),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    AuthService.logout();
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFDC2626)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F3E8)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF557A55)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
