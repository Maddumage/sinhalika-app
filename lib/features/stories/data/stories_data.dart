import 'package:flutter/material.dart';

import '../../../core/models/story_item.dart';

const List<StoryItem> storyItems = [
  // ── 1 ─────────────────────────────────────────────────────────────────────
  StoryItem(
    id: 'mahadena_muttha',
    titleSinhala: 'මහදෙනමූත්තා සහ රබන් තැටිය',
    titleEnglish: 'The Elder and the Tambourine',
    descriptionSinhala:
        'මහදෙනමූත්තා සහ ඔහුගේ ගොල්ලන් රබන් තැටිය සොරාගත් ජිල්ලා හඹා ගිය හාස්‍යජනක කතාවක්.',
    descriptionEnglish:
        'A hilarious tale of the wise elder and his disciples chasing a mischievous thief.',
    emoji: '🥁',
    gradientColors: [Color(0xFF5D4037), Color(0xFF8D6E63)],
    category: StoryCategory.ancient,
    level: StoryLevel.beginner,
    readingMinutes: 8,
    paragraphs: [
      'ශ්‍රී ලංකාවේ ජනප්‍රිය ජනකතා චරිතයක් වූ මහදෙනමූත්තා, ගමේ ශ්‍රේෂ්ඨ ගුරුවරයෙකි. ඔහු සෑම විටම ශිෂ්‍යයන් රාශියක් ද සමඟ ගමෙන් ගමට ගොස් ධර්ම දේශනා කළේය.',
      'එක් රාත්‍රියක ඔවුහු ගමේ ධනවතෙකුගේ නිවසේ රාත්‍රී ආහාරය ගෙන නිදා ගත්හ. ඒ රාත්‍රියේ රබන් තැටිය සොරා ගෙන යාමට ජිල්ලෙකු ඇවිතිය.',
      'මහදෙනමූත්තා සවස් වරුවේ ගොල්ලනේ, ගොල්ලනේ! කෑ ගැසුවේ ය. ශිෂ්‍යයෝ හතරදෙනා ඇඳෙන් ගොඩ ගොඩ ලෝකයේ ගිය හාස්‍ය කෝලාහලයක් ඇති කළහ.',
      'ජිල්ලා ගිය ගිය ගිය ගොස් ගොල්ලා සොයා ගත් විට, රබන් තැටිය ගසක් මත තබා ගොස් ඇති බව දැනගත් ශිෂ්‍යයෝ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    ],
    vocabItems: [
      VocabItem(sinhala: 'පිරිස', english: 'Group / People', color: Color(0xFF2E7D32)),
      VocabItem(sinhala: 'කළබලය', english: 'Commotion', color: Color(0xFF0067AD)),
      VocabItem(sinhala: 'සමත්', english: 'Capable / Able', color: Color(0xFFC41F19)),
    ],
    moralSinhala: 'කෑදරකම නිසා දිනෙක ලැජ්ජාව ලැබේ.',
    moralEnglish: 'Greed only leads to misfortune.',
    didYouKnow:
        'මහදෙනමූත්තා යනු සිංහල ජනකතා ඉතිහාසයේ ඉතා ජනප්‍රිය හාස්‍යශීලී චරිතයෙකි. ඔහු ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
  ),

  // ── 2 ─────────────────────────────────────────────────────────────────────
  StoryItem(
    id: 'gamara_diwa_loke',
    titleSinhala: 'ගමරාල දිව ලෝකේ ගිය හැටි',
    titleEnglish: 'How the Villager Went to the Sky World',
    descriptionSinhala:
        'ගමරාල ඇත් රජාගේ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'A cunning village headman tricks his way to the heavenly realm.',
    emoji: '🐘',
    gradientColors: [Color(0xFF1A237E), Color(0xFF303F9F)],
    category: StoryCategory.ancient,
    level: StoryLevel.intermediate,
    readingMinutes: 10,
    paragraphs: [
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ගමරාල ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'දිව ලොවේ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    ],
    vocabItems: [
      VocabItem(sinhala: 'දිව ලොව', english: 'Heavenly Realm', color: Color(0xFF1565C0)),
      VocabItem(sinhala: 'ගමරාල', english: 'Village Headman', color: Color(0xFF2E7D32)),
      VocabItem(sinhala: 'ඉල්ලීම', english: 'Request', color: Color(0xFFE65100)),
    ],
    moralSinhala: 'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    moralEnglish: 'Honesty and wisdom always prevail.',
    didYouKnow:
        'ගමරාල ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
  ),

  // ── 3 ─────────────────────────────────────────────────────────────────────
  StoryItem(
    id: 'kalum_kana_gamarala',
    titleSinhala: 'කාළුම් කන ගමරාල',
    titleEnglish: 'The Trickster Headman',
    descriptionSinhala:
        'කාළුම් කන ගමරාල ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'A wise and cunning headman who always outsmarts even the cleverest rivals.',
    emoji: '🍛',
    gradientColors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    category: StoryCategory.ancient,
    level: StoryLevel.intermediate,
    readingMinutes: 7,
    paragraphs: [
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    ],
    vocabItems: [
      VocabItem(sinhala: 'කූට', english: 'Cunning', color: Color(0xFF6A1B9A)),
      VocabItem(sinhala: 'දිනුම', english: 'Victory', color: Color(0xFF2E7D32)),
    ],
    moralSinhala: 'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    moralEnglish: 'Intelligence always beats brute force.',
    didYouKnow:
        'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
  ),

  // ── 4 ─────────────────────────────────────────────────────────────────────
  StoryItem(
    id: 'paawa_saha_ikibiimba',
    titleSinhala: 'පාවා සහ ඉකිබිඹා',
    titleEnglish: 'The Hare and the Tortoise',
    descriptionSinhala:
        'ඉකිමන් ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'The classic race between the boastful hare and the steadfast tortoise.',
    emoji: '🐢',
    gradientColors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
    category: StoryCategory.animal,
    level: StoryLevel.beginner,
    readingMinutes: 6,
    paragraphs: [
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    ],
    vocabItems: [
      VocabItem(sinhala: 'ඉකිමන්', english: 'Hasty / Fast', color: Color(0xFFE65100)),
      VocabItem(sinhala: 'ඉවසීම', english: 'Patience', color: Color(0xFF2E7D32)),
      VocabItem(sinhala: 'ජය', english: 'Victory', color: Color(0xFF0067AD)),
    ],
    moralSinhala: 'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    moralEnglish: 'Slow and steady wins the race.',
    didYouKnow:
        'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
  ),

  // ── 5 ─────────────────────────────────────────────────────────────────────
  StoryItem(
    id: 'sinhaya_saha_musikaya',
    titleSinhala: 'සිංහයා සහ මූෂිකයා',
    titleEnglish: 'The Lion and the Mouse',
    descriptionSinhala:
        'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'A mighty lion is saved by a tiny mouse — kindness is never wasted.',
    emoji: '🦁',
    gradientColors: [Color(0xFFBF360C), Color(0xFFE64A19)],
    category: StoryCategory.animal,
    level: StoryLevel.beginner,
    readingMinutes: 5,
    paragraphs: [
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
      'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    ],
    vocabItems: [
      VocabItem(sinhala: 'සිංහයා', english: 'Lion', color: Color(0xFFE65100)),
      VocabItem(sinhala: 'දයාව', english: 'Compassion', color: Color(0xFF2E7D32)),
      VocabItem(sinhala: 'කෘතඥතා', english: 'Gratitude', color: Color(0xFF0067AD)),
    ],
    moralSinhala: 'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
    moralEnglish: 'No act of kindness is ever too small.',
    didYouKnow:
        'ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ ශ්‍රේෂ්ඨ.',
  ),
];
