import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/hairdresser_summary.dart';
import 'book_shift_screen.dart';

class HairdresserProfileScreen extends StatelessWidget {
  const HairdresserProfileScreen({
    super.key,
    required this.hairdresser,
    this.embeddedInTabletShell = false,
    this.onBack,
  });

  final HairdresserSummary hairdresser;

  final bool embeddedInTabletShell;

  final VoidCallback? onBack;

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = _isTablet(context);

    if (embeddedInTabletShell && tablet) {
      return ColoredBox(
        color: AppColors.background,
        child: SafeArea(child: _buildTabletContent(context)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: tablet
            ? _buildTabletContent(context)
            : _buildMobileContent(context),
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          SizedBox(height: 16.h),

          Center(
            child: Column(
              children: [
                _buildMobileAvatar(),

                SizedBox(height: 16.h),

                Text(
                  hairdresser.name,
                  style: AppTextStyles.headlineSm,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                Text(
                  hairdresser.specialty,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (hairdresser.trainingInfo != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${hairdresser.trainingInfo} • '
                    '${hairdresser.locationArea}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: _buildMobileStat(
                  'Rate/Day',
                  '£${hairdresser.ratePerDay.toStringAsFixed(0)}',
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _buildMobileStat(
                  'Rating',
                  '★ ${hairdresser.rating} (${hairdresser.reviewCount})',
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _buildMobileStat(
                  'Show-up',
                  '${hairdresser.showUpPercentage ?? 100}%',
                ),
              ),
            ],
          ),

          SizedBox(height: 28.h),

          Text('Experience', style: AppTextStyles.titleMd),

          SizedBox(height: 8.h),

          Text(
            _experienceText,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 28.h),

          Text('Specialties', style: AppTextStyles.titleMd),

          SizedBox(height: 12.h),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [for (final tag in _specialties) _buildMobileTag(tag)],
          ),

          SizedBox(height: 28.h),

          Text('Recent Work', style: AppTextStyles.titleMd),

          SizedBox(height: 12.h),

          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                if (i != 0) SizedBox(width: 12.w),
                Expanded(child: _buildMobileWork()),
              ],
            ],
          ),

          SizedBox(height: 28.h),

          _buildMobileAvailability(),

          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () => _openBookShift(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Send Booking Request',
                style: AppTextStyles.titleMd.copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _buildTabletContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 26, 32, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (onBack != null) {
                    onBack!();
                    return;
                  }

                  Navigator.of(context).maybePop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),

              const SizedBox(height: 16),

              _buildTabletHero(),

              const SizedBox(height: 30),

              Text('Experience', style: AppTextStyles.titleMd),

              const SizedBox(height: 8),

              Text(
                _experienceText,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Text('Specialties', style: AppTextStyles.titleMd),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final tag in _specialties) _buildTabletTag(tag),
                ],
              ),

              const SizedBox(height: 30),

              Text('Recent Work', style: AppTextStyles.titleMd),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildTabletWork()),
                  const SizedBox(width: 14),
                  Expanded(child: _buildTabletWork()),
                  const SizedBox(width: 14),
                  Expanded(child: _buildTabletWork()),
                ],
              ),

              const SizedBox(height: 28),

              _buildTabletAvailability(),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _openBookShift(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send Booking Request',
                    style: AppTextStyles.titleMd.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildTabletAvatar(),

          const SizedBox(width: 32),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hairdresser.name, style: AppTextStyles.headlineSm),

                const SizedBox(height: 5),

                Text(
                  hairdresser.specialty,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                if (hairdresser.trainingInfo != null) ...[
                  const SizedBox(height: 5),

                  Text(
                    '${hairdresser.trainingInfo} • '
                    '${hairdresser.locationArea}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: _buildTabletStat(
                        'Rate/Day',
                        '£${hairdresser.ratePerDay.toStringAsFixed(0)}',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildTabletStat(
                        'Rating',
                        '★ ${hairdresser.rating} (${hairdresser.reviewCount})',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildTabletStat(
                        'Show-up',
                        '${hairdresser.showUpPercentage ?? 100}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE HELPERS
  // ============================================================

  Widget _buildMobileStat(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleSm,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4.h),

          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLg.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildMobileWork() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textSecondary,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildMobileAvailability() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              'Ready for Cover: '
              '${hairdresser.readyDate ?? hairdresser.availabilityLabel}',
              style: AppTextStyles.bodyMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAvatar() {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 56.r,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    return CircleAvatar(
      radius: 56.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _initials,
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // TABLET HELPERS
  // ============================================================

  Widget _buildTabletStat(String label, String value) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.titleSm,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLg.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTabletWork() {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textSecondary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildTabletAvailability() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: AppColors.primary,
            size: 21,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              'Ready for Cover: '
              '${hairdresser.readyDate ?? hairdresser.availabilityLabel}',
              style: AppTextStyles.bodyMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletAvatar() {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 70,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    return CircleAvatar(
      radius: 70,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _initials,
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _openBookShift(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookShiftScreen(hairdresser: hairdresser),
      ),
    );
  }

  // ============================================================
  // DATA
  // ============================================================

  String get _experienceText {
    return hairdresser.bio ??
        '${hairdresser.name} has '
            '${hairdresser.yearsExperience} years of experience '
            'in ${hairdresser.specialty}, with a strong track '
            'record of reliable, high-quality work for salons '
            'across London.';
  }

  List<String> get _specialties {
    return hairdresser.specialtyTags ?? [hairdresser.specialty];
  }

  String get _initials {
    return hairdresser.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }
}
