import '../domain/hairdresser_repository.dart';
import '../domain/opportunity_summary.dart';

/// Hardcoded [HairdresserRepository] used until a real backend is
/// wired up. Simulates network latency with [Future.delayed].
class MockHairdresserRepository implements HairdresserRepository {
  static const _simulatedDelay = Duration(milliseconds: 600);

  static const _recommendedOpportunities = [
    OpportunitySummary(
      salonName: 'Maison Mayfair',
      salonLocation: 'Mayfair',
      role: 'Colourist Needed',
      date: 'Saturday',
      hours: '10AM - 6PM',
      payAmount: 180,
      distanceMiles: 2.3,
    ),
    OpportunitySummary(
      salonName: 'Soho Studio',
      salonLocation: 'Soho',
      role: 'Precision Cutter Needed',
      date: 'Sunday',
      hours: '9AM - 5PM',
      payAmount: 160,
      distanceMiles: 3.8,
    ),
    OpportunitySummary(
      salonName: 'Chelsea Bridal House',
      salonLocation: 'Chelsea',
      role: 'Bridal Stylist Needed',
      date: 'Friday',
      hours: '7AM - 3PM',
      payAmount: 240,
      distanceMiles: 5.1,
    ),
    OpportunitySummary(
      salonName: 'The Balayage Bar',
      salonLocation: 'Notting Hill',
      role: 'Balayage Specialist Needed',
      date: 'Monday',
      hours: '11AM - 7PM',
      payAmount: 200,
      distanceMiles: 4.4,
    ),
    OpportunitySummary(
      salonName: 'Kensington Cutting Co.',
      salonLocation: 'Kensington',
      role: 'Senior Barber Needed',
      date: 'Tuesday',
      hours: '9AM - 4PM',
      payAmount: 175,
      distanceMiles: 1.6,
    ),
  ];

  static const _allOpportunities = [
    ..._recommendedOpportunities,
    OpportunitySummary(
      salonName: 'Hackney Braid House',
      salonLocation: 'Hackney',
      role: 'Braider Needed',
      date: 'Wednesday',
      hours: '10AM - 5PM',
      payAmount: 150,
      distanceMiles: 6.7,
    ),
    OpportunitySummary(
      salonName: 'Shoreditch Barber Co.',
      salonLocation: 'Shoreditch',
      role: 'Barber Needed',
      date: 'Thursday',
      hours: '8AM - 4PM',
      payAmount: 165,
      distanceMiles: 3.2,
    ),
  ];

  @override
  Future<List<OpportunitySummary>> getRecommendedOpportunities() async {
    await Future.delayed(_simulatedDelay);
    return _recommendedOpportunities;
  }

  @override
  Future<List<OpportunitySummary>> getAllOpportunities() async {
    await Future.delayed(_simulatedDelay);
    return _allOpportunities;
  }

  @override
  Future<int> getNewOpportunitiesCount() async {
    await Future.delayed(_simulatedDelay);
    return 7;
  }

  @override
  Future<int> getActiveApplicationsCount() async {
    await Future.delayed(_simulatedDelay);
    return 2;
  }
}
