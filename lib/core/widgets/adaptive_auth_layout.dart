import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Responsive shell for auth screens.
///
/// MOBILE:
/// - Portrait  -> Form only
/// - Landscape -> Form only
///
/// TABLET:
/// - Portrait  -> Image + Form
/// - Landscape -> Image + Form
///
/// Tablet detection uses shortestSide so a mobile in landscape
/// is never incorrectly treated as a tablet.
class AdaptiveAuthLayout extends StatelessWidget {
  const AdaptiveAuthLayout({
    super.key,
    required this.formContent,
    this.imagePath = 'assets/images/modelimage.png',
    this.tagline,
    this.marketingText,
    this.breakpoint = 600,
    this.narrowTabletMaxWidth = 900,
    this.formMaxWidth = 440,
  });

  /// Existing form UI.
  final Widget formContent;

  /// Background image for tablet layout.
  final String imagePath;

  /// Short headline under YINKS.
  final String? tagline;

  /// Optional supporting marketing text.
  final String? marketingText;

  /// Minimum shortest-side size considered a tablet.
  final double breakpoint;

  /// Used to adjust tablet portrait/landscape proportions.
  final double narrowTabletMaxWidth;

  /// Maximum width of form inside tablet panel.
  final double formMaxWidth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // IMPORTANT:
    // shortestSide detects the actual device class better
    // than checking width alone.
    //
    // Mobile portrait:
    // 390 x 844 -> shortestSide 390 -> MOBILE
    //
    // Mobile landscape:
    // 844 x 390 -> shortestSide 390 -> MOBILE
    //
    // Tablet portrait:
    // 820 x 1180 -> shortestSide 820 -> TABLET
    //
    // Tablet landscape:
    // 1180 x 820 -> shortestSide 820 -> TABLET
    final bool isTablet = size.shortestSide >= breakpoint;

    // ----------------------------------------------------------
    // MOBILE
    // Both portrait and landscape = FORM ONLY
    // ----------------------------------------------------------

    if (!isTablet) {
      return formContent;
    }

    // ----------------------------------------------------------
    // TABLET
    // Both portrait and landscape = IMAGE + FORM
    // ----------------------------------------------------------

    final bool isNarrowTablet = size.width < narrowTabletMaxWidth;

    // Portrait tablet gets slightly smaller image area.
    // Landscape tablet gets 45/55.
    final int leftFlex = isNarrowTablet ? 38 : 45;
    final int rightFlex = 100 - leftFlex;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: leftFlex, child: _buildBrandPanel()),
        Expanded(flex: rightFlex, child: _buildFormPanel()),
      ],
    );
  }

  // ============================================================
  // IMAGE / BRAND PANEL
  // ============================================================

  Widget _buildBrandPanel() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),

        // Gradient overlay
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.textPrimary.withValues(alpha: 0.15),
                AppColors.textPrimary.withValues(alpha: 0.75),
              ],
            ),
          ),
        ),

        // Branding
        Padding(
          padding: const EdgeInsets.all(40),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // YINKS
                Text(
                  'YINKS',
                  style: AppTextStyles.headlineLg.copyWith(
                    color: AppColors.background,
                    letterSpacing: 2,
                  ),
                ),

                // Bottom content
                if (tagline != null || marketingText != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tagline != null)
                        Text(
                          tagline!,
                          style: AppTextStyles.headlineSm.copyWith(
                            color: AppColors.background,
                          ),
                        ),

                      if (marketingText != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          marketingText!,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.background.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORM PANEL
  // ============================================================

  Widget _buildFormPanel() {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: formMaxWidth),
            child: formContent,
          ),
        ),
      ),
    );
  }
}
