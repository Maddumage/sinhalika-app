import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _tabs = [
    (label: 'Home', icon: Icons.home_rounded, path: '/home'),
    (label: 'Lessons', icon: Icons.menu_book_rounded, path: '/lessons'),
    (label: 'Games', icon: Icons.sports_esports_rounded, path: '/games'),
    (label: 'Settings', icon: Icons.settings_rounded, path: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(icon: Icon(t.icon), label: t.label),
            )
            .toList(),
      ),
    );
  }
}
