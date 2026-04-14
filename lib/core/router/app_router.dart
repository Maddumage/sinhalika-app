import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';
import '../../screens/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/lessons/lessons_screen.dart';
import '../../features/lessons/hodiya_screen.dart';
import '../../features/lessons/nouns_screen.dart';
import '../../features/lessons/phrases_screen.dart';
import '../../features/games/games_screen.dart';
import '../../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: notifier,
    redirect: (_, state) {
      final loc = state.uri.path;
      if (loc == '/loading') return null; // splash controls its own exit

      final signedIn = ref.read(authStateProvider).valueOrNull != null;
      final onboarded = ref.read(onboardingSeenProvider);

      final isAuthRoute = loc == '/sign-in' || loc == '/onboarding';
      final isAppRoute =
          loc.startsWith('/home') ||
          loc.startsWith('/lessons') ||
          loc.startsWith('/games') ||
          loc.startsWith('/settings');

      if (isAppRoute && !signedIn) {
        return onboarded ? '/sign-in' : '/onboarding';
      }
      if (isAuthRoute && signedIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/loading', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (_, __) => const LessonsScreen(),
                routes: [
                  GoRoute(
                    path: 'hodiya',
                    builder: (_, __) => const HodiyaScreen(),
                  ),
                  GoRoute(
                    path: 'nouns',
                    builder: (_, __) => const NounsScreen(),
                  ),
                  GoRoute(
                    path: 'phrases',
                    builder: (_, __) => const PhrasesScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/games', builder: (_, __) => const GamesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
