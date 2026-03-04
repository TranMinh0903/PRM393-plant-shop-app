import 'package:flutter/material.dart';

import '../services/app_constants.dart';

/// Admin management screen — quản lý sản phẩm & danh mục
class AdminManageScreen extends StatelessWidget {
  const AdminManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.sage100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.sage500,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quản lý cửa hàng',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.sage500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Management cards
              _buildManageCard(
                icon: Icons.yard_outlined,
                title: 'Quản lý sản phẩm',
                subtitle: 'Thêm, sửa, xóa cây cảnh',
                color: AppColors.primary,
                onTap: () {
                  // TODO: Navigate to product management
                },
              ),
              const SizedBox(height: 16),
              _buildManageCard(
                icon: Icons.category_outlined,
                title: 'Quản lý danh mục',
                subtitle: 'Thêm, sửa, xóa loại cây',
                color: AppColors.sage500,
                onTap: () {
                  // TODO: Navigate to category management
                },
              ),
              const SizedBox(height: 16),
              _buildManageCard(
                icon: Icons.people_outline,
                title: 'Quản lý tài khoản',
                subtitle: 'Xem danh sách người dùng',
                color: AppColors.info,
                onTap: () {
                  // TODO: Navigate to user management
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.sage100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 26), // 10%
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.sage400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.sage400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
