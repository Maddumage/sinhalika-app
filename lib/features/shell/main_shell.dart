import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/generated/app_localizations.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _tabs = [
    (icon: Icons.home_rounded, path: '/home'),
    (icon: Icons.menu_book_rounded, path: '/lessons'),
    (icon: Icons.sports_esports_rounded, path: '/games'),
    (icon: Icons.settings_rounded, path: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.navHome,
      l10n.navLessons,
      l10n.navGames,
      l10n.navSettings,
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: List.generate(
          _tabs.length,
          (i) => NavigationDestination(
            icon: Icon(_tabs[i].icon),
            label: labels[i],
          ),
        ),
      ),
    );
  }
}
