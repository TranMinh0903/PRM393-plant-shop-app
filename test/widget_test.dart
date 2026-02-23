import 'package:flutter_test/flutter_test.dart';

import 'package:plant_shop_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify the home screen loads with expected content
    expect(find.text('Find your plant'), findsOneWidget);
  });
}
