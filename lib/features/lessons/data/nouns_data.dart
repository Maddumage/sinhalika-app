import 'package:flutter/material.dart';

import '../../../core/models/noun_item.dart';

// Colour values inline so this data file has no dependency on AppTheme.
//   oceanBlue   = 0xFF0067AD
//   neonCoral   = 0xFFFF7161
//   heritageRed = 0xFFC41F19
const nounItems = <NounItem>[
  NounItem(
    sinhala: 'පොත',
    english: 'Book',
    transliteration: '/potha/',
    emoji: '📖',
    style: NounCardStyle.plain,
    accentColor: Color(0xFF0067AD),
  ),
  NounItem(
    sinhala: 'මල',
    english: 'Flower',
    transliteration: '/mala/',
    emoji: '🌺',
    style: NounCardStyle.imageTop,
    accentColor: Color(0xFFFF7161),
  ),
  NounItem(
    sinhala: 'බල්ලා',
    english: 'Dog',
    transliteration: '/balla/',
    emoji: '🐕',
    exampleSinhala: 'බල්ලා බුරයි',
    exampleEnglish: 'The dog barks',
    exampleTransliteration: 'ballā burai',
    style: NounCardStyle.withExample,
    accentColor: Color(0xFF2E7D32),
  ),
  NounItem(
    sinhala: 'ගෙදර',
    english: 'Home / House',
    transliteration: '/gedara/',
    emoji: '🏡',
    style: NounCardStyle.tinted,
    accentColor: Color(0xFF2E7D32),
  ),
  NounItem(
    sinhala: 'ගස',
    english: 'Tree',
    transliteration: '/gasa/',
    emoji: '🌳',
    style: NounCardStyle.plain,
    accentColor: Color(0xFF2E7D32),
  ),
  NounItem(
    sinhala: 'අහස',
    english: 'Sky',
    transliteration: '/ahasa/',
    emoji: '🌤️',
    style: NounCardStyle.imageTop,
    accentColor: Color(0xFF0067AD),
  ),
  NounItem(
    sinhala: 'ඇස',
    english: 'Eye',
    transliteration: '/esa/',
    emoji: '👁️',
    exampleSinhala: 'ඇස රතු යි',
    exampleEnglish: 'The eye is red',
    exampleTransliteration: 'esa rathu yi',
    style: NounCardStyle.withExample,
    accentColor: Color(0xFFC41F19),
  ),
  NounItem(
    sinhala: 'ජලය',
    english: 'Water',
    transliteration: '/jalaya/',
    emoji: '💧',
    style: NounCardStyle.tinted,
    accentColor: Color(0xFF0067AD),
  ),
];
