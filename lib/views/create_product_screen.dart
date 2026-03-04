import 'package:flutter/material.dart';

import '../services/app_constants.dart';

/// Create product screen - form tạo sản phẩm mới
class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Tạo sản phẩm',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_box_outlined,
                size: 64, color: AppColors.sage400),
            const SizedBox(height: 16),
            Text(
              'Tạo sản phẩm mới',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.sage500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
