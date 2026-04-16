import '../models/hodiya_item.dart';
import '../models/noun_item.dart';
import '../models/phrase_item.dart';
import '../models/user_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Display value objects
// ─────────────────────────────────────────────────────────────────────────────

/// Resolved display properties for a [HodiyaItem] card.
class HodiyaDisplay {
  const HodiyaDisplay({
    this.letterHint,
    required this.wordLabel,
    this.wordHint,
    required this.ttsText,
  });

  /// Roman transliteration of the letter, e.g. 'a', 'ka'.
  /// Null in native mode — the user already reads Sinhala script.
  final String? letterHint;

  /// Sinhala example word; always shown regardless of mode.
  final String wordLabel;

  /// Combined romanisation + English meaning, e.g. 'Ammaa · Mother'.
  /// Null in native mode or advanced learner level.
  final String? wordHint;

  /// Text to pass to TTS when the user taps the card.
  final String ttsText;
}

/// Resolved display properties for a [NounItem] card.
class NounDisplay {
  const NounDisplay({
    required this.sinhala,
    required this.english,
    this.transliteration,
    this.exampleLine,
    required this.ttsText,
  });

  final String sinhala;
  final String english;

  /// Romanised pronunciation, e.g. '/potha/'.
  /// Null when the user is in native mode or at advanced level.
  final String? transliteration;

  /// Full example sentence line, already formatted for display.
  /// Null when the noun has no example or the user is at advanced level.
  final String? exampleLine;

  final String ttsText;
}

/// Resolved display properties for a [PhraseItem] card.
class PhraseDisplay {
  const PhraseDisplay({
    required this.sinhala,
    required this.english,
    this.transliteration,
    required this.ttsText,
  });

  final String sinhala;
  final String english;

  /// Romanised pronunciation, e.g. 'Kohomada?'.
  /// Null when the user is in native mode or at advanced level.
  final String? transliteration;

  final String ttsText;
}

// ─────────────────────────────────────────────────────────────────────────────
// ContentAdapter
// ─────────────────────────────────────────────────────────────────────────────

/// Stateless adapter that transforms raw content items into display payloads
/// based on the current [UserPreferences].
///
/// Rules:
/// - **native** mode → no transliteration (user already reads Sinhala script)
/// - **learner** mode + beginner/intermediate → show all transliteration hints
/// - **learner** mode + advanced → hide transliteration (challenge mode)
class ContentAdapter {
  ContentAdapter._();

  static bool _showTranslit(UserPreferences prefs) =>
      prefs.mode == LearningMode.learner &&
      prefs.level != LearningLevel.advanced;

  static HodiyaDisplay forHodiya(HodiyaItem item, UserPreferences prefs) {
    final show = _showTranslit(prefs);
    return HodiyaDisplay(
      letterHint: show ? item.transliteration : null,
      wordLabel: item.word,
      wordHint:
          show ? '${item.wordTransliteration} · ${item.english}' : null,
      ttsText: '${item.letter} ${item.word}',
    );
  }

  static NounDisplay forNoun(NounItem item, UserPreferences prefs) {
    final show = _showTranslit(prefs);

    String? exampleLine;
    if (item.exampleSinhala != null && item.exampleEnglish != null) {
      if (show && item.exampleTransliteration != null) {
        exampleLine =
            '"${item.exampleSinhala}" (${item.exampleTransliteration}) — ${item.exampleEnglish}';
      } else {
        exampleLine = '"${item.exampleSinhala}" — ${item.exampleEnglish}';
      }
    }

    return NounDisplay(
      sinhala: item.sinhala,
      english: item.english,
      transliteration: show ? item.transliteration : null,
      exampleLine: exampleLine,
      ttsText: item.exampleSinhala != null
          ? '${item.sinhala}. ${item.exampleSinhala}'
          : item.sinhala,
    );
  }

  static PhraseDisplay forPhrase(PhraseItem item, UserPreferences prefs) {
    final show = _showTranslit(prefs);
    return PhraseDisplay(
      sinhala: item.sinhala,
      english: item.english,
      transliteration: show ? item.transliteration : null,
      ttsText: item.sinhala,
    );
  }
}
