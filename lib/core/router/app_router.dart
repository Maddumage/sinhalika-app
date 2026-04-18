import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';
import '../../screens/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/auth/terms_and_conditions_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/lessons/lessons_screen.dart';
import '../../features/lessons/hodiya_screen.dart';
import '../../features/lessons/nouns_screen.dart';
import '../../features/lessons/phrases_screen.dart';
import '../../features/lessons/quiz_screen.dart';
import '../../features/lessons/traditional_items_screen.dart';
import '../../features/games/games_screen.dart';
import '../../features/games/match_words_screen.dart';
import '../../features/games/letter_drawing_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/celebrations/celebrations_screen.dart';
import '../../features/stories/janaktha_ekathuwa_screen.dart';
import '../../features/stories/story_details_screen.dart';
import '../../core/models/story_item.dart';

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
          loc.startsWith('/settings') ||
          loc.startsWith('/celebrations') ||
          loc.startsWith('/stories');

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
      GoRoute(
        path: '/terms',
        builder: (_, state) {
          final method = state.extra as AuthMethod;
          return TermsAndConditionsScreen(authMethod: method);
        },
      ),
      // ── Standalone full-screen routes (outside shell) ────────────────────
      GoRoute(
        path: '/celebrations',
        builder: (_, __) => const CelebrationsScreen(),
      ),
      GoRoute(
        path: '/stories',
        builder: (_, __) => const JanakthaEkathuwaScreen(),
        routes: [
          GoRoute(
            path: 'details',
            builder: (_, state) {
              final story = state.extra as StoryItem;
              return StoryDetailsScreen(story: story);
            },
          ),
        ],
      ),
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
                  GoRoute(path: 'quiz', builder: (_, __) => const QuizScreen()),
                  GoRoute(
                    path: 'traditional',
                    builder: (_, __) => const TraditionalItemsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/games',
                builder: (_, __) => const GamesScreen(),
                routes: [
                  GoRoute(
                    path: 'match-words',
                    builder: (_, __) => const MatchWordsScreen(),
                  ),
                  GoRoute(
                    path: 'letter-drawing',
                    builder: (_, __) => const LetterDrawingScreen(),
                  ),
                ],
              ),
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
