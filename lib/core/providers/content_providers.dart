import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adapters/content_adapter.dart';
import '../models/hodiya_item.dart';
import '../models/noun_item.dart';
import '../models/phrase_item.dart';
import '../models/user_preferences.dart';
import '../models/word_document.dart';
import '../../features/lessons/data/hodiya_data.dart';
import '../../features/lessons/data/nouns_data.dart';
import '../../features/lessons/data/phrases_data.dart';
import 'providers.dart';
import 'user_preferences_provider.dart';

// ── Pre-computed display lists ────────────────────────────────────────────────
//
// Each provider is keyed on the (mode, level) record. Dart 3 records use
// structural equality, so Riverpod's `select` will only re-derive the list
// when mode or level actually changes — language or theme switches do NOT
// cause lesson content to rebuild.

/// Pre-computed [HodiyaDisplay] list. Only re-derives when [LearningMode] or
/// [LearningLevel] changes.
final hodiyaDisplayListProvider = Provider<List<HodiyaDisplay>>((ref) {
  final (mode, level) = ref.watch(
    userPreferencesProvider.select((p) => (p.mode, p.level)),
  );
  final prefs = UserPreferences(mode: mode, level: level);
  return List.unmodifiable(
    hodiyaItems.map((item) => ContentAdapter.forHodiya(item, prefs)),
  );
});

/// Pre-computed [NounDisplay] list. Only re-derives when [LearningMode] or
/// [LearningLevel] changes.
final nounDisplayListProvider = Provider<List<NounDisplay>>((ref) {
  final (mode, level) = ref.watch(
    userPreferencesProvider.select((p) => (p.mode, p.level)),
  );
  final prefs = UserPreferences(mode: mode, level: level);
  return List.unmodifiable(
    nounItems.map((item) => ContentAdapter.forNoun(item, prefs)),
  );
});

/// Pre-computed [PhraseDisplay] list. Only re-derives when [LearningMode] or
/// [LearningLevel] changes.
final phraseDisplayListProvider = Provider<List<PhraseDisplay>>((ref) {
  final (mode, level) = ref.watch(
    userPreferencesProvider.select((p) => (p.mode, p.level)),
  );
  final prefs = UserPreferences(mode: mode, level: level);
  return List.unmodifiable(
    phraseItems.map((item) => ContentAdapter.forPhrase(item, prefs)),
  );
});

// ── Words cache ────────────────────────────────────────────────────────────────
//
// Serves the locally-cached word list immediately on cold start (no network
// required). The live Firestore stream keeps the cache warm in the background.
// On the next cold start the cached data is available instantly.

class WordsCacheNotifier extends AsyncNotifier<List<WordDocument>> {
  static const _cacheKey = 'words_json_cache';

  @override
  Future<List<WordDocument>> build() async {
    final prefs = ref.read(sharedPrefsProvider);

    // Warm the state from the persisted JSON cache before any network call.
    final cached = _decode(prefs.getString(_cacheKey));

    // Subscribe to the Firestore stream. Each emission updates state and
    // refreshes the local cache so future cold starts are instant.
    ref.listen<AsyncValue<List<WordDocument>>>(wordsProvider, (_, next) {
      next.whenData((words) {
        state = AsyncData(words);
        prefs.setString(_cacheKey, _encode(words));
      });
    });

    return cached;
  }

  static List<WordDocument> _decode(String? raw) {
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .cast<Map<String, dynamic>>()
          .map((m) {
            return WordDocument(
              id: m['id'] as String,
              sinhala: m['sinhala'] as String,
              english: m['english'] as String,
              transliteration: m['transliteration'] as String,
              audioUrl: m['audioUrl'] as String?,
            );
          })
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  static String _encode(List<WordDocument> words) {
    return jsonEncode(
      words
          .map(
            (w) => {
              'id': w.id,
              'sinhala': w.sinhala,
              'english': w.english,
              'transliteration': w.transliteration,
              if (w.audioUrl != null) 'audioUrl': w.audioUrl,
            },
          )
          .toList(),
    );
  }
}

/// Cached word list — use this instead of [wordsProvider] in UI to avoid
/// showing a loading spinner on every restart.
final wordsCacheProvider =
    AsyncNotifierProvider<WordsCacheNotifier, List<WordDocument>>(
      WordsCacheNotifier.new,
    );
