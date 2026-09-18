import '../domain/hairdresser_summary.dart';
import '../domain/salon_profile.dart';
import '../domain/salon_repository.dart';
import '../domain/shift_request.dart';

/// Hardcoded [SalonRepository] used until a real backend is wired up.
/// Simulates network latency with [Future.delayed].
class MockSalonRepository implements SalonRepository {
  static const _simulatedDelay = Duration(milliseconds: 600);

  static const _recommendedHairdressers = [
    HairdresserSummary(
      name: 'Amara Whitfield',
      specialty: 'Balayage & Color Master',
      rating: 4.9,
      reviewCount: 128,
      ratePerDay: 220,
      availabilityLabel: 'Available Tomorrow',
      locationArea: 'Mayfair',
      yearsExperience: 9,
      badge: 'TOP RATED',
      bio:
          'Amara has spent 9 years perfecting hand-painted color '
          'techniques for London\'s top salons. She specializes in '
          'low-maintenance, dimensional balayage and takes a '
          'consultation-first approach with every client.',
      trainingInfo: 'Trained at Toni&Guy Paris',
      showUpPercentage: 100,
      specialtyTags: [
        'Balayage Blend',
        'Full Highlights',
        'Gloss & Tone',
        'Color Correction',
      ],
      readyDate: 'Thursday, 23 May (Full Day)',
    ),
    HairdresserSummary(
      name: 'Jonas Reeve',
      specialty: 'Precision Cuts & Fades',
      rating: 4.8,
      reviewCount: 96,
      ratePerDay: 180,
      availabilityLabel: 'Available Today',
      locationArea: 'Soho',
      yearsExperience: 6,
      bio:
          'Jonas is a precision cutting specialist with 6 years of '
          'experience across barbering and modern fade work. Clients '
          'return for his sharp technical finish and relaxed, '
          'friendly manner in the chair.',
      trainingInfo: 'Trained at Vidal Sassoon Academy',
      showUpPercentage: 98,
      specialtyTags: ['Skin Fades', 'Textured Crops', 'Beard Sculpting'],
      readyDate: 'Friday, 24 May (Morning)',
    ),
    HairdresserSummary(
      name: 'Priya Chandran',
      specialty: 'Bridal & Editorial Styling',
      rating: 5.0,
      reviewCount: 74,
      ratePerDay: 260,
      availabilityLabel: 'Available Friday',
      locationArea: 'Chelsea',
      yearsExperience: 11,
      badge: 'TOP RATED',
      bio:
          'Priya has 11 years of experience styling for bridal parties, '
          'fashion shoots, and editorial campaigns. She is known for '
          'flawless up-styling and calm, reassuring energy on high '
          'pressure event days.',
      trainingInfo: 'Trained at London College of Fashion',
      showUpPercentage: 100,
      specialtyTags: ['Bridal Updos', 'Editorial Styling', 'Hair Extensions'],
      readyDate: 'Saturday, 25 May (Full Day)',
    ),
    HairdresserSummary(
      name: 'Lucas Bennet',
      specialty: 'Keratin & Texture Specialist',
      rating: 4.7,
      reviewCount: 61,
      ratePerDay: 195,
      availabilityLabel: 'Available Tomorrow',
      locationArea: 'Mayfair',
      yearsExperience: 5,
      bio:
          'Lucas focuses on smoothing and texture treatments, with 5 '
          'years spent helping clients manage curl patterns and repair '
          'damaged hair. He tailors every treatment plan to the '
          'client\'s hair type and goals.',
      trainingInfo: 'Trained at L\'Oréal Professionnel Academy',
      showUpPercentage: 96,
      specialtyTags: ['Keratin Smoothing', 'Curl Treatments', 'Deep Repair'],
      readyDate: 'Thursday, 23 May (Afternoon)',
    ),
  ];

  static const _allHairdressers = [
    ..._recommendedHairdressers,
    HairdresserSummary(
      name: 'Freya Sinclair',
      specialty: 'Colorists',
      rating: 4.6,
      reviewCount: 52,
      ratePerDay: 175,
      availabilityLabel: 'Available Monday',
      locationArea: 'Soho',
      yearsExperience: 4,
      badge: 'VERIFIED',
      bio:
          'Freya is a colorist with 4 years of salon experience, '
          'specializing in vivid and pastel color transformations as '
          'well as natural-looking root touch-ups for everyday clients.',
      trainingInfo: 'Trained at Wella Studio London',
      showUpPercentage: 97,
      specialtyTags: ['Vivid Color', 'Root Touch-Ups', 'Pastel Tones'],
      readyDate: 'Monday, 27 May (Full Day)',
    ),
    HairdresserSummary(
      name: 'Marcus Odell',
      specialty: 'Precision Cuts',
      rating: 4.9,
      reviewCount: 143,
      ratePerDay: 210,
      availabilityLabel: 'Available Today',
      locationArea: 'Chelsea',
      yearsExperience: 8,
      badge: 'VERIFIED',
      bio:
          'Marcus has 8 years of experience in precision cutting for a '
          'loyal clientele across Chelsea and the West End. He is '
          'known for consistent, camera-ready finishes on every visit.',
      trainingInfo: 'Trained at Sassoon Academy London',
      showUpPercentage: 99,
      specialtyTags: ['Classic Cuts', 'Blow-Dry Styling', 'Men\'s Grooming'],
      readyDate: 'Wednesday, 22 May (Morning)',
    ),
  ];

