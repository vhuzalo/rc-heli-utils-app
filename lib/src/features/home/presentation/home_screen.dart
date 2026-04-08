import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../profiles/presentation/profiles_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        if (app.profiles.isEmpty)
          _EmptyProfilesCard(
            onCreateProfile: () => showProfileEditor(context),
          )
        else
          ...[
            for (var index = 0; index < app.profiles.length; index++) ...[
              _HomeProfileCard(profileIndex: index),
              if (index < app.profiles.length - 1) const SizedBox(height: 12),
            ],
          ],
      ],
    );
  }
}

class _EmptyProfilesCard extends StatelessWidget {
  const _EmptyProfilesCard({required this.onCreateProfile});

  final VoidCallback onCreateProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.dns_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.text('createFirstProfileTitle'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.text('createFirstProfileHint'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreateProfile,
              icon: const Icon(Icons.add),
              label: Text(l10n.text('createFirstProfile')),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeProfileCard extends StatelessWidget {
  const _HomeProfileCard({
    required this.profileIndex,
  });

  final int profileIndex;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final profile = app.profiles[profileIndex];
    final isSelected = profile.id == app.selectedProfileId;

    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.14)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => app.selectProfile(profile.id),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    if (profile.model.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        profile.model,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: context.l10n.text('editProfile'),
                onPressed: () => showProfileEditor(context, profile: profile),
                icon: Icon(
                  Icons.edit_outlined,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
