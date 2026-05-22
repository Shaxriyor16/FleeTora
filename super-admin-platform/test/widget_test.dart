import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleetora/app.dart';
import 'package:fleetora/providers/app_provider.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const FleetoraApp(),
      ),
    );
    expect(find.text('Fleetora'), findsWidgets);
  });
}

