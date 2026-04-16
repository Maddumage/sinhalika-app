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

    return UserPreferences(language: language, mode: mode, level: level);
  }

  void setLanguage(AppLanguage language) {
    ref.read(sharedPrefsProvider).setString(_keyLanguage, language.name);
    state = state.copyWith(language: language);
  }

  void setMode(LearningMode mode) {
    ref.read(sharedPrefsProvider).setString(_keyMode, mode.name);
    state = state.copyWith(mode: mode);
  }

  void setLevel(LearningLevel level) {
    ref.read(sharedPrefsProvider).setString(_keyLevel, level.name);
    state = state.copyWith(level: level);
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
