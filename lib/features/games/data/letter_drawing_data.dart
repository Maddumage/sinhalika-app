import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Letter Drawing — data models and lesson definitions
// All guide stroke coordinates are normalized (0.0 – 1.0) relative to canvas
// ─────────────────────────────────────────────────────────────────────────────

class LetterDrawingLesson {
  const LetterDrawingLesson({
    required this.lessonNumber,
    required this.letterSinhala,
    required this.letterEnglish,
    required this.phonetic,
    required this.description,
    required this.guideHint,
    required this.guideStrokes,
  });

  final int lessonNumber;
  final String letterSinhala;
  final String letterEnglish;
  final String phonetic;
  final String description;
  final String guideHint;

  /// Each inner list is one stroke: a sequence of normalized (x, y) waypoints.
  final List<List<Offset>> guideStrokes;
}

const List<LetterDrawingLesson> letterDrawingLessons = [
  // ─── Lesson 1: අ (A) ────────────────────────────────────────────────────
  LetterDrawingLesson(
    lessonNumber: 1,
    letterSinhala: 'අ',
    letterEnglish: 'A',
    phonetic: 'a',
    description: 'Draw the First Letter of the Alphabet.',
    guideHint:
        'Start from the blue glowing dot and curve your brush around the circle, then add a small tail at the bottom right!',
    guideStrokes: [
      [
        Offset(0.30, 0.50),
        Offset(0.24, 0.34),
        Offset(0.30, 0.20),
        Offset(0.46, 0.13),
        Offset(0.62, 0.16),
        Offset(0.74, 0.30),
        Offset(0.76, 0.48),
        Offset(0.68, 0.62),
        Offset(0.52, 0.68),
        Offset(0.38, 0.64),
        Offset(0.30, 0.54),
        Offset(0.30, 0.50),
        Offset(0.60, 0.74),
        Offset(0.76, 0.72),
      ],
    ],
  ),

  // ─── Lesson 2: ආ (Aa) ────────────────────────────────────────────────────
  LetterDrawingLesson(
    lessonNumber: 2,
    letterSinhala: 'ආ',
    letterEnglish: 'Aa',
    phonetic: 'aa',
    description: 'Draw the Second Letter.',
    guideHint:
        'Trace the oval shape first, then draw the tall vertical stroke on the right side!',
    guideStrokes: [
      [
        Offset(0.26, 0.50),
        Offset(0.20, 0.34),
        Offset(0.26, 0.20),
        Offset(0.42, 0.13),
        Offset(0.58, 0.16),
        Offset(0.68, 0.30),
        Offset(0.68, 0.48),
        Offset(0.60, 0.62),
        Offset(0.46, 0.68),
        Offset(0.32, 0.64),
        Offset(0.26, 0.54),
        Offset(0.26, 0.50),
      ],
      [Offset(0.82, 0.10), Offset(0.82, 0.82)],
    ],
  ),

  // ─── Lesson 3: ඇ (Ae) ─────────────────────────────────────────────────
  LetterDrawingLesson(
    lessonNumber: 3,
    letterSinhala: 'ඇ',
    letterEnglish: 'Ae',
    phonetic: 'ae',
    description: 'Draw the Third Letter.',
    guideHint:
        'Draw the oval shape first, then add the curved arch at the top right!',
    guideStrokes: [
      [
        Offset(0.26, 0.50),
        Offset(0.20, 0.34),
        Offset(0.26, 0.20),
        Offset(0.42, 0.13),
        Offset(0.58, 0.16),
        Offset(0.68, 0.30),
        Offset(0.68, 0.48),
        Offset(0.60, 0.62),
        Offset(0.46, 0.68),
        Offset(0.32, 0.64),
        Offset(0.26, 0.54),
        Offset(0.26, 0.50),
      ],
      [
        Offset(0.50, 0.13),
        Offset(0.64, 0.06),
        Offset(0.78, 0.10),
        Offset(0.84, 0.22),
      ],
    ],
  ),

  // ─── Lesson 4: ක (Ka) ────────────────────────────────────────────────────
  LetterDrawingLesson(
    lessonNumber: 4,
    letterSinhala: 'ක',
    letterEnglish: 'Ka',
    phonetic: 'ka',
    description: 'Draw the First Consonant.',
    guideHint:
        'Draw the vertical stroke first, then curve the hook from the middle and add the base tail!',
    guideStrokes: [
      [Offset(0.30, 0.14), Offset(0.30, 0.84)],
      [
        Offset(0.30, 0.36),
        Offset(0.44, 0.24),
        Offset(0.62, 0.28),
        Offset(0.72, 0.42),
        Offset(0.70, 0.56),
        Offset(0.56, 0.66),
        Offset(0.38, 0.66),
        Offset(0.30, 0.58),
        Offset(0.46, 0.80),
        Offset(0.68, 0.78),
      ],
    ],
  ),

  // ─── Lesson 5: ම (Ma) ────────────────────────────────────────────────────
  LetterDrawingLesson(
    lessonNumber: 5,
    letterSinhala: 'ම',
    letterEnglish: 'Ma',
    phonetic: 'ma',
    description: 'Draw the Letter Ma.',
    guideHint:
        'Draw the left loop first, then the right loop, and finish with the base stroke!',
    guideStrokes: [
      [
        Offset(0.24, 0.50),
        Offset(0.18, 0.36),
        Offset(0.26, 0.22),
        Offset(0.38, 0.18),
        Offset(0.46, 0.26),
        Offset(0.46, 0.42),
        Offset(0.36, 0.50),
        Offset(0.24, 0.50),
      ],
      [
        Offset(0.46, 0.26),
        Offset(0.56, 0.18),
        Offset(0.68, 0.20),
        Offset(0.76, 0.32),
        Offset(0.74, 0.46),
        Offset(0.64, 0.54),
        Offset(0.50, 0.54),
        Offset(0.46, 0.46),
      ],
      [Offset(0.24, 0.76), Offset(0.76, 0.76)],
    ],
  ),
];
