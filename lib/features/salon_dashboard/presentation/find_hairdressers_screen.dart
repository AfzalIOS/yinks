import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/hairdresser_summary.dart';
import '../domain/salon_repository.dart';
import 'hairdresser_profile_screen.dart';

const List<String> _filters = [
  'All Specialties',
  'Balayage',
  'Colorists',
  'Precision Cuts',
];

/// Find Hairdressers: browse and filter all available hairdressers by
/// specialty. Backed by [SalonRepository] so a real (Firebase)
/// implementation can replace [MockSalonRepository] later without any
/// UI changes.
class FindHairdressersScreen extends StatefulWidget {
  const FindHairdressersScreen({super.key});

  @override
  State<FindHairdressersScreen> createState() =>
      _FindHairdressersScreenState();
}

class _FindHairdressersScreenState extends State<FindHairdressersScreen> {
  final SalonRepository _repository = MockSalonRepository();
  late final Future<List<HairdresserSummary>> _future =
      _repository.getAllHairdressers();

  String _selectedFilter = _filters.first;

  List<HairdresserSummary> _applyFilter(List<HairdresserSummary> all) {
    if (_selectedFilter == _filters.first) return all;
    final query = _selectedFilter.toLowerCase();
    return all
        .where((h) => h.specialty.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Find Hairdressers', style: AppTextStyles.headlineSm),
                        SizedBox(height: 4.h),
                        Text(
                          'Freelance artists available in Mayfair, '
                          'Chelsea & Soho',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) =>
                    _buildFilterChip(_filters[index]),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: FutureBuilder<List<HairdresserSummary>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  final results = _applyFilter(snapshot.data!);
                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        'No hairdressers match this filter.',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) =>
                        _buildHairdresserCard(results[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = label == _selectedFilter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLg.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHairdresserCard(HairdresserSummary hairdresser) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  ],
                ),
              ),
              Text(
                '£${hairdresser.ratePerDay.toStringAsFixed(0)}/day',
                style: AppTextStyles.titleSm,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.star, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                '${hairdresser.rating} (${hairdresser.reviewCount})',
                style: AppTextStyles.labelMd,
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 2.w),
              Text(
                '${hairdresser.locationArea} · '
                '${hairdresser.yearsExperience} yrs exp',
                style: AppTextStyles.labelMd,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            hairdresser.availabilityLabel,
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        HairdresserProfileScreen(hairdresser: hairdresser),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'View Profile',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(HairdresserSummary hairdresser) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 26.r,
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
      radius: 26.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
