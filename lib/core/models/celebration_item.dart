import 'package:flutter/material.dart';

/// A single Sri Lankan cultural celebration entry.
class CelebrationItem {
  const CelebrationItem({
    required this.id,
    required this.nameSinhala,
    required this.nameEnglish,
    required this.descriptionSinhala,
    required this.descriptionEnglish,
    required this.monthSinhala,
    required this.monthEnglish,
    required this.emoji,
    required this.gradientColors,
    required this.cultureFacts,
    this.activitySinhala,
    this.activityEnglish,
  });

  final String id;
  final String nameSinhala;
  final String nameEnglish;
  final String descriptionSinhala;
  final String descriptionEnglish;
  final String monthSinhala;
  final String monthEnglish;
  final String emoji;

  /// Two-color gradient for the celebration card.
  final List<Color> gradientColors;

  /// Short cultural facts / trivia bullets.
  final List<String> cultureFacts;

  final String? activitySinhala;
  final String? activityEnglish;
}
