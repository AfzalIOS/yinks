import 'package:flutter_test/flutter_test.dart';

import 'package:yinks/main.dart';

void main() {
  testWidgets('App boots into the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('YINKS'), findsOneWidget);

    // SplashScreen schedules a 3-second timer to navigate away; let it
    // fire and the route transition settle so no timer is left pending
    // when the test ends.
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
