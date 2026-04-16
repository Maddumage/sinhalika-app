import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_preferences.dart';
import 'providers.dart';

class UserPreferencesNotifier extends Notifier<UserPreferences> {
  static const _keyLanguage = 'user_language';
  static const _keyMode = 'user_mode';
  static const _keyLevel = 'user_level';

  @override
  UserPreferences build() {
    final prefs = ref.read(sharedPrefsProvider);

    final language = AppLanguage.values.firstWhere(
      (e) => e.name == prefs.getString(_keyLanguage),
      orElse: () => AppLanguage.si,
    );

    final mode = LearningMode.values.firstWhere(
      (e) => e.name == prefs.getString(_keyMode),
      orElse: () => LearningMode.learner,
    );

    final level = LearningLevel.values.firstWhere(
      (e) => e.name == prefs.getString(_keyLevel),
      orElse: () => LearningLevel.beginner,
    );

    // When a real (non-anonymous) user signs in, pull their preferences from
    // Firestore and merge them over the local defaults.
    ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
      final user = next.valueOrNull;
      if (user != null && !user.isAnonymous) {
        _syncFromFirestore(user.uid);
      }
    });

    return UserPreferences(language: language, mode: mode, level: level);
  }

  // ── Setters ──────────────────────────────────────────────────────────────────

  void setLanguage(AppLanguage language) {
    ref.read(sharedPrefsProvider).setString(_keyLanguage, language.name);
    state = state.copyWith(language: language);
    _pushToFirestore();
  }

  void setMode(LearningMode mode) {
    ref.read(sharedPrefsProvider).setString(_keyMode, mode.name);
    state = state.copyWith(mode: mode);
    _pushToFirestore();
  }

  void setLevel(LearningLevel level) {
    ref.read(sharedPrefsProvider).setString(_keyLevel, level.name);
    state = state.copyWith(level: level);
    _pushToFirestore();
  }

  // ── Firestore helpers ────────────────────────────────────────────────────────

  /// Fire-and-forget write of the current state to `users/{uid}`.
  /// Silently skips if the user is not signed in or is anonymous.
  void _pushToFirestore() {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || user.isAnonymous) return;
    ref.read(firestoreServiceProvider).saveUserPrefs(user.uid, state);
  }

  /// Reads `users/{uid}` from Firestore and merges values into local state.
  /// Persists the result to SharedPreferences so subsequent cold starts do
  /// not need a network round-trip.
  Future<void> _syncFromFirestore(String uid) async {
    final data = await ref.read(firestoreServiceProvider).fetchUserPrefs(uid);
    if (data == null) {
      // No doc yet — push the local defaults so the document is created.
      ref.read(firestoreServiceProvider).saveUserPrefs(uid, state);
      return;
    }

    final language = AppLanguage.values.firstWhere(
      (e) => e.name == data['language'],
      orElse: () => state.language,
    );
    final mode = LearningMode.values.firstWhere(
      (e) => e.name == data['mode'],
      orElse: () => state.mode,
    );
    final level = LearningLevel.values.firstWhere(
      (e) => e.name == data['level'],
      orElse: () => state.level,
    );

    final merged = UserPreferences(
      language: language,
      mode: mode,
      level: level,
    );

    // Persist locally to avoid a round-trip on next cold start.
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_keyLanguage, language.name);
    prefs.setString(_keyMode, mode.name);
    prefs.setString(_keyLevel, level.name);

    state = merged;
  }
}

final userPreferencesProvider =
    NotifierProvider<UserPreferencesNotifier, UserPreferences>(
      UserPreferencesNotifier.new,
    );

/// Convenience provider — exposes just the [AppLanguage] from
/// [userPreferencesProvider]. Used by [MaterialApp.router]'s locale and
/// the language switcher in SettingsScreen.
final languageProvider = Provider<AppLanguage>(
  (ref) => ref.watch(userPreferencesProvider).language,
);
