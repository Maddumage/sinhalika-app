import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Match the Words — data models and level definitions
// ─────────────────────────────────────────────────────────────────────────────

class MatchWordPair {
  const MatchWordPair({
    required this.id,
    required this.wordSinhala,
    required this.wordEnglish,
    required this.emoji,
    required this.cardColor,
    this.isBonus = false,
  });

  final String id;
  final String wordSinhala;
  final String wordEnglish;
  final String emoji;
  final Color cardColor;
  final bool isBonus;
}

class MatchWordsLevel {
  const MatchWordsLevel({
    required this.levelNumber,
    required this.category,
    required this.categoryLabel,
    required this.pairs,
    required this.teacherTip,
  });

  final int levelNumber;
  final String category; // e.g. "OBJECTS"
  final String categoryLabel; // Sinhala
  final List<MatchWordPair> pairs;
  final String teacherTip;
}

const List<MatchWordsLevel> matchWordsLevels = [
  MatchWordsLevel(
    levelNumber: 1,
    category: 'OBJECTS',
    categoryLabel: 'දේවල්',
    teacherTip:
        'Try matching the starting sounds of the Sinhala words with the pictures!',
    pairs: [
      MatchWordPair(
        id: 'book',
        wordSinhala: 'පොත',
        wordEnglish: 'Book',
        emoji: '📚',
        cardColor: Color(0xFF1565C0),
      ),
      MatchWordPair(
        id: 'dog',
        wordSinhala: 'බල්ලා',
        wordEnglish: 'Dog',
        emoji: '🐕',
        cardColor: Color(0xFF4E342E),
      ),
      MatchWordPair(
        id: 'flower',
        wordSinhala: 'මල',
        wordEnglish: 'Flower',
        emoji: '🌸',
        cardColor: Color(0xFF880E4F),
        isBonus: true,
      ),
    ],
  ),
  MatchWordsLevel(
    levelNumber: 2,
    category: 'ANIMALS',
    categoryLabel: 'සත්ත්වයෝ',
    teacherTip:
        'Look at the animal pictures carefully — think of how they sound in Sinhala!',
    pairs: [
      MatchWordPair(
        id: 'elephant',
        wordSinhala: 'ඇතා',
        wordEnglish: 'Elephant',
        emoji: '🐘',
        cardColor: Color(0xFF37474F),
      ),
      MatchWordPair(
        id: 'tiger',
        wordSinhala: 'කොටියා',
        wordEnglish: 'Tiger',
        emoji: '🐅',
        cardColor: Color(0xFFE65100),
      ),
      MatchWordPair(
        id: 'bird',
        wordSinhala: 'කුරුල්ලා',
        wordEnglish: 'Bird',
        emoji: '🦜',
        cardColor: Color(0xFF1B5E20),
        isBonus: true,
      ),
    ],
  ),
  MatchWordsLevel(
    levelNumber: 3,
    category: 'NATURE',
    categoryLabel: 'ස්වභාවය',
    teacherTip:
        'Nature words in Sinhala often have beautiful sounds. Listen and match!',
    pairs: [
      MatchWordPair(
        id: 'tree',
        wordSinhala: 'ගස',
        wordEnglish: 'Tree',
        emoji: '🌳',
        cardColor: Color(0xFF1B5E20),
      ),
      MatchWordPair(
        id: 'mountain',
        wordSinhala: 'කන්ද',
        wordEnglish: 'Mountain',
        emoji: '⛰️',
        cardColor: Color(0xFF4A148C),
      ),
      MatchWordPair(
        id: 'sun',
        wordSinhala: 'ඉර',
        wordEnglish: 'Sun',
        emoji: '☀️',
        cardColor: Color(0xFFE65100),
        isBonus: true,
      ),
    ],
  ),
  MatchWordsLevel(
    levelNumber: 4,
    category: 'FOOD',
    categoryLabel: 'ආහාර',
    teacherTip:
        'Think about food you eat every day — can you say it in Sinhala?',
    pairs: [
      MatchWordPair(
        id: 'rice',
        wordSinhala: 'බත',
        wordEnglish: 'Rice',
        emoji: '🍚',
        cardColor: Color(0xFF33691E),
      ),
      MatchWordPair(
        id: 'milk',
        wordSinhala: 'කිරි',
        wordEnglish: 'Milk',
        emoji: '🥛',
        cardColor: Color(0xFF006064),
      ),
      MatchWordPair(
        id: 'banana',
        wordSinhala: 'කෙසෙල්',
        wordEnglish: 'Banana',
        emoji: '🍌',
        cardColor: Color(0xFFF57F17),
        isBonus: true,
      ),
    ],
  ),
  MatchWordsLevel(
    levelNumber: 5,
    category: 'COLORS',
    categoryLabel: 'වර්ණ',
    teacherTip:
        'Colors are everywhere! Practice saying Sinhala color words out loud.',
    pairs: [
      MatchWordPair(
        id: 'red',
        wordSinhala: 'රතු',
        wordEnglish: 'Red',
        emoji: '❤️',
        cardColor: Color(0xFFC62828),
      ),
      MatchWordPair(
        id: 'blue',
        wordSinhala: 'නිල්',
        wordEnglish: 'Blue',
        emoji: '💙',
        cardColor: Color(0xFF0D47A1),
      ),
      MatchWordPair(
        id: 'green',
        wordSinhala: 'කොළ',
        wordEnglish: 'Green',
        emoji: '💚',
        cardColor: Color(0xFF1B5E20),
        isBonus: true,
      ),
    ],
  ),
];
