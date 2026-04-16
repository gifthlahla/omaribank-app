// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:omari_bank_app/app/app.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Initialize Supabase before running the test
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );

    await tester.pumpWidget(const ProviderScope(child: OmariBankApp()));
    expect(find.byType(OmariBankApp), findsOneWidget);
  });
}
