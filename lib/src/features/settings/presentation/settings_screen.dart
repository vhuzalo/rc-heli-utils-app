import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/unit_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.text('language'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<AppLanguage>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: AppLanguage.ptBr,
                      label: Text('PT-BR'),
                    ),
                    ButtonSegment(
                      value: AppLanguage.en,
                      label: Text('EN'),
                    ),
                  ],
                  selected: {app.language},
                  onSelectionChanged: (selection) {
                    app.setLanguage(selection.first);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.text('units'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<UnitSystem>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: UnitSystem.metric,
                      label: Text(l10n.text('metric')),
                    ),
                    ButtonSegment(
                      value: UnitSystem.imperial,
                      label: Text(l10n.text('imperial')),
                    ),
                  ],
                  selected: {app.unitSystem},
                  onSelectionChanged: (selection) {
                    app.setUnitSystem(selection.first);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
