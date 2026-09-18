import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/opportunity_summary.dart';

/// Shared opportunity card used by both the Hairdresser Dashboard's
/// "Recommended For You" section and the Opportunities screen, so the
/// card style stays a single source of truth rather than being
/// duplicated across the two screens.
class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onViewDetails,
    this.fixedSizing = false,
  });

  final OpportunitySummary opportunity;
  final VoidCallback onViewDetails;

  /// True on tablet or mobile landscape, where structural sizing must
  /// use fixed logical pixels instead of ScreenUtil scaling.
  final bool fixedSizing;

  @override
  Widget build(BuildContext context) {
    final double padding = fixedSizing ? 12 : 12.w;
    final double radius = fixedSizing ? 12 : 12.r;
    final double avatarRadius = fixedSizing ? 28 : 28.r;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildAvatar(avatarRadius),

          SizedBox(width: fixedSizing ? 12 : 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity.salonName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSm,
                ),

                const SizedBox(height: 2),

                Text(
                  opportunity.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        '${opportunity.date} • ${opportunity.hours}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),

                    const SizedBox(width: 4),

                    // Expanded (not a bare Text) so this can never
                    // force a RenderFlex overflow on a narrow
                    // tablet/landscape grid card — it ellipsizes
                    // instead.
                    Expanded(
                      child: Text(
                        '${opportunity.distanceMiles} mi away',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${opportunity.payAmount.toStringAsFixed(0)}',
                style: AppTextStyles.titleSm,
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View Details',
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

  Widget _buildAvatar(double radius) {
    if (opportunity.photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(opportunity.photoUrl!),
      );
    }

    final initials = opportunity.salonName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
