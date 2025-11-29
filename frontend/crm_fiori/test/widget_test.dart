import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crm_fiori/main.dart';

void main() {
  testWidgets('Carga inicial de la app', (WidgetTester tester) async {
    // Cargar la app
    await tester.pumpWidget(CRMFioriApp());

    // Verificar que aparezca Login
    expect(find.text('CRM Fiori'), findsOneWidget);
  });
}
