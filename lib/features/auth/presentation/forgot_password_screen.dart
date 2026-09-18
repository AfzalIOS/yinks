import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/adaptive_auth_layout.dart';
import 'sign_in_screen.dart';

/// Forgot Password screen.
///
/// User enters an email address and taps "Send Reset Link".
/// For now, the reset action is simulated locally.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _linkSent = false;

  final TextEditingController _emailController = TextEditingController();

  // ------------------------------------------------------------
  // RESPONSIVE HELPERS
  // ------------------------------------------------------------

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  double _h(BuildContext context, double value) {
    return _isTablet(context) ? value : value.h;
  }

  double _radius(BuildContext context, double value) {
    return _isTablet(context) ? value : value.r;
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // NAVIGATION
  // ------------------------------------------------------------

  void _goToSignIn() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignInScreen()));
  }

  // ------------------------------------------------------------
  // SCREEN
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // MAIN FORM
  // ------------------------------------------------------------

  Widget _buildForm(BuildContext context) {
    final bool isTablet = _isTablet(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 24.w,
        vertical: isTablet ? 24 : 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_linkSent)
            ..._buildRequestState(context)
          else
            ..._buildSentState(context),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REQUEST RESET STATE
  // ------------------------------------------------------------

  List<Widget> _buildRequestState(BuildContext context) {
    return [
      Text('Forgot Password?', style: AppTextStyles.headlineMd),

      SizedBox(height: _h(context, 8)),

      Text(
        "Enter your email address and we'll send you a link to reset "
        'your password.',
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),

      SizedBox(height: _h(context, 32)),

      Text('Email', style: AppTextStyles.labelLg),

      SizedBox(height: _h(context, 8)),

      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: AppTextStyles.bodyMd,
        decoration: _inputDecoration(context, hintText: 'Enter email address'),
      ),

      SizedBox(height: _h(context, 24)),

      SizedBox(
        width: double.infinity,
        height: _h(context, 52),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _linkSent = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(context, 8)),
            ),
          ),
          child: Text(
            'Send Reset Link',
            style: AppTextStyles.titleMd.copyWith(color: AppColors.background),
          ),
        ),
      ),

      SizedBox(height: _h(context, 24)),

      Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
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

  // ------------------------------------------------------------
  // RESET LINK SENT STATE
  // ------------------------------------------------------------

  List<Widget> _buildSentState(BuildContext context) {
    return [
      Text('Check your email', style: AppTextStyles.headlineMd),

      SizedBox(height: _h(context, 8)),

      Text(
        "We've sent a password reset link to your email address.",
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),

      SizedBox(height: _h(context, 32)),

      SizedBox(
        width: double.infinity,
        height: _h(context, 52),
        child: ElevatedButton(
          onPressed: _goToSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(context, 8)),
            ),
          ),
          child: Text(
            'Back to Sign In',
            style: AppTextStyles.titleMd.copyWith(color: AppColors.background),
          ),
        ),
      ),
    ];
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
  }) {
    final bool isTablet = _isTablet(context);

    final BorderRadius radius = BorderRadius.circular(isTablet ? 8 : 8.r);

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
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
}
