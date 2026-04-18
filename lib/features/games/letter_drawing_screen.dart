import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'data/letter_drawing_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LetterDrawingScreen — lesson selector with progression
// ─────────────────────────────────────────────────────────────────────────────

class LetterDrawingScreen extends StatefulWidget {
  const LetterDrawingScreen({super.key});

  @override
  State<LetterDrawingScreen> createState() => _LetterDrawingScreenState();
}

class _LetterDrawingScreenState extends State<LetterDrawingScreen> {
  final Set<int> _completedLessons = {};
  int _currentLesson = 1; // 1-based index of the furthest unlocked lesson

  Future<void> _openLesson(LetterDrawingLesson lesson) async {
    if (lesson.lessonNumber > _currentLesson) return; // locked
    HapticFeedback.lightImpact();
    final accuracy = await Navigator.push<double>(
      context,
      MaterialPageRoute(builder: (_) => _LetterDrawPlay(lesson: lesson)),
    );
    if (accuracy != null && accuracy >= 0.60) {
      setState(() {
        _completedLessons.add(lesson.lessonNumber);
        _currentLesson = math.min(
          _currentLesson + 1,
          letterDrawingLessons.length,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: surfColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? AppTheme.dHst
                                : const Color(0xFFE0DCD4),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Letter ',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Drawing',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.glowingAmber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Follow the glowing paths to learn how to write Sinhala letters. '
                  'Complete each lesson to unlock the next!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: muted,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Lesson cards ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList.separated(
                itemCount: letterDrawingLessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final lesson = letterDrawingLessons[i];
                  final isCompleted = _completedLessons.contains(
                    lesson.lessonNumber,
                  );
                  final isLocked = lesson.lessonNumber > _currentLesson;
                  return _LessonCard(
                    lesson: lesson,
                    isDark: isDark,
                    isCompleted: isCompleted,
                    isLocked: isLocked,
                    onTap: () => _openLesson(lesson),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LessonCard — card in the lesson selector
// ─────────────────────────────────────────────────────────────────────────────
class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.isDark,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  final LetterDrawingLesson lesson;
  final bool isDark;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;

    Color accentColor;
    IconData stateIcon;
    if (isCompleted) {
      accentColor = Colors.green.shade400;
      stateIcon = Icons.check_rounded;
    } else if (isLocked) {
      accentColor = muted;
      stateIcon = Icons.lock_rounded;
    } else {
      accentColor = AppTheme.glowingAmber;
      stateIcon = Icons.edit_rounded;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? Colors.green.withValues(alpha: 0.4)
                  : isDark
                  ? AppTheme.dHst
                  : const Color(0xFFE0DCD4),
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Letter circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    lesson.letterSinhala,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'LESSON ${lesson.lessonNumber.toString().padLeft(2, '0')}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isCompleted ? Colors.white : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.description,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${lesson.letterSinhala}" (${lesson.phonetic.toUpperCase()})',
                      style: GoogleFonts.inter(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(stateIcon, color: accentColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LetterDrawPlay — the interactive drawing game screen
// ─────────────────────────────────────────────────────────────────────────────
class _LetterDrawPlay extends StatefulWidget {
  const _LetterDrawPlay({required this.lesson});
  final LetterDrawingLesson lesson;

  @override
  State<_LetterDrawPlay> createState() => _LetterDrawPlayState();
}

class _LetterDrawPlayState extends State<_LetterDrawPlay>
    with TickerProviderStateMixin {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  double _accuracy = 0.0;
  int _selectedTool = 0; // 0=brush, 1=pencil, 2=guide-toggle, 3=trash
  bool _showGuide = true;
  double _strokeWidth = 12.0;

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onPanStart(Offset pos) {
    setState(() => _currentStroke = [pos]);
  }

  void _onPanUpdate(Offset pos) {
    setState(() => _currentStroke.add(pos));
  }

  void _finishStroke(double canvasSize) {
    if (_currentStroke.length > 1) {
      final newStrokes = List<List<Offset>>.from(_strokes)
        ..add(List<Offset>.from(_currentStroke));
      final acc = _calculateAccuracy(newStrokes, canvasSize);
      setState(() {
        _strokes.add(List<Offset>.from(_currentStroke));
        _currentStroke = [];
        _accuracy = acc;
      });
    } else {
      setState(() => _currentStroke = []);
    }
  }

  double _calculateAccuracy(List<List<Offset>> strokes, double canvasSize) {
    final guideStrokes = widget.lesson.guideStrokes;
    final allGuidePoints = guideStrokes.expand((s) => s).toList();
    if (allGuidePoints.isEmpty || strokes.isEmpty) return 0.0;

    final allDrawnPoints = strokes.expand((s) => s).toList();
    const threshold = 28.0;
    int covered = 0;

    for (final gp in allGuidePoints) {
      final gpPixel = Offset(gp.dx * canvasSize, gp.dy * canvasSize);
      for (final dp in allDrawnPoints) {
        if ((gpPixel - dp).distance <= threshold) {
          covered++;
          break;
        }
      }
    }
    return covered / allGuidePoints.length;
  }

  void _selectTool(int tool) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedTool = tool;
      if (tool == 0) {
        _strokeWidth = 12.0;
        _showGuide = true;
      } else if (tool == 1) {
        _strokeWidth = 5.0;
        _showGuide = true;
      } else if (tool == 2) {
        _showGuide = !_showGuide;
      } else if (tool == 3) {
        _strokes.clear();
        _currentStroke = [];
        _accuracy = 0.0;
      }
    });
  }

  Widget _buildToolButton(int index, IconData icon, String tooltip) {
    final isActive = _selectedTool == index;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => _selectTool(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.electricBlue : const Color(0xFF1D2024),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppTheme.electricBlue : const Color(0xFF3A3E44),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.electricBlue.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 22,
            color: isActive ? Colors.white : const Color(0xFF9EA1A6),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Force dark-like styling for this game screen (matching mockup)
    const bg = Color(0xFF0C0E11);
    const cardBg = Color(0xFF111417);
    const textColor = AppTheme.dText;
    const muted = AppTheme.dMuted;

    final accuracyPct = (_accuracy * 100).round();

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _accuracy);
      },
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ────────────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, _accuracy),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF2A2E34)),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Letter Drawing',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Lesson badge ───────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.glowingAmber,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'LESSON ${widget.lesson.lessonNumber.toString().padLeft(2, '0')}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Title ──────────────────────────────────────────────────
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Draw the ',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      TextSpan(
                        text: 'First Letter\n',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                      TextSpan(
                        text: 'of the Alphabet.',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Follow the glowing path to learn how to write the Sinhala letter ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: muted,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '"${widget.lesson.letterSinhala}"',
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                      TextSpan(
                        text: ' (${widget.lesson.letterEnglish}).',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Tool buttons ───────────────────────────────────────────
                Row(
                  children: [
                    _buildToolButton(0, Icons.brush_rounded, 'Brush'),
                    const SizedBox(width: 14),
                    _buildToolButton(1, Icons.edit_rounded, 'Pencil'),
                    const SizedBox(width: 14),
                    _buildToolButton(
                      2,
                      _showGuide
                          ? Icons.auto_fix_high_rounded
                          : Icons.auto_fix_off_rounded,
                      'Toggle Guide',
                    ),
                    const SizedBox(width: 14),
                    _buildToolButton(3, Icons.delete_outline_rounded, 'Clear'),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Drawing canvas ─────────────────────────────────────────
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF232629)),
                  ),
                  child: Column(
                    children: [
                      // Canvas header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.electricBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.electricBlue.withValues(
                                      alpha: 0.6,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ACTIVE TRACING',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: AppTheme.glowingAmber,
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.emoji_events_rounded,
                              size: 20,
                              color: AppTheme.glowingAmber,
                            ),
                          ],
                        ),
                      ),

                      // Drawing area
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final canvasSize = constraints.maxWidth;
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onPanStart: (d) => _onPanStart(d.localPosition),
                                onPanUpdate: (d) =>
                                    _onPanUpdate(d.localPosition),
                                onPanEnd: (_) => _finishStroke(canvasSize),
                                child: AnimatedBuilder(
                                  animation: _pulseCtrl,
                                  builder: (context, _) => CustomPaint(
                                    painter: _DrawingCanvasPainter(
                                      strokes: _strokes,
                                      currentStroke: _currentStroke,
                                      guideStrokes: widget.lesson.guideStrokes,
                                      showGuide: _showGuide,
                                      strokeWidth: _strokeWidth,
                                      pulseValue: _pulseCtrl.value,
                                    ),
                                    size: Size(canvasSize, canvasSize),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Instructor card ─────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF232629)),
                  ),
                  child: Column(
                    children: [
                      // Avatar + name
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.electricBlue,
                                width: 2,
                              ),
                              color: const Color(0xFF1D2024),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/learning_kid.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.face_rounded,
                                  size: 32,
                                  color: AppTheme.electricBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, I'm Nil-Kobo!",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Your drawing guide',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Quote
                      Text(
                        '"${widget.lesson.guideHint}"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: muted,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Play Sound button
                      GestureDetector(
                        onTap: () => HapticFeedback.mediumImpact(),
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF3A3E44)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.volume_up_rounded,
                                size: 18,
                                color: AppTheme.electricBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Play Sound',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.electricBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Accuracy bar ───────────────────────────────────────────
                Row(
                  children: [
                    Text(
                      'LETTER ACCURACY',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: muted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$accuracyPct%',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: accuracyPct >= 70
                            ? Colors.green.shade400
                            : AppTheme.electricBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _accuracy,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF1D2024),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      accuracyPct >= 70
                          ? Colors.green.shade400
                          : AppTheme.electricBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Lesson progress dots ───────────────────────────────────
                _LessonProgressDots(lesson: widget.lesson, isDark: isDark),

                // Complete button if accuracy reached
                if (accuracyPct >= 60) ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, _accuracy),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '✓  Complete Lesson',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LessonProgressDots — row of dots showing which lesson is active
// ─────────────────────────────────────────────────────────────────────────────
class _LessonProgressDots extends StatelessWidget {
  const _LessonProgressDots({required this.lesson, required this.isDark});
  final LetterDrawingLesson lesson;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: letterDrawingLessons.map((l) {
        final isCurrent = l.lessonNumber == lesson.lessonNumber;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrent ? 28 : 18,
            height: 18,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppTheme.electricBlue
                  : const Color(0xFF1D2024),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isCurrent
                    ? AppTheme.electricBlue
                    : const Color(0xFF3A3E44),
              ),
            ),
            child: Center(
              child: Text(
                '${l.lessonNumber}',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? Colors.white : const Color(0xFF3A3E44),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DrawingCanvasPainter — CustomPainter for the guide path + user strokes
// ─────────────────────────────────────────────────────────────────────────────
class _DrawingCanvasPainter extends CustomPainter {
  _DrawingCanvasPainter({
    required this.strokes,
    required this.currentStroke,
    required this.guideStrokes,
    required this.showGuide,
    required this.strokeWidth,
    required this.pulseValue,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final List<List<Offset>> guideStrokes;
  final bool showGuide;
  final double strokeWidth;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Guide path (dashed blue)
    if (showGuide && guideStrokes.isNotEmpty) {
      final guidePaint = Paint()
        ..color = AppTheme.electricBlue.withValues(alpha: 0.65)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (final stroke in guideStrokes) {
        if (stroke.length < 2) continue;
        for (int i = 0; i < stroke.length - 1; i++) {
          final from = Offset(
            stroke[i].dx * size.width,
            stroke[i].dy * size.height,
          );
          final to = Offset(
            stroke[i + 1].dx * size.width,
            stroke[i + 1].dy * size.height,
          );
          _drawDashedLine(canvas, from, to, guidePaint, 9, 6);
        }
      }

      // Starting dot (pulsing)
      if (guideStrokes.first.isNotEmpty) {
        final start = guideStrokes.first.first;
        final pt = Offset(start.dx * size.width, start.dy * size.height);
        final glowRadius = 12.0 + 5.0 * pulseValue;

        canvas.drawCircle(
          pt,
          glowRadius,
          Paint()
            ..color = AppTheme.electricBlue.withValues(alpha: 0.25 * pulseValue)
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          pt,
          8,
          Paint()
            ..color = AppTheme.electricBlue
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          pt,
          4,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );
      }
    }

    // 2. User-drawn strokes
    final userPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.90)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, userPaint);
    }
    if (currentStroke.length > 1) {
      _drawStroke(canvas, currentStroke, userPaint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Paint paint,
    double dashLen,
    double gapLen,
  ) {
    final total = (to - from).distance;
    if (total == 0) return;
    final dir = (to - from) / total;
    double pos = 0;
    bool drawDash = true;
    while (pos < total) {
      final segLen = drawDash ? dashLen : gapLen;
      final end = (pos + segLen).clamp(0.0, total);
      if (drawDash) {
        canvas.drawLine(from + dir * pos, from + dir * end, paint);
      }
      pos += segLen;
      drawDash = !drawDash;
    }
  }

  @override
  bool shouldRepaint(_DrawingCanvasPainter old) =>
      old.strokes != strokes ||
      old.currentStroke != currentStroke ||
      old.showGuide != showGuide ||
      old.pulseValue != pulseValue;
}
