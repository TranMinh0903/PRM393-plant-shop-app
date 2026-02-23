import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';

/// Login & Register page with glassmorphism design
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool _isSignIn = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDuJ9ecuSyrky2Q4iIImcocJgzShSGw855aDAC7fNtPDSd8JUTZWih4ajtsUOM-bgq5OqZSK19ib_d_hvgrzYU9066Kb_9XYGS_8jGPG-eIEjH-xys4GYKpJh6Yu2Nm6bdyPCd_jr_PrH_qYNkkgm16v-aMTDj2sjSamHSf7jZG1rRvJGUBpGxUaNIXyKZ_qnd4FQKJRKfV-Ok5rejaTsdcYoGvQ0vSvaX0XA6T7gJO7Vfrgki9NPqSTxjhh7B232WjByHclB_zJye5',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.sage800,
            ),
          ),

          // Dark gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99000000),
                  Color(0x1A000000),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: bottomPadding + 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand header
                    _buildBrandHeader(),
                    const SizedBox(height: 32),

                    // Glassmorphism card
                    _buildGlassCard(),
                    const SizedBox(height: 32),

                    // Social login
                    _buildSocialLogin(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Brand logo + title + subtitle
  Widget _buildBrandHeader() {
    return Column(
      children: [
        // Logo container
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xE6FFFFFF),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.yard_outlined,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Urban Jungle',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bring nature home',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 204), // 80%
          ),
        ),
      ],
    );
  }

  /// Glassmorphism card with form fields
  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xBFFFFFFF), // white 75%
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0x99FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A1F2687),
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle: Sign In / Create Account
              _buildToggle(),
              const SizedBox(height: 28),

              // Form fields
              _buildFormFields(),
              const SizedBox(height: 16),

              // Primary CTA button
              _buildPrimaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Toggle switch between Sign In and Create Account
  Widget _buildToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0x80F1F5F9), // slate-100/50
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(color: const Color(0x80FFFFFF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isSignIn = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isSignIn ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  boxShadow: _isSignIn
                      ? const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _isSignIn
                          ? AppColors.textPrimary
                          : AppColors.sage400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isSignIn = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !_isSignIn ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  boxShadow: !_isSignIn
                      ? const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: !_isSignIn
                          ? AppColors.textPrimary
                          : AppColors.sage400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Form fields (sign in vs create account)
  Widget _buildFormFields() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          // Full Name (register only)
          if (!_isSignIn) ...[
            _buildInputField(
              controller: _nameController,
              icon: Icons.person_outline,
              placeholder: 'Full name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
          ],

          // Email
          _buildInputField(
            controller: _emailController,
            icon: Icons.mail_outline,
            placeholder: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Password
          _buildInputField(
            controller: _passwordController,
            icon: Icons.lock_outline,
            placeholder: 'Password',
            isPassword: true,
            obscure: _obscurePassword,
            onToggleObscure: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),

          // Confirm Password (register only)
          if (!_isSignIn) ...[
            const SizedBox(height: 16),
            _buildInputField(
              controller: _confirmPasswordController,
              icon: Icons.lock_outline,
              placeholder: 'Confirm password',
              isPassword: true,
              obscure: _obscureConfirmPassword,
              onToggleObscure: () {
                setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
          ],

          // Forgot Password (sign in only)
          if (_isSignIn) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to forgot password
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.sage500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Styled input field with icon
  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x99FFFFFF), // white/60
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(color: const Color(0x3348C91D)), // primary/20
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.sage400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 0,
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onToggleObscure,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.sage400,
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// Primary CTA button
  Widget _buildPrimaryButton() {
    return GestureDetector(
      onTap: _handleSubmit,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D48C91D), // primary/30
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          _isSignIn ? 'Explore the Jungle' : 'Create Account',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Social login buttons
  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          'Or continue with',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 204), // 80%
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google
            _buildSocialButton(
              onTap: () {
                // TODO: Google Sign In
              },
              child: Image.network(
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) => const Text(
                  'G',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4285F4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Apple
            _buildSocialButton(
              onTap: () {
                // TODO: Apple Sign In
              },
              child: const Icon(
                Icons.apple,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Individual social login button
  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xBFFFFFFF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x99FFFFFF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A1F2687),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  /// Handle form submission
  void _handleSubmit() {
    if (_isSignIn) {
      // TODO: Firebase Auth sign in
      // For now, navigate to home
      context.go('/');
    } else {
      // TODO: Firebase Auth create account
      // For now, switch to sign in
      setState(() => _isSignIn = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account created! Please sign in.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      );
    }
  }
}
