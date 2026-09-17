import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/booking_details.dart';
import '../domain/hairdresser_summary.dart';

/// Confirmation screen shown right after a shift request is sent. No
/// real booking/notification logic yet.
class ShiftRequestSentScreen extends StatelessWidget {
  ShiftRequestSentScreen({
    super.key,
    required this.hairdresser,
    required this.details,
  }) : bookingRef = 'YNK-${1000 + Random().nextInt(9000)}';

  final HairdresserSummary hairdresser;
  final BookingDetails details;

  /// Generated once per screen instance (the constructor only runs when
  /// this screen is first pushed), so it stays stable for the life of
  /// this confirmation view.
  final String bookingRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              Container(
                width: 88.r,
                height: 88.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
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
                "We've notified ${hairdresser.name}. You will receive "
                'an alert as soon as they accept.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              _buildSummaryCard(),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  // Will navigate to the Requests screen once built.
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'View Active Requests',
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

  Widget _buildSummaryCard() {
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
              _buildStatusBadge(),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: AppColors.border, height: 1),
          ),
          _buildDetailRow('Hairdresser', hairdresser.name),
          SizedBox(height: 10.h),
          _buildDetailRow('Shift Date', _formatDate(details.shiftDate)),
          SizedBox(height: 10.h),
          _buildDetailRow(
            'Hours & Station',
            '${details.hoursLabel} (${details.station})',
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            'Amount',
            '£${hairdresser.ratePerDay.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Widget _buildStatusBadge() {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
