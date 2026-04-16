/// A single entry in the Sinhala Hodiya (alphabet) lesson.
class HodiyaItem {
  const HodiyaItem({
    required this.letter,
    required this.transliteration,
    required this.word,
    required this.wordTransliteration,
    required this.english,
    required this.emoji,
    required this.colorIndex,
    this.audioPath,
  });

  /// The Sinhala letter glyph, e.g. 'අ'.
  final String letter;

  /// Romanised letter sound, e.g. 'a', 'ka', 'tha'.
  final String transliteration;

  /// Sinhala example word for the letter, e.g. 'අම්මා'.
  final String word;

  /// Romanised example word, e.g. 'Ammaa'.
  final String wordTransliteration;

  /// English meaning of the example word, e.g. 'Mother'.
  final String english;

  final String emoji;

  /// Palette index — 0 = heritage red, 1 = ocean blue, 2 = forest green.
  final int colorIndex;

  /// Optional relative path to a bundled audio asset.
  final String? audioPath;
}
