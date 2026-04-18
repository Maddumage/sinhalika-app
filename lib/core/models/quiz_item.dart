// ─────────────────────────────────────────────────────────────────────────────
// QuizQuestion — a single multiple-choice question in a quiz lesson
// ─────────────────────────────────────────────────────────────────────────────

class QuizQuestion {
  const QuizQuestion({
    required this.questionSinhala,
    required this.questionEnglish,
    required this.options,
    required this.correctIndex,
    this.contextLabelSinhala,
    this.imageAsset,
  });

  /// The question in Sinhala script
  final String questionSinhala;

  /// English translation / hint shown below the question
  final String questionEnglish;

  /// Exactly 4 answer options (Sinhala)
  final List<String> options;

  /// Zero-based index of the correct option
  final int correctIndex;

  /// Optional badge shown on the image (e.g. story context name)
  final String? contextLabelSinhala;

  /// Optional asset image path shown above the question
  final String? imageAsset;
}

// ─────────────────────────────────────────────────────────────────────────────
// QuizLesson — a named collection of questions (one "lesson")
// ─────────────────────────────────────────────────────────────────────────────

class QuizLesson {
  const QuizLesson({
    required this.id,
    required this.lessonNumber,
    required this.titleSinhala,
    required this.questions,
  });

  final String id;
  final int lessonNumber;
  final String titleSinhala;
  final List<QuizQuestion> questions;

  int get totalQuestions => questions.length;
}
