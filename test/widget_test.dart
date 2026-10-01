// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mycampus/main.dart';

void main() {
  testWidgets('MyCampus app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCampusApp());
    expect(find.byType(MyCampusApp), findsOneWidget);
  });
}
