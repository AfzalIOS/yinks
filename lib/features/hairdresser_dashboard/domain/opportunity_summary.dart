/// Summary of a shift opportunity as shown to a hairdresser browsing
/// or recommended work.
class OpportunitySummary {
  const OpportunitySummary({
    required this.salonName,
    required this.salonLocation,
    required this.role,
    required this.date,
    required this.hours,
    required this.payAmount,
    required this.distanceMiles,
    this.photoUrl,
  });

  final String salonName;

  /// e.g. "Mayfair".
  final String salonLocation;

  /// e.g. "Colourist Needed".
  final String role;

  /// e.g. "Saturday".
  final String date;

  /// e.g. "10AM - 6PM".
  final String hours;

  final double payAmount;
  final double distanceMiles;

  /// Null when no photo is available yet — the UI falls back to a
  /// placeholder color avatar with the salon's initials.
  final String? photoUrl;
}
