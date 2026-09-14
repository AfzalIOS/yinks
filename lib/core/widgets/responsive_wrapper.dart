import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centers [child] and constrains its width so content doesn't stretch
/// awkwardly on tablets and other wide screens.
///
/// Every screen's main content should be wrapped in this widget.
class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500.w),
        child: child,
      ),
    );
  }
}
