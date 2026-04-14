import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../services/tts_service.dart';

// ── TTS ───────────────────────────────────────────────────────────────────────
final ttsServiceProvider = Provider<TtsService>((_) => TtsService.instance);

// ── SharedPreferences (overridden in main) ───────────────────────────────────
final sharedPrefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('SharedPreferences must be overridden.'),
);

// ── Auth ─────────────────────────────────────────────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  try {
    return AuthService.instance.authStateChanges;
  } catch (_) {
    return Stream.value(null);
  }
});

// ── Onboarding seen ───────────────────────────────────────────────────────────
final onboardingSeenProvider = Provider<bool>(
  (ref) => ref.read(sharedPrefsProvider).getBool('onboarding_seen') ?? false,
);

// ── Theme mode ────────────────────────────────────────────────────────────────
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final saved = ref.read(sharedPrefsProvider).getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  void set(ThemeMode mode) {
    ref.read(sharedPrefsProvider).setString(_key, mode.name);
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

// ── Notifications enabled ─────────────────────────────────────────────────────
class NotifNotifier extends Notifier<bool> {
  static const _key = 'notifications_enabled';

  @override
  bool build() => ref.read(sharedPrefsProvider).getBool(_key) ?? true;

  void toggle(bool value) {
    ref.read(sharedPrefsProvider).setBool(_key, value);
    state = value;
  }
}

final notificationsEnabledProvider = NotifierProvider<NotifNotifier, bool>(
  NotifNotifier.new,
);
