import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/hodiya_item.dart';
import '../../core/providers/providers.dart';
import '../../theme/app_theme.dart';
import 'data/hodiya_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LetterWritePracticeScreen — full-screen freehand letter practice
// Swipeable across all 57 Hodiya letters, one large canvas per letter.
// ─────────────────────────────────────────────────────────────────────────────

class LetterWritePracticeScreen extends ConsumerStatefulWidget {
  const LetterWritePracticeScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  ConsumerState<LetterWritePracticeScreen> createState() =>
      _LetterWritePracticeScreenState();
}

class _LetterWritePracticeScreenState
    extends ConsumerState<LetterWritePracticeScreen> {
  late PageController _pageCtrl;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    HapticFeedback.selectionClick();
  }

  void _goNext() {
    if (_currentIndex < hodiyaItems.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
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
      body: Stack(
        children: [
          // ── Swipeable letter canvases ──────────────────────────────────
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: _onPageChanged,
            itemCount: hodiyaItems.length,
            itemBuilder: (context, index) {
              return _PracticePage(
                key: ValueKey('practice_$index'),
                item: hodiyaItems[index],
                index: index,
                isDark: isDark,
                textColor: textColor,
                muted: muted,
                surfColor: surfColor,
                onSpeak: () {
                  HapticFeedback.lightImpact();
                  ref.read(ttsServiceProvider).speak(hodiyaItems[index].letter);
                },
              );
            },
          ),

          // ── AppBar overlay ─────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    // Back
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.dHigh.withValues(alpha: 0.9)
                              : AppTheme.lSurf.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: textColor,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Title
                    Text(
                      'Write It',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),

                    const Spacer(),

                    // Counter badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.dHigh.withValues(alpha: 0.9)
                            : AppTheme.lSurf.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${hodiyaItems.length}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Prev / Next arrows ─────────────────────────────────────────
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavArrow(
                      icon: Icons.arrow_back_rounded,
                      enabled: _currentIndex > 0,
                      isDark: isDark,
                      onTap: _goPrev,
                    ),
                    _DotIndicator(
                      total: hodiyaItems.length,
                      current: _currentIndex,
                      isDark: isDark,
                    ),
                    _NavArrow(
                      icon: Icons.arrow_forward_rounded,
                      enabled: _currentIndex < hodiyaItems.length - 1,
                      isDark: isDark,
                      onTap: _goNext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PracticePage — single letter practice canvas page
// ─────────────────────────────────────────────────────────────────────────────

class _PracticePage extends StatefulWidget {
  const _PracticePage({
    super.key,
    required this.item,
    required this.index,
    required this.isDark,
    required this.textColor,
    required this.muted,
    required this.surfColor,
    required this.onSpeak,
  });

  final HodiyaItem item;
  final int index;
  final bool isDark;
  final Color textColor;
  final Color muted;
  final Color surfColor;
  final VoidCallback onSpeak;

  @override
  State<_PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<_PracticePage>
    with SingleTickerProviderStateMixin {
  List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _showGuide = true;
  int _completedCount = 0;

  late AnimationController _doneCtrl;
  late Animation<double> _doneAnim;

  Color get _accent {
    switch (widget.item.colorIndex) {
      case 1:
        return widget.isDark ? AppTheme.electricBlue : AppTheme.oceanBlue;
      case 2:
        return const Color(0xFF2E7D32);
      default:
        return AppTheme.heritageRed;
    }
  }

  @override
  void initState() {
    super.initState();
    _doneCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _doneAnim = CurvedAnimation(parent: _doneCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _doneCtrl.dispose();
    super.dispose();
  }

  void _startStroke(Offset pos) => setState(() => _currentStroke = [pos]);

  void _addPoint(Offset pos) {
    if (_currentStroke.isEmpty) return;
    setState(() => _currentStroke.add(pos));
  }

  void _endStroke() {
    if (_currentStroke.length < 2) {
      setState(() => _currentStroke = []);
      return;
    }
    setState(() {
      _strokes.add(List.of(_currentStroke));
      _currentStroke = [];
    });
    HapticFeedback.selectionClick();
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.removeLast());
    HapticFeedback.lightImpact();
  }

  void _saveAndClear() {
    if (_strokes.isEmpty) return;
    setState(() {
      _completedCount++;
      _strokes = [];
      _currentStroke = [];
    });
    _doneCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    final hasStrokes = _strokes.isNotEmpty || _currentStroke.isNotEmpty;
    final strokeColor = widget.isDark ? Colors.white : const Color(0xFF1A1A2E);
    final topPad = MediaQuery.of(context).padding.top + 72;
    final canvasColor = widget.isDark
        ? AppTheme.dHigh
        : const Color(0xFFF8F6F0);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: topPad),

            // ── Letter info strip ──────────────────────────────────────
            Row(
              children: [
                // Letter chip
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: widget.isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      widget.item.letter,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: accent,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '/ ${widget.item.transliteration} /',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: accent,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [
                          _SmallBadge(
                            label: widget.index < 16 ? 'Vowel' : 'Consonant',
                            color: accent,
                            isDark: widget.isDark,
                          ),
                          _SmallBadge(
                            label: widget.item.english,
                            color: accent,
                            isDark: widget.isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Speak button
                GestureDetector(
                  onTap: widget.onSpeak,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withValues(
                        alpha: widget.isDark ? 0.15 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: accent,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Drawing canvas ─────────────────────────────────────────
            AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onPanStart: (d) => _startStroke(d.localPosition),
                onPanUpdate: (d) => _addPoint(d.localPosition),
                onPanEnd: (_) => _endStroke(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: canvasColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: hasStrokes
                          ? accent.withValues(alpha: 0.5)
                          : (widget.isDark
                                ? AppTheme.dHst
                                : const Color(0xFFE0DCD2)),
                      width: hasStrokes ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(
                          alpha: hasStrokes ? 0.12 : 0.04,
                        ),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Stack(
                      children: [
                        // Crosshair guidelines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _CrosshairPainter(isDark: widget.isDark),
                          ),
                        ),
                        // Faded guide letter
                        if (_showGuide)
                          Center(
                            child: Text(
                              widget.item.letter,
                              style: GoogleFonts.notoSansSinhala(
                                fontSize: 160,
                                fontWeight: FontWeight.w900,
                                color: accent.withValues(alpha: 0.12),
                                height: 1,
                              ),
                            ),
                          ),
                        // User strokes
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _StrokesPainter(
                              strokes: _strokes,
                              currentStroke: _currentStroke,
                              strokeColor: strokeColor,
                            ),
                          ),
                        ),
                        // Empty state hint
                        if (!hasStrokes)
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.gesture_rounded,
                                  size: 28,
                                  color:
                                      (widget.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .withValues(alpha: 0.12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Draw here',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color:
                                        (widget.isDark
                                                ? Colors.white
                                                : Colors.black)
                                            .withValues(alpha: 0.15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // "Guide" label top-left
                        if (_showGuide)
                          Positioned(
                            top: 12,
                            left: 14,
                            child: Text(
                              'GUIDE',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: accent.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Action buttons row ─────────────────────────────────────
            Row(
              children: [
                // Guide toggle
                _ActionButton(
                  label: _showGuide ? 'Hide Guide' : 'Show Guide',
                  icon: _showGuide
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: accent,
                  isDark: widget.isDark,
                  onTap: () => setState(() => _showGuide = !_showGuide),
                ),
                const Spacer(),
                // Undo
                _ActionButton(
                  label: 'Undo',
                  icon: Icons.undo_rounded,
                  color: widget.isDark ? AppTheme.dMuted : AppTheme.lMuted,
                  isDark: widget.isDark,
                  enabled: _strokes.isNotEmpty,
                  onTap: _undo,
                ),
                const SizedBox(width: 10),
                // Save & clear
                _ActionButton(
                  label: 'Done',
                  icon: Icons.check_rounded,
                  color: AppTheme.glowingAmber,
                  isDark: widget.isDark,
                  enabled: hasStrokes,
                  onTap: _saveAndClear,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Progress strip ─────────────────────────────────────────
            ScaleTransition(
              scale: _doneAnim,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _completedCount == 0
                      ? (widget.isDark ? AppTheme.dHigh : widget.surfColor)
                      : accent.withValues(alpha: widget.isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _completedCount == 0
                        ? (widget.isDark
                              ? AppTheme.dHst
                              : const Color(0xFFE0DCD2))
                        : accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _completedCount == 0
                          ? Icons.edit_outlined
                          : Icons.edit_rounded,
                      size: 18,
                      color: _completedCount == 0 ? widget.muted : accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _completedCount == 0
                            ? 'Write the letter, then tap Done to save your attempt.'
                            : _completedCount == 1
                            ? 'Great! Written 1 time. Keep practising!'
                            : _completedCount < 5
                            ? 'Written $_completedCount times — you\'re getting better!'
                            : 'You\'ve written it $_completedCount times. Amazing! ⭐',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.4,
                          color: _completedCount == 0 ? widget.muted : accent,
                          fontWeight: _completedCount >= 5
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    // Star badges
                    if (_completedCount > 0)
                      Row(
                        children: List.generate(
                          (_completedCount).clamp(0, 5),
                          (_) => const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text('⭐', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ),
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
// Helper widgets (local to this screen)
// ─────────────────────────────────────────────────────────────────────────────

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.label,
    required this.color,
    required this.isDark,
  });

  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
    this.enabled = true,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.25 : 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────────────────────

class _StrokesPainter extends CustomPainter {
  const _StrokesPainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    if (currentStroke.length >= 2) {
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> pts, Paint paint) {
    if (pts.length < 2) return;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StrokesPainter old) =>
      old.strokes != strokes || old.currentStroke != currentStroke;
}

class _CrosshairPainter extends CustomPainter {
  const _CrosshairPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CrosshairPainter old) => old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavArrow
// ─────────────────────────────────────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppTheme.dHst : const Color(0xFFE0DCD4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 22,
            color: isDark ? AppTheme.dText : AppTheme.lText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DotIndicator
// ─────────────────────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.total,
    required this.current,
    required this.isDark,
  });

  final int total;
  final int current;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const visible = 5;
    final half = visible ~/ 2;
    var start = (current - half).clamp(0, (total - visible).clamp(0, total));
    if (start + visible > total) start = (total - visible).clamp(0, total);
    final end = (start + visible).clamp(0, total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(end - start, (i) {
        final idx = start + i;
        final isActive = idx == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? AppTheme.dText : AppTheme.lText)
                : (isDark ? AppTheme.dHst : const Color(0xFFD0CCC4)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
