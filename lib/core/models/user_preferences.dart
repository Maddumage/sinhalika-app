/// App language preference. Maps directly to supported ARB locales.
enum AppLanguage { en, si }

/// Learning mode: 'native' treats Sinhala as a first language companion;
/// 'learner' treats it as a second language being studied.
enum LearningMode { native, learner }

/// Self-reported proficiency level.
enum LearningLevel { beginner, intermediate, advanced }

/// Immutable value object holding the user's app-wide context preferences.
class UserPreferences {
  const UserPreferences({
    this.language = AppLanguage.en,
    this.mode = LearningMode.learner,
    this.level = LearningLevel.beginner,
  });

  final AppLanguage language;
  final LearningMode mode;
  final LearningLevel level;

  UserPreferences copyWith({
    AppLanguage? language,
    LearningMode? mode,
    LearningLevel? level,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      mode: mode ?? this.mode,
      level: level ?? this.level,
    );
  }
}
