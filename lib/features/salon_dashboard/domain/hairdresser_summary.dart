/// Summary of a hairdresser as shown in a salon's recommendation or
/// search results list.
class HairdresserSummary {
  const HairdresserSummary({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.ratePerDay,
    required this.availabilityLabel,
    required this.locationArea,
    required this.yearsExperience,
    this.photoUrl,
    this.badge,
    this.bio,
    this.trainingInfo,
    this.showUpPercentage,
    this.specialtyTags,
    this.readyDate,
  });

  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final double ratePerDay;

  /// e.g. "Available Tomorrow".
  final String availabilityLabel;

  /// e.g. "Mayfair".
  final String locationArea;

  final int yearsExperience;

  /// Null when no photo is available yet — the UI falls back to a
  /// placeholder color avatar with the hairdresser's initials.
  final String? photoUrl;

  /// e.g. "TOP RATED" or "VERIFIED". Null when no badge applies.
  final String? badge;

  /// Short mock biography shown on the profile screen.
  final String? bio;

  /// e.g. "Trained at Toni&Guy Paris".
  final String? trainingInfo;

  /// Mock show-up reliability, e.g. 100 for "100%".
  final int? showUpPercentage;

  /// e.g. ["Balayage Blend", "Full Highlights"].
  final List<String>? specialtyTags;

  /// Mock next-availability line, e.g. "Thursday, 23 May (Full Day)".
  final String? readyDate;
}
