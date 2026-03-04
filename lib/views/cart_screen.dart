import 'package:flutter/material.dart';

import '../services/app_constants.dart';

/// Cart screen - hiển thị giỏ hàng
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
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
            Icon(Icons.shopping_cart_outlined,
                size: 64, color: AppColors.sage400),
            const SizedBox(height: 16),
            Text(
              AppStrings.emptyCart,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thêm sản phẩm vào giỏ hàng',
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
