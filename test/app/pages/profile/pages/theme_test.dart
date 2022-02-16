import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';
import 'package:talao/theme/theme.dart';

import '../../../../helper/pump_app.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late ThemeCubit themeCubit;

  setUp(() {
    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(ThemeMode.system);
  });

  group('ThemePage', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  ThemePage.route(themeCubit),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(ThemePage), findsOneWidget);
    });

    testWidgets('calls setLightTheme when setLightTheme is Tapped',
        (tester) async {
      when(() => themeCubit.setLightTheme()).thenAnswer((_) async {});
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  ThemePage.route(themeCubit),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('set_light_theme')));
      verify(() => themeCubit.setLightTheme()).called(1);
    });

    testWidgets('calls setDarkTheme when setDarkTheme is Tapped',
        (tester) async {
      when(() => themeCubit.setDarkTheme()).thenAnswer((_) async {});
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  ThemePage.route(themeCubit),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('set_dark_theme')));
      verify(() => themeCubit.setDarkTheme()).called(1);
    });

    testWidgets('calls setSystemTheme when setSystemTheme is Tapped',
        (tester) async {
      when(() => themeCubit.setSystemTheme()).thenAnswer((_) async {});
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  ThemePage.route(themeCubit),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('set_system_theme')));
      verify(() => themeCubit.setSystemTheme()).called(1);
    });
  });
}
