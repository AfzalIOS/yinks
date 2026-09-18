import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/salon_repository.dart';
import '../domain/shift_request.dart';

/// Bookings: confirmed shift cover, grouped by date proximity.
///
/// Responsive behavior:
/// - Mobile portrait: 1 column
/// - Mobile landscape: 2 compact columns
/// - Tablet portrait: 1 column
/// - Tablet landscape: 2 columns
///
/// Tablet drawer/sidebar is handled by SalonMainShell.
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key, this.showBackButton = true});

  /// False when embedded as a root tab inside SalonMainShell.
  final bool showBackButton;

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final SalonRepository _repository = MockSalonRepository();

  late final Future<List<ShiftRequest>> _future = _repository
      .getConfirmedBookings();

  // ============================================================
  // DEVICE HELPERS
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
  // DATE GROUPING
  // ============================================================

  bool _isTodayOrTomorrow(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final tomorrow = today.add(const Duration(days: 1));

    final day = DateTime(date.year, date.month, date.day);

    return day == today || day == tomorrow;
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
        child: FutureBuilder<List<ShiftRequest>>(
          future: _future,
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // Error
            if (snapshot.hasError) {
              return _buildErrorState(
                isLogicalLayout: isTablet || isPhoneLandscape,
              );
            }

            final bookings = snapshot.data ?? <ShiftRequest>[];

            // Empty
            if (bookings.isEmpty) {
              if (isTablet || isPhoneLandscape) {
                return _buildLogicalEmptyLayout();
              }

              return _buildMobileEmptyLayout();
            }

            // Group bookings
            final soon = bookings
                .where((booking) => _isTodayOrTomorrow(booking.shiftDate))
                .toList();

            final upcoming = bookings
                .where((booking) => !_isTodayOrTomorrow(booking.shiftDate))
                .toList();

            // Tablet
            if (isTablet) {
              final bool isLandscape =
                  MediaQuery.orientationOf(context) == Orientation.landscape;

              return _buildTabletLayout(
                soon: soon,
                upcoming: upcoming,
                isLandscape: isLandscape,
              );
            }

            // Phone landscape
            if (isPhoneLandscape) {
              return _buildPhoneLandscapeLayout(soon: soon, upcoming: upcoming);
            }

            // Phone portrait
            return _buildMobilePortraitLayout(soon: soon, upcoming: upcoming);
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT
  // 1 COLUMN
  // ============================================================

  Widget _buildMobilePortraitLayout({
    required List<ShiftRequest> soon,
    required List<ShiftRequest> upcoming,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileHeader(),

          SizedBox(height: 20.h),

          if (soon.isNotEmpty) ...[
            _buildSectionHeader('Today & Tomorrow'),

            SizedBox(height: 12.h),

            for (int index = 0; index < soon.length; index++) ...[
              _buildMobileBookingCard(soon[index]),
              if (index != soon.length - 1) SizedBox(height: 12.h),
            ],

            if (upcoming.isNotEmpty) SizedBox(height: 20.h),
          ],

          if (upcoming.isNotEmpty) ...[
            _buildSectionHeader('Upcoming'),

            SizedBox(height: 12.h),

            for (int index = 0; index < upcoming.length; index++) ...[
              _buildMobileBookingCard(upcoming[index]),
              if (index != upcoming.length - 1) SizedBox(height: 12.h),
            ],
          ],
        ],
      ),
    );
  }

  // ============================================================
  // PHONE LANDSCAPE
  //
  // IMPORTANT:
  // Still a PHONE.
  // Bottom navigation remains handled by SalonMainShell.
  // 2 compact columns.
  // ============================================================

  Widget _buildPhoneLandscapeLayout({
    required List<ShiftRequest> soon,
    required List<ShiftRequest> upcoming,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 20;
        const double verticalPadding = 16;
        const double gap = 12;

        final double availableWidth =
            constraints.maxWidth - (horizontalPadding * 2);

        final double cardWidth = (availableWidth - gap) / 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalHeader(),

              const SizedBox(height: 16),

              // TODAY & TOMORROW
              if (soon.isNotEmpty) ...[
                _buildSectionHeader('Today & Tomorrow'),

                const SizedBox(height: 10),

                _buildLogicalBookingGrid(
                  bookings: soon,
                  cardWidth: cardWidth,
                  gap: gap,
                  layout: _BookingCardLayout.mobileLandscape,
                ),

                if (upcoming.isNotEmpty) const SizedBox(height: 18),
              ],

              // UPCOMING
              if (upcoming.isNotEmpty) ...[
                _buildSectionHeader('Upcoming'),

                const SizedBox(height: 10),

                _buildLogicalBookingGrid(
                  bookings: upcoming,
                  cardWidth: cardWidth,
                  gap: gap,
                  layout: _BookingCardLayout.mobileLandscape,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // TABLET
  //
  // Drawer/sidebar is NOT created here.
  // SalonMainShell handles it.
  //
  // Portrait: 1 column
  // Landscape: 2 columns
  // ============================================================

  Widget _buildTabletLayout({
    required List<ShiftRequest> soon,
    required List<ShiftRequest> upcoming,
    required bool isLandscape,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 32;
        const double verticalPadding = 28;
        const double gap = 16;
        const double maxContentWidth = 1200;

        final double contentWidth = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;

        final double availableCardsWidth =
            contentWidth - (horizontalPadding * 2);

        final double cardWidth = isLandscape
            ? (availableCardsWidth - gap) / 2
            : availableCardsWidth;

        final _BookingCardLayout cardLayout = isLandscape
            ? _BookingCardLayout.tabletLandscape
            : _BookingCardLayout.tabletPortrait;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: verticalPadding, bottom: 32),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogicalHeader(),

                    const SizedBox(height: 24),

                    // TODAY & TOMORROW
                    if (soon.isNotEmpty) ...[
                      _buildSectionHeader('Today & Tomorrow'),

                      const SizedBox(height: 14),

                      _buildLogicalBookingGrid(
                        bookings: soon,
                        cardWidth: cardWidth,
                        gap: gap,
                        layout: cardLayout,
                      ),

                      if (upcoming.isNotEmpty) const SizedBox(height: 28),
                    ],

                    // UPCOMING
                    if (upcoming.isNotEmpty) ...[
                      _buildSectionHeader('Upcoming'),

                      const SizedBox(height: 14),

                      _buildLogicalBookingGrid(
                        bookings: upcoming,
                        cardWidth: cardWidth,
                        gap: gap,
                        layout: cardLayout,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // MOBILE HEADER
  // ============================================================

  Widget _buildMobileHeader() {
    return Row(
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 8.w),
        ],
        Text('Bookings', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // PHONE LANDSCAPE / TABLET HEADER
  // ============================================================

  Widget _buildLogicalHeader() {
    return Row(
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 8),
        ],
        Text('Bookings', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTextStyles.titleMd);
  }

  // ============================================================
  // MOBILE PORTRAIT CARD
  //
  // Original mobile style.
  // ============================================================

  Widget _buildMobileBookingCard(ShiftRequest booking) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileAvatar(booking),

                SizedBox(width: 12.w),

                Expanded(
                  child: Text(
                    booking.hairdresserName,
                    style: AppTextStyles.titleSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: 8.w),

                _buildMobileConfirmedBadge(),
              ],
            ),

            SizedBox(height: 12.h),

            _buildMobileDetailRow('Shift Date & Hours', _formatShift(booking)),

            SizedBox(height: 8.h),

            _buildMobileDetailRow('Station', booking.station),

            SizedBox(height: 8.h),

            _buildMobileDetailRow(
              'Amount',
              '£${booking.amount.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 2-COLUMN / TABLET GRID
  // ============================================================

  Widget _buildLogicalBookingGrid({
    required List<ShiftRequest> bookings,
    required double cardWidth,
    required double gap,
    required _BookingCardLayout layout,
  }) {
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final booking in bookings)
          SizedBox(
            width: cardWidth,
            child: _buildLogicalBookingCard(booking, layout: layout),
          ),
      ],
    );
  }

  // ============================================================
  // PHONE LANDSCAPE / TABLET CARD
  // ============================================================

  Widget _buildLogicalBookingCard(
    ShiftRequest booking, {
    required _BookingCardLayout layout,
  }) {
    final bool isPhoneLandscape = layout == _BookingCardLayout.mobileLandscape;

    final bool isTabletPortrait = layout == _BookingCardLayout.tabletPortrait;

    final double padding = isPhoneLandscape ? 12 : 20;

    final double avatarRadius = isPhoneLandscape
        ? 18
        : isTabletPortrait
        ? 26
        : 23;

    final double avatarGap = isPhoneLandscape ? 10 : 14;

    final double badgeGap = isPhoneLandscape ? 8 : 12;

    final double headerBottomGap = isPhoneLandscape ? 10 : 16;

    final double detailGap = isPhoneLandscape ? 6 : 10;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,

        // No fixed height.
        // Card height depends only on content.
        padding: EdgeInsets.all(padding),

        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(isPhoneLandscape ? 10 : 14),
          border: Border.all(color: AppColors.border),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TOP
            // ==================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogicalAvatar(booking, radius: avatarRadius),

                SizedBox(width: avatarGap),

                Expanded(
                  child: Text(
                    booking.hairdresserName,
                    style: AppTextStyles.titleSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: badgeGap),

                _buildLogicalConfirmedBadge(compact: isPhoneLandscape),
              ],
            ),

            SizedBox(height: headerBottomGap),

            // ==================================================
            // DETAILS
            // ==================================================
            _buildLogicalDetailRow(
              'Shift Date & Hours',
              _formatShift(booking),
              compact: isPhoneLandscape,
            ),

            SizedBox(height: detailGap),

            _buildLogicalDetailRow(
              'Station',
              booking.station,
              compact: isPhoneLandscape,
            ),

            SizedBox(height: detailGap),

            _buildLogicalDetailRow(
              'Amount',
              '£${booking.amount.toStringAsFixed(2)}',
              compact: isPhoneLandscape,
            ),
          ],
        ),
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
  // PHONE LANDSCAPE / TABLET DETAIL ROW
  // ============================================================

  Widget _buildLogicalDetailRow(
    String label,
    String value, {
    bool compact = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: compact ? 4 : 3,
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        SizedBox(width: compact ? 8 : 16),

        Expanded(
          flex: compact ? 7 : 6,
          child: Text(
            value,
            style: compact
                ? AppTextStyles.bodySm.copyWith(color: AppColors.textPrimary)
                : AppTextStyles.bodyMd,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE CONFIRMED BADGE
  // ============================================================

  Widget _buildMobileConfirmedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        'Confirmed',
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // PHONE LANDSCAPE / TABLET BADGE
  // ============================================================

  Widget _buildLogicalConfirmedBadge({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 12,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Confirmed',
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE AVATAR
  // ============================================================

  Widget _buildMobileAvatar(ShiftRequest booking) {
    if (booking.hairdresserPhotoUrl != null) {
      return CircleAvatar(
        radius: 20.r,
        backgroundImage: NetworkImage(booking.hairdresserPhotoUrl!),
      );
    }

    return CircleAvatar(
      radius: 20.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(booking.hairdresserName),
        style: AppTextStyles.labelLg.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // PHONE LANDSCAPE / TABLET AVATAR
  // ============================================================

  Widget _buildLogicalAvatar(ShiftRequest booking, {required double radius}) {
    if (booking.hairdresserPhotoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(booking.hairdresserPhotoUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(booking.hairdresserName),
        style: AppTextStyles.labelLg.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // MOBILE EMPTY STATE
  // ============================================================

  Widget _buildMobileEmptyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileHeader(),

          SizedBox(height: 60.h),

          Center(
            child: Text(
              'No confirmed bookings yet.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGICAL EMPTY STATE
  // ============================================================

  Widget _buildLogicalEmptyLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogicalHeader(),

          const SizedBox(height: 70),

          Center(
            child: Text(
              'No confirmed bookings yet.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState({required bool isLogicalLayout}) {
    return SingleChildScrollView(
      padding: isLogicalLayout
          ? const EdgeInsets.fromLTRB(32, 28, 32, 32)
          : EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLogicalLayout) _buildLogicalHeader() else _buildMobileHeader(),

          SizedBox(height: isLogicalLayout ? 70 : 60.h),

          Center(
            child: Text(
              'Unable to load bookings.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIALS
  // ============================================================

  String _getInitials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  // ============================================================
  // SHIFT FORMAT
  // ============================================================

  String _formatShift(ShiftRequest booking) {
    final date = booking.shiftDate;

    return '${date.day}/${date.month}/${date.year} '
        '• ${booking.hours}';
  }
}

// ============================================================
// RESPONSIVE CARD LAYOUT
// ============================================================

enum _BookingCardLayout { mobileLandscape, tabletPortrait, tabletLandscape }
