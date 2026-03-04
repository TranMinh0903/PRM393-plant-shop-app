import 'package:flutter/material.dart';

import '../services/app_constants.dart';
import '../services/auth_storage.dart';

/// Main shell widget with role-aware bottom navigation bar
/// - User:    Home | Saved | Cart(FAB) | Orders | Profile  (5 tabs)
/// - Admin:   Home | Orders | Manage | Profile             (4 tabs)
/// - Shipper: Home | Deliveries | Profile                  (3 tabs)
class MainShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const MainShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final role = AuthStorage.role ?? 'User';

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: const Color(0x1A9E9E9E),
              width: 1,
            ),
          ),
        ),
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildNavItems(role),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(String role) {
    switch (role) {
      case 'Admin':
        return _buildAdminNav();
      case 'Shipper':
        return _buildShipperNav();
      default:
        return _buildUserNav();
    }
  }

  /// User: Home | Saved | Cart(FAB) | Orders | Profile
  List<Widget> _buildUserNav() {
    return [
      _NavItem(
        icon: Icons.home_outlined,
        filledIcon: Icons.home,
        label: AppStrings.home,
        isActive: currentIndex == 0,
        onTap: () => onTabChanged(0),
      ),
      _NavItem(
        icon: Icons.favorite_border,
        filledIcon: Icons.favorite,
        label: AppStrings.saved,
        isActive: currentIndex == 1,
        onTap: () => onTabChanged(1),
      ),
      _CartFab(
        isActive: currentIndex == 2,
        onTap: () => onTabChanged(2),
      ),
      _NavItem(
        icon: Icons.local_shipping_outlined,
        filledIcon: Icons.local_shipping,
        label: AppStrings.ordersNav,
        isActive: currentIndex == 3,
        onTap: () => onTabChanged(3),
      ),
      _NavItem(
        icon: Icons.person_outline,
        filledIcon: Icons.person,
        label: AppStrings.profile,
        isActive: currentIndex == 4,
        onTap: () => onTabChanged(4),
      ),
    ];
  }

  /// Admin: Home | Orders | Manage | Profile
  List<Widget> _buildAdminNav() {
    return [
      _NavItem(
        icon: Icons.home_outlined,
        filledIcon: Icons.home,
        label: AppStrings.home,
        isActive: currentIndex == 0,
        onTap: () => onTabChanged(0),
      ),
      _NavItem(
        icon: Icons.receipt_long_outlined,
        filledIcon: Icons.receipt_long,
        label: AppStrings.ordersNav,
        isActive: currentIndex == 1,
        onTap: () => onTabChanged(1),
      ),
      _NavItem(
        icon: Icons.settings_outlined,
        filledIcon: Icons.settings,
        label: 'Manage',
        isActive: currentIndex == 2,
        onTap: () => onTabChanged(2),
      ),
      _NavItem(
        icon: Icons.person_outline,
        filledIcon: Icons.person,
        label: AppStrings.profile,
        isActive: currentIndex == 3,
        onTap: () => onTabChanged(3),
      ),
    ];
  }

  /// Shipper: Home | Deliveries | Profile
  List<Widget> _buildShipperNav() {
    return [
      _NavItem(
        icon: Icons.home_outlined,
        filledIcon: Icons.home,
        label: AppStrings.home,
        isActive: currentIndex == 0,
        onTap: () => onTabChanged(0),
      ),
      _NavItem(
        icon: Icons.local_shipping_outlined,
        filledIcon: Icons.local_shipping,
        label: 'Deliveries',
        isActive: currentIndex == 1,
        onTap: () => onTabChanged(1),
      ),
      _NavItem(
        icon: Icons.person_outline,
        filledIcon: Icons.person,
        label: AppStrings.profile,
        isActive: currentIndex == 2,
        onTap: () => onTabChanged(2),
      ),
    ];
  }
}

/// Individual nav bar item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData filledIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.filledIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? filledIcon : icon,
                key: ValueKey(isActive),
                color:
                    isActive ? AppColors.primary : AppColors.sage400,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color:
                    isActive ? AppColors.primary : AppColors.sage400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Elevated cart FAB in the center of bottom nav (User only)
class _CartFab extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CartFab({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Container(
          width: AppDimens.cartFabSize,
          height: AppDimens.cartFabSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x5913EC13),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_cart,
            color: AppColors.textPrimary,
            size: 26,
          ),
        ),
      ),
    );
  }
}
