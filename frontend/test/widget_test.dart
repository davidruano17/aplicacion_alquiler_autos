import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App renders LoginScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
