import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/hairdresser_summary.dart';
import '../domain/salon_repository.dart';
import 'find_hairdressers_screen.dart';

class _DashboardData {
  const _DashboardData({
    required this.hairdressers,
    required this.activeInvites,
    required this.upcomingShifts,
  });

  final List<HairdresserSummary> hairdressers;
  final int activeInvites;
  final int upcomingShifts;
}

/// Salon Dashboard: summary counts, a featured call-to-action, and a
/// list of recommended hairdressers. Backed by [SalonRepository] so a
/// real (Firebase) implementation can replace [MockSalonRepository]
/// later without any UI changes.
class SalonDashboardScreen extends StatefulWidget {
  const SalonDashboardScreen({super.key});

  @override
  State<SalonDashboardScreen> createState() => _SalonDashboardScreenState();
}

class _SalonDashboardScreenState extends State<SalonDashboardScreen> {
  final SalonRepository _repository = MockSalonRepository();
  late final Future<_DashboardData> _future = _loadDashboard();

  Future<_DashboardData> _loadDashboard() async {
    final results = await Future.wait([
      _repository.getRecommendedHairdressers(),
      _repository.getActiveInvitesCount(),
      _repository.getUpcomingShiftsCount(),
    ]);
    return _DashboardData(
      hairdressers: results[0] as List<HairdresserSummary>,
      activeInvites: results[1] as int,
      upcomingShifts: results[2] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<_DashboardData>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maison Mayfair', style: AppTextStyles.headlineSm),
                  SizedBox(height: 4.h),
                  Text(
                    'Mayfair Atelier',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          label: 'Active Invites',
                          count: data.activeInvites,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildSummaryCard(
                          label: 'Upcoming Shifts',
                          count: data.upcomingShifts,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildFeaturedCard(),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Recommended Near You',
                          style: AppTextStyles.titleMd,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Column(
                    children: [
                      for (final hairdresser in data.hairdressers) ...[
                        _buildHairdresserCard(hairdresser),
                        SizedBox(height: 12.h),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count', style: AppTextStyles.headlineSm),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need a Top Stylist Today?',
            style: AppTextStyles.titleLg.copyWith(color: AppColors.background),
          ),
          SizedBox(height: 6.h),
          Text(
            'Browse available hairdressers ready to work on short notice.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.background.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FindHairdressersScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Find Available Hairdressers',
                style: AppTextStyles.titleSm.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHairdresserCard(HairdresserSummary hairdresser) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(hairdresser),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hairdresser.name,
                  style: AppTextStyles.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  hairdresser.specialty,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 14.sp, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      '${hairdresser.rating} (${hairdresser.reviewCount})',
                      style: AppTextStyles.labelMd,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        hairdresser.availabilityLabel,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${hairdresser.ratePerDay.toStringAsFixed(0)}/day',
                style: AppTextStyles.titleSm,
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 32.h,
                child: OutlinedButton(
                  // Will navigate to the hairdresser's profile once built.
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Profile',
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(HairdresserSummary hairdresser) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 28.r,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    final initials = hairdresser.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 28.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
