import 'package:flutter_test/flutter_test.dart';
import 'package:ai_pet_companion_pro/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const AIPetCompanionProApp());
    expect(find.text('AI Pet Companion Pro'), findsOneWidget);
  });
}
