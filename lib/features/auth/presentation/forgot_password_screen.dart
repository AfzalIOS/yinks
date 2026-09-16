import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'sign_in_screen.dart';

/// Forgot Password screen: an email-request form that switches to a
/// confirmation state after tapping "Send Reset Link". No real backend
/// call yet — the send is simulated locally.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _linkSent = false;

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _goToSignIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_linkSent) ..._buildRequestState() else ..._buildSentState(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRequestState() {
    return [
      Text('Forgot Password?', style: AppTextStyles.headlineMd),
      SizedBox(height: 8.h),
      Text(
        "Enter your email address and we'll send you a link to reset "
        'your password.',
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      SizedBox(height: 32.h),
      Text('Email', style: AppTextStyles.labelLg),
      SizedBox(height: 8.h),
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: AppTextStyles.bodyMd,
        decoration: _inputDecoration(hintText: 'Enter email address'),
      ),
      SizedBox(height: 24.h),
      SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () => setState(() => _linkSent = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Send Reset Link',
            style: AppTextStyles.titleMd.copyWith(
              color: AppColors.background,
            ),
          ),
        ),
      ),
      SizedBox(height: 24.h),
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Remember your password? ',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: _goToSignIn,
              child: Text(
                'Sign In',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildSentState() {
    return [
      Text('Check your email', style: AppTextStyles.headlineMd),
      SizedBox(height: 8.h),
      Text(
        "We've sent a password reset link to your email address.",
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      SizedBox(height: 32.h),
      SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: _goToSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Back to Sign In',
            style: AppTextStyles.titleMd.copyWith(
              color: AppColors.background,
            ),
          ),
        ),
      ),
    ];
  }

  InputDecoration _inputDecoration({required String hintText}) {
    final radius = BorderRadius.circular(8.r);
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
}
