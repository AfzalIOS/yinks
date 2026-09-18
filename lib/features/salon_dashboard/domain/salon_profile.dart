/// The salon's own profile, as shown on the My Profile screen.
class SalonProfile {
  const SalonProfile({
    required this.salonName,
    required this.location,
    required this.phone,
    required this.email,
    required this.aboutText,
    required this.photoUrls,
    required this.openingHours,
  });

  final String salonName;
  final String location;
  final String phone;
  final String email;
  final String aboutText;

  /// Empty when no photos have been uploaded yet.
  final List<String> photoUrls;

  /// e.g. "Mon-Sat: 9AM - 7PM".
  final String openingHours;
}
