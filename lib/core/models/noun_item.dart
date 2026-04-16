import 'package:flutter/material.dart';

/// Visual style variant for a noun lesson card.
enum NounCardStyle { plain, imageTop, withExample, tinted }

/// A single entry in the Sinhala nouns lesson.
class NounItem {
  const NounItem({
    required this.sinhala,
    required this.english,
    required this.transliteration,
    required this.emoji,
    this.exampleSinhala,
    this.exampleEnglish,
    this.exampleTransliteration,
    this.style = NounCardStyle.plain,
    this.accentColor,
    this.audioPath,
  });

  final String sinhala;
  final String english;

  /// Romanised pronunciation, e.g. '/potha/'.
  final String transliteration;

  final String emoji;
  final String? exampleSinhala;
  final String? exampleEnglish;

  /// Romanised example sentence transliteration.
  final String? exampleTransliteration;

  final NounCardStyle style;
  final Color? accentColor;

  /// Optional relative path to a bundled audio asset.
  final String? audioPath;
}
