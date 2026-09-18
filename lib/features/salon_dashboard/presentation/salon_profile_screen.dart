import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/sign_in_screen.dart';
import '../data/mock_salon_repository.dart';
import '../domain/salon_profile.dart';
import '../domain/salon_repository.dart';

/// My Profile: the salon's own profile.
///
/// Responsive behavior:
/// - Mobile portrait: original stacked mobile layout
/// - Mobile landscape: compact horizontal layout
/// - Tablet portrait/landscape: responsive tablet layout
///
/// This is an inner/detail screen, so no drawer/sidebar is shown here.
class SalonProfileScreen extends StatefulWidget {
  const SalonProfileScreen({super.key});

  @override
  State<SalonProfileScreen> createState() => _SalonProfileScreenState();
}

class _SalonProfileScreenState extends State<SalonProfileScreen> {
  final SalonRepository _repository = MockSalonRepository();

  late final Future<SalonProfile> _future = _repository.getMyProfile();

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
  // SIGN OUT
  // ============================================================

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (route) => false,
    );
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
        child: FutureBuilder<SalonProfile>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _buildLoadingLayout(logical: isTablet || isPhoneLandscape);
            }

            final profile = snapshot.data!;

            if (isTablet) {
              return _buildTabletLayout(profile);
            }

            if (isPhoneLandscape) {
              return _buildPhoneLandscapeLayout(profile);
            }

            return _buildMobilePortraitLayout(profile);
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT
  // ============================================================

  Widget _buildMobilePortraitLayout(SalonProfile profile) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileHeader(),

          SizedBox(height: 16.h),

          Center(
            child: Column(
              children: [
                _buildMobileAvatar(profile),

                SizedBox(height: 16.h),

                Text(
                  profile.salonName,
                  style: AppTextStyles.headlineSm,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                Text(
                  profile.location,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.titleSm.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 28.h),

          Text('Contact', style: AppTextStyles.titleMd),

          SizedBox(height: 12.h),

          _buildMobileInfoRow(Icons.call_outlined, profile.phone),

          SizedBox(height: 8.h),

          _buildMobileInfoRow(Icons.email_outlined, profile.email),

          SizedBox(height: 28.h),

          Text('About', style: AppTextStyles.titleMd),

          SizedBox(height: 8.h),

          Text(
            profile.aboutText,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 28.h),

          Text('Opening Hours', style: AppTextStyles.titleMd),

          SizedBox(height: 8.h),

          _buildMobileInfoRow(Icons.schedule_outlined, profile.openingHours),

          SizedBox(height: 28.h),

          Text('Photos', style: AppTextStyles.titleMd),

          SizedBox(height: 12.h),

          _buildMobilePhotosRow(profile),

          SizedBox(height: 28.h),

          _buildMobileSignOutTile(),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE
  // ============================================================

  Widget _buildPhoneLandscapeLayout(SalonProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogicalHeader(),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // LEFT - PROFILE
              // ==================================================
              Expanded(flex: 30, child: _buildLandscapeProfileColumn(profile)),

              const SizedBox(width: 20),

              Container(width: 1, height: 215, color: AppColors.border),

              const SizedBox(width: 20),

              // ==================================================
              // CENTER - DETAILS
              // ==================================================
              Expanded(flex: 50, child: _buildLandscapeDetailsColumn(profile)),

              const SizedBox(width: 20),

              Container(width: 1, height: 215, color: AppColors.border),

              const SizedBox(width: 20),

              // ==================================================
              // RIGHT - PHOTOS / SIGN OUT
              // ==================================================
              Expanded(flex: 32, child: _buildLandscapeActionsColumn(profile)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeProfileColumn(SalonProfile profile) {
    return Column(
      children: [
        _buildLogicalAvatar(profile, radius: 42),

        const SizedBox(height: 10),

        Text(
          profile.salonName,
          style: AppTextStyles.titleMd,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        Text(
          profile.location,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 36,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Text(
              'Edit Profile',
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeDetailsColumn(SalonProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact', style: AppTextStyles.titleSm),

        const SizedBox(height: 7),

        _buildLogicalInfoRow(Icons.call_outlined, profile.phone, compact: true),

        const SizedBox(height: 6),

        _buildLogicalInfoRow(
          Icons.email_outlined,
          profile.email,
          compact: true,
        ),

        const SizedBox(height: 13),

        Text('About', style: AppTextStyles.titleSm),

        const SizedBox(height: 5),

        Text(
          profile.aboutText,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 13),

        Text('Opening Hours', style: AppTextStyles.titleSm),

        const SizedBox(height: 5),

        _buildLogicalInfoRow(
          Icons.schedule_outlined,
          profile.openingHours,
          compact: true,
        ),
      ],
    );
  }

  Widget _buildLandscapeActionsColumn(SalonProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos', style: AppTextStyles.titleSm),

        const SizedBox(height: 10),

        _buildLogicalPhotosRow(profile, boxSize: 54, gap: 7),

        const SizedBox(height: 20),

        _buildLogicalSignOutTile(compact: true),
      ],
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _buildTabletLayout(SalonProfile profile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double maxContentWidth = 1100;

        final double width = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 36),
          child: Center(
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogicalHeader(),

                  const SizedBox(height: 28),

                  // ==================================================
                  // PROFILE HERO
                  // ==================================================
                  Center(
                    child: Column(
                      children: [
                        _buildLogicalAvatar(profile, radius: 56),

                        const SizedBox(height: 14),

                        Text(
                          profile.salonName,
                          style: AppTextStyles.headlineSm,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 5),

                        Text(
                          profile.location,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: AppTextStyles.titleSm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // CONTACT + OPENING HOURS
                  // ==================================================
                  // IntrinsicHeight (not a bare Row) — this Row sits
                  // inside a Column inside a SingleChildScrollView,
                  // which gives it unbounded height. crossAxisAlignment
                  // .stretch then tries to make both cards exactly
                  // infinity tall, which crashes with "BoxConstraints
                  // forces an infinite height". IntrinsicHeight
                  // measures each card's real height first and gives
                  // the Row that concrete value, so stretch still
                  // makes the two cards match height without ever
                  // handing anything an unbounded constraint.
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildTabletSectionCard(
                            title: 'Contact',
                            child: Column(
                              children: [
                                _buildLogicalInfoRow(
                                  Icons.call_outlined,
                                  profile.phone,
                                ),

                                const SizedBox(height: 12),

                                _buildLogicalInfoRow(
                                  Icons.email_outlined,
                                  profile.email,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: _buildTabletSectionCard(
                            title: 'Opening Hours',
                            child: _buildLogicalInfoRow(
                              Icons.schedule_outlined,
                              profile.openingHours,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // ABOUT
                  // ==================================================
                  _buildTabletSectionCard(
                    title: 'About',
                    child: Text(
                      profile.aboutText,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // PHOTOS
                  // ==================================================
                  Text('Photos', style: AppTextStyles.titleMd),

                  const SizedBox(height: 12),

                  _buildLogicalPhotosRow(profile, boxSize: 100, gap: 12),

                  const SizedBox(height: 24),

                  _buildLogicalSignOutTile(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSm),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE HEADER
  // ============================================================

  Widget _buildMobileHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        SizedBox(width: 8.w),

        Text('My Profile', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // LOGICAL HEADER
  // ============================================================

  Widget _buildLogicalHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),

        const SizedBox(width: 8),

        Text('My Profile', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // MOBILE INFO ROW
  // ============================================================

  Widget _buildMobileInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGICAL INFO ROW
  // ============================================================

  Widget _buildLogicalInfoRow(
    IconData icon,
    String text, {
    bool compact = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: compact ? 18 : 22, color: AppColors.primary),

        SizedBox(width: compact ? 8 : 12),

        Expanded(
          child: Text(
            text,
            style: compact
                ? AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary)
                : AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE PHOTOS
  // ============================================================

  Widget _buildMobilePhotosRow(SalonProfile profile) {
    final int placeholderCount = profile.photoUrls.isEmpty
        ? 3
        : profile.photoUrls.length;

    return SizedBox(
      height: 90.r,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: placeholderCount,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final String? photoUrl = index < profile.photoUrls.length
              ? profile.photoUrls[index]
              : null;

          return _buildMobilePhotoBox(photoUrl);
        },
      ),
    );
  }

  Widget _buildMobilePhotoBox(String? photoUrl) {
    return Container(
      width: 90.r,
      height: 90.r,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        image: photoUrl == null
            ? null
            : DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover),
      ),
      child: photoUrl == null
          ? Icon(
              Icons.image_outlined,
              color: AppColors.textSecondary,
              size: 24.sp,
            )
          : null,
    );
  }

  // ============================================================
  // LOGICAL PHOTOS
  // ============================================================

  Widget _buildLogicalPhotosRow(
    SalonProfile profile, {
    required double boxSize,
    required double gap,
  }) {
    final int count = profile.photoUrls.isEmpty ? 3 : profile.photoUrls.length;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: List.generate(count, (index) {
        final String? photoUrl = index < profile.photoUrls.length
            ? profile.photoUrls[index]
            : null;

        return _buildLogicalPhotoBox(photoUrl, size: boxSize);
      }),
    );
  }

  Widget _buildLogicalPhotoBox(String? photoUrl, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        image: photoUrl == null
            ? null
            : DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover),
      ),
      child: photoUrl == null
          ? Icon(
              Icons.image_outlined,
              color: AppColors.textSecondary,
              size: size * 0.28,
            )
          : null,
    );
  }

  // ============================================================
  // MOBILE SIGN OUT
  // ============================================================

  Widget _buildMobileSignOutTile() {
    return GestureDetector(
      onTap: _signOut,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.logout, size: 20.sp, color: AppColors.textSecondary),

            SizedBox(width: 12.w),

            Text(
              'Sign Out',
              style: AppTextStyles.titleSm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGICAL SIGN OUT
  // ============================================================

  Widget _buildLogicalSignOutTile({bool compact = false}) {
    return GestureDetector(
      onTap: _signOut,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 18,
          vertical: compact ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              size: compact ? 19 : 22,
              color: AppColors.textSecondary,
            ),

            SizedBox(width: compact ? 9 : 12),

            Text(
              'Sign Out',
              style: compact
                  ? AppTextStyles.labelLg.copyWith(
                      color: AppColors.textSecondary,
                    )
                  : AppTextStyles.titleSm.copyWith(
                      color: AppColors.textSecondary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE AVATAR
  // ============================================================

  Widget _buildMobileAvatar(SalonProfile profile) {
    return CircleAvatar(
      radius: 48.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(profile.salonName),
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // LOGICAL AVATAR
  // ============================================================

  Widget _buildLogicalAvatar(SalonProfile profile, {required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(profile.salonName),
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // INITIALS
  // ============================================================

  String _getInitials(String salonName) {
    return salonName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoadingLayout({required bool logical}) {
    return Column(
      children: [
        Padding(
          padding: logical
              ? const EdgeInsets.fromLTRB(32, 28, 32, 0)
              : EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          child: logical ? _buildLogicalHeader() : _buildMobileHeader(),
        ),

        Expanded(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
