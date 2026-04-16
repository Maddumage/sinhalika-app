import 'package:flutter/material.dart';

/// Thematic category for a phrase lesson card.
enum PhraseCategory { greeting, polite, morning, daily, farewell, question }

/// UI helpers attached to each [PhraseCategory].
///
/// Colour values are inlined to keep this model layer independent of AppTheme.
///   heritageRed  = 0xFFC41F19
///   oceanBlue    = 0xFF0067AD
///   neonCoral    = 0xFFFF7161
///   glowingAmber = 0xFFFF9800
extension PhraseCategoryExt on PhraseCategory {
  String get label {
    switch (this) {
      case PhraseCategory.greeting:
        return 'GREETING';
      case PhraseCategory.polite:
        return 'POLITE';
      case PhraseCategory.morning:
        return 'MORNING';
      case PhraseCategory.daily:
        return 'DAILY';
      case PhraseCategory.farewell:
        return 'FAREWELL';
      case PhraseCategory.question:
        return 'QUESTION';
    }
  }

  Color get chipColor {
    switch (this) {
      case PhraseCategory.greeting:
        return const Color(0xFFC41F19);
      case PhraseCategory.polite:
        return const Color(0xFF0067AD);
      case PhraseCategory.morning:
        return const Color(0xFF2E7D32);
      case PhraseCategory.daily:
        return const Color(0xFFFF7161);
      case PhraseCategory.farewell:
        return const Color(0xFFFF9800);
      case PhraseCategory.question:
        return const Color(0xFF7B1FA2);
    }
  }

  Color get cardBgLight {
    switch (this) {
      case PhraseCategory.greeting:
        return const Color(0xFFFDE8E8);
      case PhraseCategory.polite:
        return const Color(0xFFE8F0FE);
      case PhraseCategory.morning:
        return const Color(0xFFE8F5E9);
      case PhraseCategory.daily:
        return const Color(0xFFFFF3E0);
      case PhraseCategory.farewell:
        return const Color(0xFFFFF9C4);
      case PhraseCategory.question:
        return const Color(0xFFF3E5F5);
    }
  }
}

/// A single entry in the Sinhala phrases lesson.
class PhraseItem {
  const PhraseItem({
    required this.sinhala,
    required this.transliteration,
    required this.english,
    required this.category,
    this.audioPath,
  });

  final String sinhala;

  /// Romanised pronunciation separated from the English translation.
  final String transliteration;

  /// Pure English meaning (no embedded transliteration).
  final String english;

  final PhraseCategory category;

  /// Optional relative path to a bundled audio asset.
  final String? audioPath;
}
