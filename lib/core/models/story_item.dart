import 'package:flutter/material.dart';

/// Age-group difficulty indicator for a folk tale.
enum StoryLevel { beginner, intermediate, advanced }

extension StoryLevelLabel on StoryLevel {
  String get label {
    switch (this) {
      case StoryLevel.beginner:
        return 'Beginner';
      case StoryLevel.intermediate:
        return 'Intermediate';
      case StoryLevel.advanced:
        return 'Advanced';
    }
  }

  String get sinhalaLabel {
    switch (this) {
      case StoryLevel.beginner:
        return 'ආරම්භක';
      case StoryLevel.intermediate:
        return 'මධ්‍යම';
      case StoryLevel.advanced:
        return 'උසස්';
    }
  }
}

/// Genre / category filter for folk tales.
enum StoryCategory { ancient, animal, wisdom }

extension StoryCategoryLabel on StoryCategory {
  String get sinhalaLabel {
    switch (this) {
      case StoryCategory.ancient:
        return 'පැරණි කතා';
      case StoryCategory.animal:
        return 'සත්ව කතා';
      case StoryCategory.wisdom:
        return 'ප්‍රඥා කතා';
    }
  }
}

/// A vocabulary word from a folk tale with its English gloss and colour.
class VocabItem {
  const VocabItem({
    required this.sinhala,
    required this.english,
    required this.color,
  });

  final String sinhala;
  final String english;
  final Color color;
}

/// A single Sinhala folk tale (Janakatha).
class StoryItem {
  const StoryItem({
    required this.id,
    required this.titleSinhala,
    required this.titleEnglish,
    required this.descriptionSinhala,
    required this.descriptionEnglish,
    required this.emoji,
    required this.gradientColors,
    required this.paragraphs,
    required this.level,
    required this.readingMinutes,
    this.category = StoryCategory.ancient,
    this.vocabItems = const [],
    this.moralSinhala,
    this.moralEnglish,
    this.didYouKnow,
  });

  final String id;
  final String titleSinhala;
  final String titleEnglish;
  final String descriptionSinhala;
  final String descriptionEnglish;
  final String emoji;

  /// Two-color gradient for the story cover.
  final List<Color> gradientColors;

  /// Story body split into paragraphs.
  final List<String> paragraphs;

  final StoryLevel level;

  /// Approximate reading time in minutes.
  final int readingMinutes;

  final StoryCategory category;
  final List<VocabItem> vocabItems;

  final String? moralSinhala;
  final String? moralEnglish;

  /// Fun fact shown in the "ඔබ දන්නවාද?" section.
  final String? didYouKnow;
}
