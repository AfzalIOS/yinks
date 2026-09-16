import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'sign_in_screen.dart';

enum _AccountType { salon, hairdresser }

const List<String> _experienceOptions = [
  '1 - 2 years',
  '3 - 5 years',
  '5 - 10 years',
  '10+ years (Master Stylist)',
];

const List<String> _availabilityOptions = ['Daily', 'Weekends', 'Long-term'];

/// Sign Up screen: account type selection with dynamic Salon /
/// Hairdresser forms. No auth logic wired up yet.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  _AccountType _accountType = _AccountType.salon;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _experience;
  String? _availability;

  final _salonNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _niNumberController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _salonNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _niNumberController.dispose();
    _specialtiesController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              Text('Create Account', style: AppTextStyles.headlineMd),
              SizedBox(height: 8.h),
              Text(
                'Join YINKS and get started',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 32.h),
              Text('Account Type', style: AppTextStyles.labelLg),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildAccountTypeOption(
                      type: _AccountType.salon,
                      label: 'Salon',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAccountTypeOption(
                      type: _AccountType.hairdresser,
                      label: 'Hairdresser',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              if (_accountType == _AccountType.salon)
                _buildSalonForm()
              else
                _buildHairdresserForm(),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Create Account',
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
                      'Already have an account? ',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                        );
                      },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalonForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Salon Name'),
        _buildTextField(
          controller: _salonNameController,
          hintText: 'Enter salon name',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Phone Number'),
        _buildPhoneField(),
        SizedBox(height: 16.h),
        _buildLabel('Location'),
        _buildTextField(
          controller: _locationController,
          hintText: 'Search your salon location',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Email'),
        _buildTextField(
          controller: _emailController,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        _buildLabel('Password'),
        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Enter password',
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        SizedBox(height: 16.h),
        _buildLabel('Confirm Password'),
        _buildPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Confirm password',
          obscureText: _obscureConfirmPassword,
          onToggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildHairdresserForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Full Name'),
        _buildTextField(
          controller: _fullNameController,
          hintText: 'Enter full name',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Phone Number'),
        _buildPhoneField(),
        SizedBox(height: 16.h),
        _buildLabel('Location'),
        _buildTextField(
          controller: _locationController,
          hintText: 'Search your location',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Email'),
        _buildTextField(
          controller: _emailController,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        _buildLabel('NI Number'),
        _buildTextField(
          controller: _niNumberController,
          hintText: 'Enter NI number',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Years of Experience'),
        _buildDropdown(
          hintText: 'Select experience',
          value: _experience,
          options: _experienceOptions,
          onChanged: (value) => setState(() => _experience = value),
        ),
        SizedBox(height: 16.h),
        _buildLabel('Specialties'),
        _buildTextField(
          controller: _specialtiesController,
          hintText: 'Enter Your Specialties ',
        ),
        SizedBox(height: 16.h),
        _buildLabel('Availability'),
        _buildDropdown(
          hintText: 'Select availability',
          value: _availability,
          options: _availabilityOptions,
          onChanged: (value) => setState(() => _availability = value),
        ),
        SizedBox(height: 16.h),
        _buildLabel('Password'),
        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Enter password',
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        SizedBox(height: 16.h),
        _buildLabel('Confirm Password'),
        _buildPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Confirm password',
          obscureText: _obscureConfirmPassword,
          onToggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: AppTextStyles.labelLg),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMd,
      decoration: _inputDecoration(hintText: hintText),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: AppTextStyles.bodyMd,
      decoration: _inputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    // Custom UK-only input (no external phone package, no flags/emoji)
    // to avoid the intl_phone_field tablet rendering issues. When
    // international support is needed later, a proper country selector
    // will be built from scratch instead of reintroducing that package.
    final radius = BorderRadius.circular(8.r);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
          ),
          child: Text('+44', style: AppTextStyles.bodyMd),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: AppTextStyles.bodyMd,
            decoration: _inputDecoration(hintText: 'Enter phone number'),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.textSecondary,
        size: 20.sp,
      ),
      hint: Text(
        hintText,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      style: AppTextStyles.bodyMd,
      decoration: _inputDecoration(hintText: hintText),
      items: options
          .map(
            (option) => DropdownMenuItem(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    final radius = BorderRadius.circular(8.r);
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      suffixIcon: suffixIcon,
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

  Widget _buildAccountTypeOption({
    required _AccountType type,
    required String label,
  }) {
    final isSelected = _accountType == type;
    return GestureDetector(
      onTap: () => setState(() => _accountType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
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
                        width: 10,
                        height: 10,
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
            const SizedBox(width: 8),
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
