import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/app_shell.dart';
import 'app_controller.dart';
import 'app_scope.dart';

class RcHeliUtilsApp extends StatelessWidget {
  const RcHeliUtilsApp({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => context.l10n.text('appTitle'),
            locale: controller.language.locale,
            supportedLocales:
                AppLanguage.values.map((language) => language.locale).toList(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: buildAppTheme(),
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
