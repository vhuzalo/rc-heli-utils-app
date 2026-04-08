import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../blade_angle/presentation/blade_angle_screen.dart';
import '../../gear_ratio/presentation/gear_ratio_screen.dart';
import '../../profiles/presentation/profiles_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4F7FB),
              Color(0xFFDCE4EE),
              Color(0xFFC9D4E2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              const HomeScreen(),
              const BladeAngleScreen(),
              const GearRatioScreen(),
              const SettingsScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'delete-heli',
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: app.selectedProfile == null
                      ? null
                      : () => _confirmDeleteSelectedHeli(context),
                  child: const Icon(Icons.delete_outline),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  heroTag: 'add-heli',
                  backgroundColor: const Color(0xFFFF6A1A),
                  foregroundColor: Colors.white,
                  onPressed: () => showProfileEditor(context),
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: _currentIndex == 0
          ? FloatingActionButtonLocation.centerFloat
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.text('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.straighten_outlined),
            selectedIcon: const Icon(Icons.straighten),
            label: l10n.text('bladeAngle'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_input_component_outlined),
            selectedIcon: const Icon(Icons.settings_input_component),
            label: l10n.text('gearRatio'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.tune_outlined),
            selectedIcon: const Icon(Icons.tune),
            label: l10n.text('settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteSelectedHeli(BuildContext context) async {
    final app = AppScope.of(context);
    final selectedProfile = app.selectedProfile;
    if (selectedProfile == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = dialogContext.l10n;
        return AlertDialog(
          content: Text(l10n.text('deleteConfirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.text('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.text('deleteProfile')),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await app.deleteProfile(selectedProfile.id);
    }
  }
}
