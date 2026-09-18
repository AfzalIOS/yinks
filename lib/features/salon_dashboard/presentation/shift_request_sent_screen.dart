import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/booking_details.dart';
import '../domain/hairdresser_summary.dart';
import 'salon_main_shell.dart';

class ShiftRequestSentScreen extends StatelessWidget {
  ShiftRequestSentScreen({
    super.key,
    required this.hairdresser,
    required this.details,
  }) : bookingRef = 'YNK-${1000 + Random().nextInt(9000)}';

  final HairdresserSummary hairdresser;
  final BookingDetails details;

  final String bookingRef;

  // ============================================================
  // DEVICE CHECKS
  // ============================================================

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isPhoneLandscape(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return mediaQuery.size.shortestSide < 600 &&
        mediaQuery.orientation == Orientation.landscape;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);
    final bool isPhoneLandscape = _isPhoneLandscape(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context)
            : isPhoneLandscape
            ? _buildPhoneLandscapeLayout(context)
            : _buildMobilePortraitLayout(context),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT
  // Existing mobile design preserved
  // ============================================================

  Widget _buildMobilePortraitLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          SizedBox(height: 16.h),

          // SUCCESS ICON
          Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 56.sp,
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            'Shift Request Sent',
            style: AppTextStyles.headlineSm,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            "We've notified ${hairdresser.name}. "
            'You will receive an alert as soon as they accept.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 28.h),

          _buildMobileSummaryCard(),

          SizedBox(height: 28.h),

          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: _buildActionButton(context, radius: 8.r),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE
  // No drawer
  // Compact layout
  // ============================================================

  Widget _buildPhoneLandscapeLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _buildLogicalBackButton(context),
              ),

              const SizedBox(height: 4),

              _buildSuccessIcon(outerSize: 64, iconSize: 44),

              const SizedBox(height: 10),

              Text(
                'Shift Request Sent',
                style: AppTextStyles.headlineSm,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              Text(
                "We've notified ${hairdresser.name}. "
                'You will receive an alert as soon as they accept.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              _buildLogicalSummaryCard(compact: true),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: _buildActionButton(context, radius: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLET
  // Portrait + Landscape
  // NO DRAWER
  // ============================================================

  Widget _buildTabletLayout(BuildContext context) {
    final bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isLandscape ? 48 : 36,
        28,
        isLandscape ? 48 : 36,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isLandscape ? 980 : 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =================================================
              // BACK
              // =================================================
              Align(
                alignment: Alignment.centerLeft,
                child: _buildLogicalBackButton(context),
              ),

              SizedBox(height: isLandscape ? 12 : 28),

              // =================================================
              // SUCCESS ICON
              // Fixed logical size
              // =================================================
              _buildSuccessIcon(
                outerSize: isLandscape ? 84 : 92,
                iconSize: isLandscape ? 58 : 62,
              ),

              SizedBox(height: isLandscape ? 18 : 22),

              // =================================================
              // TITLE
              // =================================================
              Text(
                'Shift Request Sent',
                style: AppTextStyles.headlineSm,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // =================================================
              // DESCRIPTION
              // =================================================
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  "We've notified ${hairdresser.name}. "
                  'You will receive an alert as soon as they accept.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: isLandscape ? 26 : 32),

              // =================================================
              // SUMMARY
              // =================================================
              _buildLogicalSummaryCard(),

              SizedBox(height: isLandscape ? 22 : 28),

              // =================================================
              // BUTTON
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: _buildActionButton(context, radius: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGICAL SUCCESS ICON
  // ============================================================

  Widget _buildSuccessIcon({
    required double outerSize,
    required double iconSize,
  }) {
    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE SUMMARY CARD
  // ============================================================

  Widget _buildMobileSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Booking Ref', style: AppTextStyles.labelLg),
              Text(bookingRef, style: AppTextStyles.titleSm),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status', style: AppTextStyles.labelLg),
              _buildMobileStatusBadge(),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: AppColors.border, height: 1),
          ),

          _buildMobileDetailRow('Hairdresser', hairdresser.name),

          SizedBox(height: 10.h),

          _buildMobileDetailRow('Shift Date', _formatDate(details.shiftDate)),

          SizedBox(height: 10.h),

          _buildMobileDetailRow(
            'Hours & Station',
            '${details.hoursLabel} (${details.station})',
          ),

          SizedBox(height: 10.h),

          _buildMobileDetailRow(
            'Amount',
            '£${hairdresser.ratePerDay.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE DETAIL ROW
  // ============================================================

  Widget _buildMobileDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppTextStyles.bodyMd,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE STATUS BADGE
  // ============================================================

  Widget _buildMobileStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.lightAccent,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        'Pending Stylist',
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // TABLET / LANDSCAPE SUMMARY
  // Logical pixels only
  // ============================================================

  Widget _buildLogicalSummaryCard({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 18 : 24,
        vertical: compact ? 14 : 22,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogicalTopRow(
            'Booking Ref',
            Text(bookingRef, style: AppTextStyles.titleSm),
          ),

          SizedBox(height: compact ? 10 : 14),

          _buildLogicalTopRow(
            'Status',
            _buildLogicalStatusBadge(compact: compact),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 10 : 14),
            child: Divider(color: AppColors.border, height: 1),
          ),

          _buildLogicalDetailRow('Hairdresser', hairdresser.name),

          SizedBox(height: compact ? 8 : 12),

          _buildLogicalDetailRow('Shift Date', _formatDate(details.shiftDate)),

          SizedBox(height: compact ? 8 : 12),

          _buildLogicalDetailRow(
            'Hours & Station',
            '${details.hoursLabel} (${details.station})',
          ),

          SizedBox(height: compact ? 8 : 12),

          _buildLogicalDetailRow(
            'Amount',
            '£${hairdresser.ratePerDay.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGICAL TOP ROW
  // ============================================================

  Widget _buildLogicalTopRow(String label, Widget trailing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(label, style: AppTextStyles.labelLg)),

        const SizedBox(width: 20),

        trailing,
      ],
    );
  }

  // ============================================================
  // LOGICAL DETAIL ROW
  // ============================================================

  Widget _buildLogicalDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        const SizedBox(width: 24),

        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppTextStyles.bodyMd,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGICAL STATUS BADGE
  // ============================================================

  Widget _buildLogicalStatusBadge({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Pending Stylist',
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // BACK BUTTON
  // ============================================================

  Widget _buildLogicalBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }

  // ============================================================
  // VIEW ACTIVE REQUESTS BUTTON
  // Existing navigation preserved
  // ============================================================

  Widget _buildActionButton(BuildContext context, {required double radius}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const SalonMainShell(initialIndex: 2),
          ),
          (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        'View Active Requests',
        style: AppTextStyles.titleMd.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
