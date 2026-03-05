import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../services/app_constants.dart';
import '../services/auth_storage.dart';

class MainShell extends m.StatelessWidget {
  final m.Widget child;
  final int currentIndex;
  final m.ValueChanged<int> onTabChanged;

  const MainShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  m.Widget build(m.BuildContext context) {
    final role = AuthStorage.role ?? 'User';
    final theme = Theme.of(context);

    return m.Scaffold(
      body: child,
      bottomNavigationBar: m.Container(
        decoration: m.BoxDecoration(
          border: m.Border(
            top: m.BorderSide(color: theme.colorScheme.border, width: 1),
          ),
        ),
        child: m.SafeArea(
          child: m.Padding(
            padding: const m.EdgeInsets.symmetric(vertical: 8),
            child: m.Row(
              mainAxisAlignment: m.MainAxisAlignment.spaceAround,
              children: _buildNavItems(role, context),
            ),
          ),
        ),
      ),
    );
  }

  List<m.Widget> _buildNavItems(String role, m.BuildContext context) {
    if (role == 'Admin') {
      return [
        _buildNavItem(context, 0, LucideIcons.house, AppStrings.home),
        _buildNavItem(context, 1, LucideIcons.settings, 'Quản lý'),
        _buildNavItem(context, 2, LucideIcons.user, AppStrings.profile),
      ];
    }
    // Default User Nav
    return [
      _buildNavItem(context, 0, LucideIcons.house, AppStrings.home),
      _buildNavItem(context, 1, LucideIcons.heart, AppStrings.saved),
      _buildNavItem(context, 2, LucideIcons.shoppingCart, AppStrings.cart),
      _buildNavItem(context, 3, LucideIcons.user, AppStrings.profile),
    ];
  }

  m.Widget _buildNavItem(
    m.BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isActive = currentIndex == index;
    final theme = Theme.of(context);
    return GhostButton(
      onPressed: () => onTabChanged(index),
      child: m.Column(
        mainAxisSize: m.MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? null : theme.colorScheme.mutedForeground,
          ),
          const m.SizedBox(height: 4),
          m.Text(
            label,
            style: m.TextStyle(
              fontSize: 10,
              fontWeight: isActive ? m.FontWeight.w600 : m.FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
