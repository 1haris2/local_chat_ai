import 'package:flutter_test/flutter_test.dart';
import 'package:local_chat_ai/main.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalChatAIApp());
    expect(find.text('Chat'), findsWidgets);
  });
}
