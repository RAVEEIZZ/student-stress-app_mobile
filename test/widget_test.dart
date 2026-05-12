import 'package:flutter_test/flutter_test.dart';
import 'package:sudent_stress_app_mobile/app/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const StressApp());
    expect(find.byType(StressApp), findsOneWidget);
  });
}
