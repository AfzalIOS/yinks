import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/adaptive_auth_layout.dart';
import '../../salon_dashboard/presentation/salon_main_shell.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

enum _AccountType { salon, hairdresser }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  _AccountType _accountType = _AccountType.salon;
  bool _obscurePassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AdaptiveAuthLayout(
          tagline: 'Where Talent Meets Opportunity',
          marketingText:
              'Trusted by leading salons across London to book verified, '
              'freelance hairdressing talent on demand.',
          formContent: _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Tablet detection should not depend only on width,
    // because orientation changes width considerably.
    final bool isTablet = size.shortestSide >= 600;

    // PHONE keeps the original ScreenUtil values.
    // TABLET uses logical pixels because this form sits inside
    // AdaptiveAuthLayout's constrained right-side panel.
    final double horizontalPadding = isTablet ? 24.0 : 24.w;
    final double verticalPadding = isTablet ? 24.0 : 24.h;

    final double gap8 = isTablet ? 8.0 : 8.h;
    final double gap12 = isTablet ? 12.0 : 12.h;
    final double gap16 = isTablet ? 16.0 : 16.h;
    final double gap24 = isTablet ? 24.0 : 24.h;
    final double gap32 = isTablet ? 32.0 : 32.h;

    final double horizontalGap12 = isTablet ? 12.0 : 12.w;
    final double buttonHeight = isTablet ? 52.0 : 52.h;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // HEADER
          // --------------------------------------------------
          Text('Welcome Back', style: AppTextStyles.headlineMd),

          SizedBox(height: gap8),

          Text(
            'Sign in to continue to YINKS',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: gap32),

          // --------------------------------------------------
          // ACCOUNT TYPE
          // --------------------------------------------------
          Text('Account Type', style: AppTextStyles.labelLg),

          SizedBox(height: gap12),

          Row(
            children: [
              Expanded(
                child: _buildAccountTypeOption(
                  type: _AccountType.salon,
                  label: 'Salon',
                ),
              ),

              SizedBox(width: horizontalGap12),

              Expanded(
                child: _buildAccountTypeOption(
                  type: _AccountType.hairdresser,
                  label: 'Hairdresser',
                ),
              ),
            ],
          ),

          SizedBox(height: gap24),

          // --------------------------------------------------
          // EMAIL
          // --------------------------------------------------
          Text('Email', style: AppTextStyles.labelLg),

          SizedBox(height: gap8),

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.bodyMd,
            decoration: _inputDecoration(
              context,
              hintText: 'Enter email address',
            ),
          ),

          SizedBox(height: gap16),

          // --------------------------------------------------
          // PASSWORD
          // --------------------------------------------------
          Text('Password', style: AppTextStyles.labelLg),

          SizedBox(height: gap8),

          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: AppTextStyles.bodyMd,
            decoration: _inputDecoration(
              context,
              hintText: 'Enter password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: isTablet ? 20 : 20.sp,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: gap8),

          // --------------------------------------------------
          // FORGOT PASSWORD
          // --------------------------------------------------
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
              ),
            ),
          ),

          SizedBox(height: gap24),

          // --------------------------------------------------
          // SIGN IN BUTTON
          // --------------------------------------------------
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SalonMainShell()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 8 : 8.r),
                ),
              ),
              child: Text(
                'Sign In',
                style: AppTextStyles.titleMd.copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ),

          SizedBox(height: gap24),

          // --------------------------------------------------
          // SIGN UP
          // --------------------------------------------------
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffixIcon,
  }) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.shortestSide >= 600;

    final radius = BorderRadius.circular(isTablet ? 8 : 8.r);

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      suffixIcon: suffixIcon,

      // IMPORTANT:
      // Don't scale this against full iPad width.
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 16.w,
        vertical: isTablet ? 14 : 14.h,
      ),

      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  // ------------------------------------------------------------
  // ACCOUNT TYPE
  // ------------------------------------------------------------

  Widget _buildAccountTypeOption({
    required _AccountType type,
    required String label,
  }) {
    final isSelected = _accountType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _accountType = type;
        });
      },
      child: Container(
        // Plain logical pixels intentionally.
        // This widget can live inside a constrained tablet panel.
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: SizedBox(
                        width: 9,
                        height: 9,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
