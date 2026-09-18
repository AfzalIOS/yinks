import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/adaptive_auth_layout.dart';
import 'sign_in_screen.dart';

enum _AccountType { salon, hairdresser }

const List<String> _experienceOptions = [
  '1 - 2 years',
  '3 - 5 years',
  '5 - 10 years',
  '10+ years (Master Stylist)',
];

const List<String> _availabilityOptions = ['Daily', 'Weekends', 'Long-term'];

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

  // ------------------------------------------------------------
  // RESPONSIVE HELPERS
  // ------------------------------------------------------------

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  double _h(BuildContext context, double value) {
    return _isTablet(context) ? value : value.h;
  }

  double _w(BuildContext context, double value) {
    return _isTablet(context) ? value : value.w;
  }

  double _radius(BuildContext context, double value) {
    return _isTablet(context) ? value : value.r;
  }

  double _iconSize(BuildContext context, double value) {
    return _isTablet(context) ? value : value.sp;
  }

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
              'Join YINKS and connect with trusted salons and professional '
              'hairdressing talent across the UK.',
          formContent: _buildForm(context),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN FORM
  // ------------------------------------------------------------

  Widget _buildForm(BuildContext context) {
    final isTablet = _isTablet(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 24.w,
        vertical: isTablet ? 24 : 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Text('Create Account', style: AppTextStyles.headlineMd),

          SizedBox(height: _h(context, 8)),

          Text(
            'Join YINKS and get started',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: _h(context, 32)),

          // ACCOUNT TYPE
          Text('Account Type', style: AppTextStyles.labelLg),

          SizedBox(height: _h(context, 12)),

          Row(
            children: [
              Expanded(
                child: _buildAccountTypeOption(
                  context: context,
                  type: _AccountType.salon,
                  label: 'Salon',
                ),
              ),

              SizedBox(width: _w(context, 12)),

              Expanded(
                child: _buildAccountTypeOption(
                  context: context,
                  type: _AccountType.hairdresser,
                  label: 'Hairdresser',
                ),
              ),
            ],
          ),

          SizedBox(height: _h(context, 24)),

          // DYNAMIC FORM
          if (_accountType == _AccountType.salon)
            _buildSalonForm(context)
          else
            _buildHairdresserForm(context),

          SizedBox(height: _h(context, 24)),

          // CREATE ACCOUNT BUTTON
          SizedBox(
            width: double.infinity,
            height: _h(context, 52),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius(context, 8)),
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

          SizedBox(height: _h(context, 24)),

          // SIGN IN
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
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
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
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
    );
  }

  // ------------------------------------------------------------
  // SALON FORM
  // ------------------------------------------------------------

  Widget _buildSalonForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Salon Name'),

        _buildTextField(
          context: context,
          controller: _salonNameController,
          hintText: 'Enter salon name',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Phone Number'),

        _buildPhoneField(context),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Location'),

        _buildTextField(
          context: context,
          controller: _locationController,
          hintText: 'Search your salon location',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Email'),

        _buildTextField(
          context: context,
          controller: _emailController,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Password'),

        _buildPasswordField(
          context: context,
          controller: _passwordController,
          hintText: 'Enter password',
          obscureText: _obscurePassword,
          onToggle: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Confirm Password'),

        _buildPasswordField(
          context: context,
          controller: _confirmPasswordController,
          hintText: 'Confirm password',
          obscureText: _obscureConfirmPassword,
          onToggle: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HAIRDRESSER FORM
  // ------------------------------------------------------------

  Widget _buildHairdresserForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Full Name'),

        _buildTextField(
          context: context,
          controller: _fullNameController,
          hintText: 'Enter full name',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Phone Number'),

        _buildPhoneField(context),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Location'),

        _buildTextField(
          context: context,
          controller: _locationController,
          hintText: 'Search your location',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Email'),

        _buildTextField(
          context: context,
          controller: _emailController,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'NI Number'),

        _buildTextField(
          context: context,
          controller: _niNumberController,
          hintText: 'Enter NI number',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Years of Experience'),

        _buildDropdown(
          context: context,
          hintText: 'Select experience',
          value: _experience,
          options: _experienceOptions,
          onChanged: (value) {
            setState(() {
              _experience = value;
            });
          },
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Specialties'),

        _buildTextField(
          context: context,
          controller: _specialtiesController,
          hintText: 'Enter Your Specialties ',
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Availability'),

        _buildDropdown(
          context: context,
          hintText: 'Select availability',
          value: _availability,
          options: _availabilityOptions,
          onChanged: (value) {
            setState(() {
              _availability = value;
            });
          },
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Password'),

        _buildPasswordField(
          context: context,
          controller: _passwordController,
          hintText: 'Enter password',
          obscureText: _obscurePassword,
          onToggle: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        SizedBox(height: _h(context, 16)),

        _buildLabel(context, 'Confirm Password'),

        _buildPasswordField(
          context: context,
          controller: _confirmPasswordController,
          hintText: 'Confirm password',
          obscureText: _obscureConfirmPassword,
          onToggle: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // LABEL
  // ------------------------------------------------------------

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: _h(context, 8)),
      child: Text(text, style: AppTextStyles.labelLg),
    );
  }

  // ------------------------------------------------------------
  // NORMAL TEXT FIELD
  // ------------------------------------------------------------

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMd,
      decoration: _inputDecoration(context: context, hintText: hintText),
    );
  }

  // ------------------------------------------------------------
  // PASSWORD FIELD
  // ------------------------------------------------------------

  Widget _buildPasswordField({
    required BuildContext context,
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
        context: context,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: _iconSize(context, 20),
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PHONE FIELD
  // ------------------------------------------------------------

  Widget _buildPhoneField(BuildContext context) {
    final isTablet = _isTablet(context);

    final radius = BorderRadius.circular(_radius(context, 8));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: isTablet ? 108 : 108.w,
          height: isTablet ? 52 : 52.h,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: radius,
              border: Border.all(color: AppColors.border),
            ),
            child: CountryCodePicker(
              onChanged: (_) {},
              initialSelection: 'GB',
              showFlag: true,
              showDropDownButton: true,
              alignLeft: false,
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 4 : 4.w),
              flagWidth: isTablet ? 20 : 20.w,
              textStyle: AppTextStyles.bodyMd,
            ),
          ),
        ),

        SizedBox(width: isTablet ? 8 : 8.w),

        Expanded(
          child: SizedBox(
            height: isTablet ? 52 : 52.h,
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.bodyMd,
              decoration: _inputDecoration(
                context: context,
                hintText: 'Enter phone number',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DROPDOWN
  // ------------------------------------------------------------

  Widget _buildDropdown({
    required BuildContext context,
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
        size: _iconSize(context, 20),
      ),
      hint: Text(
        hintText,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      style: AppTextStyles.bodyMd,
      decoration: _inputDecoration(context: context, hintText: hintText),
      items: options
          .map(
            (option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? suffixIcon,
  }) {
    final isTablet = _isTablet(context);

    final radius = BorderRadius.circular(isTablet ? 8 : 8.r);

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      suffixIcon: suffixIcon,

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
  // ACCOUNT TYPE OPTION
  // ------------------------------------------------------------

  Widget _buildAccountTypeOption({
    required BuildContext context,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(_radius(context, 8)),
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