  @override
  Future<List<HairdresserSummary>> getRecommendedHairdressers() async {
    await Future.delayed(_simulatedDelay);
    return _recommendedHairdressers;
  }

  @override
  Future<List<HairdresserSummary>> getAllHairdressers() async {
    await Future.delayed(_simulatedDelay);
    return _allHairdressers;
  }

  static final _myRequests = [
    ShiftRequest(
      id: 'YNK-4821',
      hairdresserName: 'Amara Whitfield',
      shiftDate: DateTime(2026, 5, 23),
      hours: '09:30 - 18:00',
      station: 'Chair 01 (Senior Cutting Station)',
      amount: 220,
      status: ShiftRequestStatus.pending,
    ),
    ShiftRequest(
      id: 'YNK-4802',
      hairdresserName: 'Freya Sinclair',
      shiftDate: DateTime(2026, 5, 27),
      hours: '10:00 - 17:00',
      station: 'Chair 03 (Color Bar & Balayage Station)',
      amount: 175,
      status: ShiftRequestStatus.pending,
    ),
    ShiftRequest(
      id: 'YNK-4756',
      hairdresserName: 'Jonas Reeve',
      shiftDate: DateTime(2026, 5, 24),
      hours: '09:00 - 17:30',
      station: 'Chair 01 (Senior Cutting Station)',
      amount: 180,
      status: ShiftRequestStatus.accepted,
    ),
    ShiftRequest(
      id: 'YNK-4711',
      hairdresserName: 'Priya Chandran',
      shiftDate: DateTime(2026, 5, 25),
      hours: '08:00 - 20:00',
      station: 'VIP Private Suite',
      amount: 260,
      status: ShiftRequestStatus.accepted,
    ),
    ShiftRequest(
      id: 'YNK-4680',
      hairdresserName: 'Marcus Odell',
      shiftDate: DateTime(2026, 5, 22),
      hours: '09:00 - 15:00',
      station: 'Chair 01 (Senior Cutting Station)',
      amount: 210,
      status: ShiftRequestStatus.declined,
    ),
  ];

  @override
  Future<List<ShiftRequest>> getMyRequests() async {
    await Future.delayed(_simulatedDelay);
    return _myRequests;
  }

  // Dated relative to DateTime.now() (rather than the fixed dates used
  // by _myRequests) so "Today & Tomorrow" vs "Upcoming" grouping on the
  // Bookings screen demonstrates correctly whenever the app is run.
  static final _confirmedBookings = [
    ShiftRequest(
      id: 'YNK-4756',
      hairdresserName: 'Jonas Reeve',
      shiftDate: DateTime.now(),
      hours: '09:00 - 17:30',
      station: 'Chair 01 (Senior Cutting Station)',
      amount: 180,
      status: ShiftRequestStatus.accepted,
    ),
    ShiftRequest(
      id: 'YNK-4711',
      hairdresserName: 'Priya Chandran',
      shiftDate: DateTime.now().add(const Duration(days: 1)),
      hours: '08:00 - 20:00',
      station: 'VIP Private Suite',
      amount: 260,
      status: ShiftRequestStatus.accepted,
    ),
    ShiftRequest(
      id: 'YNK-4790',
      hairdresserName: 'Marcus Odell',
      shiftDate: DateTime.now().add(const Duration(days: 9)),
      hours: '09:00 - 15:00',
      station: 'Chair 01 (Senior Cutting Station)',
      amount: 210,
      status: ShiftRequestStatus.accepted,
    ),
  ];

  @override
  Future<List<ShiftRequest>> getConfirmedBookings() async {
    await Future.delayed(_simulatedDelay);
    return _confirmedBookings;
  }

  static const _myProfile = SalonProfile(
    salonName: 'Maison Mayfair',
    location: 'Mayfair Atelier, Mayfair, London',
    phone: '+44 20 7946 0958',
    email: 'hello@maisonmayfair.co.uk',
    aboutText:
        'Maison Mayfair is a boutique salon in the heart of Mayfair, '
        'known for pairing London\'s top freelance stylists with a '
        'refined, client-first atelier experience since 2016.',
    photoUrls: [],
    openingHours: 'Mon-Sat: 9AM - 7PM',
  );

  @override
  Future<SalonProfile> getMyProfile() async {
    await Future.delayed(_simulatedDelay);
    return _myProfile;
  }

  @override
  Future<int> getActiveInvitesCount() async {
    await Future.delayed(_simulatedDelay);
    return 3;
  }

  @override
  Future<int> getUpcomingShiftsCount() async {
    await Future.delayed(_simulatedDelay);
    return 5;
  }
}
