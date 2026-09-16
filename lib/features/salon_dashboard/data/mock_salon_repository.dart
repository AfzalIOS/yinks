import '../domain/hairdresser_summary.dart';
import '../domain/salon_repository.dart';

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
