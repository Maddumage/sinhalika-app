import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/quiz_item.dart';
import '../../theme/app_theme.dart';
import 'data/quiz_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// QuizScreen — entry point that shows the available quiz lessons
// ─────────────────────────────────────────────────────────────────────────────

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final mutedColor = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: bg,
            floating: true,
            pinned: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LESSONS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: mutedColor,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'ප්‍රශ්න පතුය (Quiz)',
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
            titleSpacing: 0,
          ),

          // ── Lesson cards ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList.builder(
              itemCount: quizLessons.length,
              itemBuilder: (context, index) {
                final lesson = quizLessons[index];
                return _LessonCard(
                  lesson: lesson,
                  surface: surfColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _QuizPlay(lesson: lesson),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LessonCard
// ─────────────────────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.surface,
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
    required this.onTap,
  });

  final QuizLesson lesson;
  final Color surface;
  final Color textColor;
  final Color mutedColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: AppTheme.electricBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LESSON ${lesson.lessonNumber.toString().padLeft(2, '0')}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.electricBlue,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.titleSinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lesson.totalQuestions} questions',
                      style: GoogleFonts.inter(fontSize: 13, color: mutedColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: mutedColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _QuizPlay — the actual quiz question-by-question screen
// ─────────────────────────────────────────────────────────────────────────────

class _QuizPlay extends StatefulWidget {
  const _QuizPlay({required this.lesson});

  final QuizLesson lesson;

  @override
  State<_QuizPlay> createState() => _QuizPlayState();
}

class _QuizPlayState extends State<_QuizPlay> {
  int _currentIndex = 0;
  int? _selectedOption;
  int _score = 0;
  bool _showResult = false;

  QuizQuestion get _currentQuestion => widget.lesson.questions[_currentIndex];

  int get _total => widget.lesson.questions.length;

  void _selectOption(int index) {
    setState(() => _selectedOption = index);
  }

  void _advance() {
    if (_selectedOption == null) return;

    final isCorrect = _selectedOption == _currentQuestion.correctIndex;
    if (isCorrect) _score++;

    if (_currentIndex + 1 >= _total) {
      setState(() => _showResult = true);
    } else {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_showResult) {
      return _ResultScreen(
        lesson: widget.lesson,
        score: _score,
        total: _total,
        isDark: isDark,
        onRetry: () {
          setState(() {
            _currentIndex = 0;
            _selectedOption = null;
            _score = 0;
            _showResult = false;
          });
        },
        onBack: () => Navigator.of(context).pop(),
      );
    }

    return _QuestionView(
      lesson: widget.lesson,
      question: _currentQuestion,
      questionNumber: _currentIndex + 1,
      total: _total,
      selectedOption: _selectedOption,
      isDark: isDark,
      onOptionSelected: _selectOption,
      onNext: _advance,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _QuestionView — renders a single question
// ─────────────────────────────────────────────────────────────────────────────

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.lesson,
    required this.question,
    required this.questionNumber,
    required this.total,
    required this.selectedOption,
    required this.isDark,
    required this.onOptionSelected,
    required this.onNext,
  });

  final QuizLesson lesson;
  final QuizQuestion question;
  final int questionNumber;
  final int total;
  final int? selectedOption;
  final bool isDark;
  final ValueChanged<int> onOptionSelected;
  final VoidCallback onNext;

  Color get _bg => isDark ? AppTheme.dBg : AppTheme.lBg;
  Color get _textColor => isDark ? AppTheme.dText : AppTheme.lText;
  Color get _mutedColor => isDark ? AppTheme.dMuted : AppTheme.lMuted;
  Color get _surfColor => isDark ? AppTheme.dHigh : AppTheme.lSurf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      // ── Fixed Next button at bottom ──────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: selectedOption != null ? onNext : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                disabledBackgroundColor: isDark
                    ? AppTheme.dHst
                    : const Color(0xFFDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    questionNumber < total
                        ? 'මීළඟ ප්‍රශ්නය'
                        : 'ප්‍රතිඵලය බලන්න',
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selectedOption != null
                          ? Colors.white
                          : _mutedColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: selectedOption != null ? Colors.white : _mutedColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _textColor,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LESSON ${lesson.lessonNumber.toString().padLeft(2, '0')}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _mutedColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              lesson.titleSinhala,
                              style: GoogleFonts.notoSansSinhala(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Question counter pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.dHst
                              : const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${questionNumber.toString().padLeft(2, '0')}/$total',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: questionNumber / total,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? AppTheme.dHst
                          : const Color(0xFFDEDEDE),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.electricBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image + context badge
                    if (question.imageAsset != null) ...[
                      _ImageCard(
                        imageAsset: question.imageAsset!,
                        contextLabel: question.contextLabelSinhala,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Question text
                    Text(
                      question.questionSinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.questionEnglish,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _mutedColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options
                    ...List.generate(question.options.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i < question.options.length - 1 ? 12 : 0,
                        ),
                        child: _OptionButton(
                          label: question.options[i],
                          letter: String.fromCharCode(65 + i),
                          isSelected: selectedOption == i,
                          isDark: isDark,
                          surface: _surfColor,
                          textColor: _textColor,
                          onTap: () => onOptionSelected(i),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ImageCard — question illustration with context badge
// ─────────────────────────────────────────────────────────────────────────────

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.imageAsset,
    required this.isDark,
    this.contextLabel,
  });

  final String imageAsset;
  final String? contextLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: 180,
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
        ),
        if (contextLabel != null)
          Positioned(
            bottom: 10,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.glowingAmber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.white, size: 8),
                  const SizedBox(width: 6),
                  Text(
                    contextLabel!,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OptionButton — a single A/B/C/D answer option
// ─────────────────────────────────────────────────────────────────────────────

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.letter,
    required this.isSelected,
    required this.isDark,
    required this.surface,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final String letter;
  final bool isSelected;
  final bool isDark;
  final Color surface;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.electricBlue.withValues(alpha: 0.12)
              : surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.electricBlue
                : (isDark ? AppTheme.dHst : const Color(0xFFDDDDDD)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Letter circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.electricBlue
                    : (isDark ? AppTheme.dHst : const Color(0xFFEEEEEE)),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.electricBlue : textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ResultScreen — shown after answering all questions
// ─────────────────────────────────────────────────────────────────────────────

class _ResultScreen extends StatelessWidget {
  const _ResultScreen({
    required this.lesson,
    required this.score,
    required this.total,
    required this.isDark,
    required this.onRetry,
    required this.onBack,
  });

  final QuizLesson lesson;
  final int score;
  final int total;
  final bool isDark;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  Color get _bg => isDark ? AppTheme.dBg : AppTheme.lBg;
  Color get _textColor => isDark ? AppTheme.dText : AppTheme.lText;
  Color get _mutedColor => isDark ? AppTheme.dMuted : AppTheme.lMuted;
  Color get _surfColor => isDark ? AppTheme.dHigh : AppTheme.lSurf;

  String get _scoreEmoji {
    final pct = score / total;
    if (pct == 1.0) return '🏆';
    if (pct >= 0.7) return '⭐';
    if (pct >= 0.4) return '👍';
    return '📚';
  }

  String get _scoreMessage {
    final pct = score / total;
    if (pct == 1.0) return 'සම්පූර්ණ!';
    if (pct >= 0.7) return 'ඉතා හොඳයි!';
    if (pct >= 0.4) return 'හොඳ ලෙස උත්සාහ කරන්න!';
    return 'තවත් ඉගෙනගන්න!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_scoreEmoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 20),
              Text(
                _scoreMessage,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You answered $score out of $total correctly',
                style: GoogleFonts.inter(fontSize: 15, color: _mutedColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Score card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: _surfColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ScoreStat(
                      value: '$score',
                      label: 'Correct',
                      color: const Color(0xFF4CAF50),
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: isDark ? AppTheme.dHst : const Color(0xFFDDDDDD),
                    ),
                    _ScoreStat(
                      value: '${total - score}',
                      label: 'Wrong',
                      color: AppTheme.neonCoral,
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: isDark ? AppTheme.dHst : const Color(0xFFDDDDDD),
                    ),
                    _ScoreStat(
                      value: '${((score / total) * 100).round()}%',
                      label: 'Score',
                      color: AppTheme.electricBlue,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Retry
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'නැවත උත්සාහ කරන්න',
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Back
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? AppTheme.dHst : const Color(0xFFCCCCCC),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'ආපසු යන්න',
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  const _ScoreStat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  final String value;
  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
          ),
        ),
      ],
    );
  }
}
