import 'package:flutter/material.dart' as m;
import '../services/app_routes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

import '../services/app_constants.dart';
import '../services/auth_storage.dart';
import '../services/auth_service.dart';

class LoginScreen extends m.StatefulWidget {
  const LoginScreen({super.key});

  @override
  m.State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends m.State<LoginScreen> {
  final _usernameController = m.TextEditingController();
  final _passwordController = m.TextEditingController();
  bool _isLoading = false;

  void _handleSubmit() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Vui lòng nhập đầy đủ thông tin.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.login(email, password);
      if (success['success'] == true) {
        if (!mounted) return;
        context.go(AppRoutes.home);
      } else {
        _showSnackBar('Sai tài khoản hoặc mật khẩu.', isError: true);
      }
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi. Vui lòng thử lại.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    // In shadcn_flutter, you might use toast or a custom dialog.
    // Falling back to Material SnackBar for simplicity.
    m.ScaffoldMessenger.of(context).showSnackBar(
      m.SnackBar(
        content: m.Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: m.SnackBarBehavior.floating,
      ),
    );
  }

  @override
  m.Widget build(m.BuildContext context) {
    final theme = Theme.of(context);

    return m.Scaffold(
      // A soft, natural background color for the plant shop
      backgroundColor: const m.Color(0xFFF0FDF4),
      body: m.SafeArea(
        child: m.Center(
          child: m.SingleChildScrollView(
            padding: const m.EdgeInsets.all(24),
            child: m.Column(
              mainAxisAlignment: m.MainAxisAlignment.center,
              children: [
                // Logo or Icon
                m.Container(
                  padding: const m.EdgeInsets.all(16),
                  decoration: m.BoxDecoration(
                    color: m.Colors.white,
                    shape: m.BoxShape.circle,
                    boxShadow: [
                      m.BoxShadow(
                        color: m.Colors.green.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const m.Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.leaf,
                    size: 48,
                    color: m.Color(0xFF16A34A),
                  ),
                ),
                const m.SizedBox(height: 32),

                // Greeting text
                m.Text(
                  'Chào mừng trở lại',
                  style: theme.typography.h2.copyWith(
                    color: const m.Color(0xFF14532D), // Dark green
                    fontWeight: m.FontWeight.w800,
                  ),
                  textAlign: m.TextAlign.center,
                ),
                const m.SizedBox(height: 8),
                m.Text(
                  'Đăng nhập để vào không gian xanh của bạn',
                  style: theme.typography.textMuted.copyWith(fontSize: 16),
                  textAlign: m.TextAlign.center,
                ),
                const m.SizedBox(height: 48),

                // Login Card
                m.Container(
                  decoration: m.BoxDecoration(
                    color: m.Colors.white,
                    borderRadius: m.BorderRadius.circular(24),
                    boxShadow: [
                      m.BoxShadow(
                        color: m.Colors.black.withValues(alpha: 0.05),
                        blurRadius: 30,
                        offset: const m.Offset(0, 10),
                      ),
                    ],
                    border: m.Border.all(
                      color: m.Colors.green.shade50.withValues(alpha: 0.5),
                    ),
                  ),
                  padding: const m.EdgeInsets.all(32),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      m.Column(
                        crossAxisAlignment: m.CrossAxisAlignment.start,
                        children: [
                          m.Text(
                            AppStrings.email,
                            style: theme.typography.small.copyWith(
                              fontWeight: m.FontWeight.w600,
                              color: const m.Color(0xFF166534),
                            ),
                          ),
                          const m.SizedBox(height: 8),
                          TextField(
                            controller: _usernameController,
                            placeholder: const m.Text('admin hoặc user'),
                            features: const [
                              InputLeadingFeature(
                                Icon(
                                  LucideIcons.user,
                                  size: 18,
                                  color: m.Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const m.SizedBox(height: 24),

                      // Password Field
                      m.Column(
                        crossAxisAlignment: m.CrossAxisAlignment.start,
                        children: [
                          m.Row(
                            mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                            children: [
                              m.Text(
                                AppStrings.password,
                                style: theme.typography.small.copyWith(
                                  fontWeight: m.FontWeight.w600,
                                  color: const m.Color(0xFF166534),
                                ),
                              ),
                              m.Text(
                                AppStrings.forgotPassword,
                                style: theme.typography.small.copyWith(
                                  color: const m.Color(0xFF16A34A),
                                  fontWeight: m.FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const m.SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            placeholder: const m.Text('••••••••'),
                            obscureText: true,
                            features: const [
                              InputLeadingFeature(
                                Icon(
                                  LucideIcons.lock,
                                  size: 18,
                                  color: m.Color(0xFF16A34A),
                                ),
                              ),
                              InputPasswordToggleFeature(),
                            ],
                          ),
                        ],
                      ),
                      const m.SizedBox(height: 32),

                      // Submit Button
                      PrimaryButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        child: m.Container(
                          padding: const m.EdgeInsets.symmetric(vertical: 4),
                          child: _isLoading
                              ? const m.SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: m.CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: m.Colors.white,
                                  ),
                                )
                              : m.Text(
                                  AppStrings.login,
                                  style: const m.TextStyle(
                                    fontSize: 16,
                                    fontWeight: m.FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
