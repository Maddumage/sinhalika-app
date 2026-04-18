import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'data/match_words_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MatchWordsScreen — level selector hub
// ─────────────────────────────────────────────────────────────────────────────

class MatchWordsScreen extends StatelessWidget {
  const MatchWordsScreen({super.key});

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Match the ',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Match the ',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Words',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Text(
                  'ශබ්ද ගැළපීමේ ක්‍රීඩාව — Choose a level and start matching!',
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 13,
                    color: muted,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Level cards ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList.separated(
                itemCount: matchWordsLevels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final level = matchWordsLevels[i];
                  return _LevelCard(
                    level: level,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _MatchWordsPlay(level: level),
                      ),
                    ),
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
// _LevelCard — card in the level selector list
// ─────────────────────────────────────────────────────────────────────────────
class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.isDark,
    required this.onTap,
  });

  final MatchWordsLevel level;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surfColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.dHst : const Color(0xFFE0DCD4),
          ),
        ),
        child: Row(
          children: [
            // Level badge
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppTheme.electricBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '${level.levelNumber}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.electricBlue,
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
                      color: AppTheme.glowingAmber,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'LEVEL ${level.levelNumber}: ${level.category}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.categoryLabel,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${level.pairs.length} words to match',
                    style: GoogleFonts.inter(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
            // Emoji previews
            Row(
              children: level.pairs
                  .take(3)
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        p.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.electricBlue,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MatchWordsPlay — the drag-and-drop game screen
// ─────────────────────────────────────────────────────────────────────────────
class _MatchWordsPlay extends StatefulWidget {
  const _MatchWordsPlay({required this.level});
  final MatchWordsLevel level;

  @override
  State<_MatchWordsPlay> createState() => _MatchWordsPlayState();
}

class _MatchWordsPlayState extends State<_MatchWordsPlay> {
  // Maps slotId → matched MatchWordPair (null = empty)
  late final Map<String, MatchWordPair?> _slotMatches;
  // Slots currently showing an error flash
  final Set<String> _errorSlots = {};
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _slotMatches = {for (final p in widget.level.pairs) p.id: null};
  }

  bool _isWordPlaced(String wordId) =>
      _slotMatches.values.any((w) => w?.id == wordId);

  bool get _isAllMatched =>
      widget.level.pairs.every((p) => _slotMatches[p.id]?.id == p.id);

  void _handleDrop(MatchWordPair target, MatchWordPair dropped) {
    if (dropped.id == target.id) {
      HapticFeedback.heavyImpact();
      setState(() {
        _slotMatches[target.id] = dropped;
      });
      if (_isAllMatched) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _showSuccess = true);
        });
      }
    } else {
      HapticFeedback.vibrate();
      setState(() => _errorSlots.add(target.id));
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _errorSlots.remove(target.id));
      });
    }
  }

  void _resetGame() {
    setState(() {
      for (final key in _slotMatches.keys) {
        _slotMatches[key] = null;
      }
      _errorSlots.clear();
      _showSuccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;

    final unplacedWords = widget.level.pairs
        .where((p) => !_isWordPlaced(p.id))
        .toList();

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top bar ─────────────────────────────────────────────
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.dHst
                                  : const Color(0xFFE0DCD4),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Match the Words',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _resetGame,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.electricBlue.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                size: 14,
                                color: AppTheme.electricBlue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reset',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
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

                  const SizedBox(height: 16),

                  // ── Level badge ─────────────────────────────────────────
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
                      'LEVEL ${widget.level.levelNumber}: ${widget.level.category}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Title ───────────────────────────────────────────────
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Match the ',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Words',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.electricBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Drag the Sinhala word blocks to the matching object cards. Explore and learn!',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: muted,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Image drop slots ────────────────────────────────────
                  ...widget.level.pairs.map(
                    (pair) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ImageDropSlot(
                        pair: pair,
                        isDark: isDark,
                        matchedWord: _slotMatches[pair.id],
                        isError: _errorSlots.contains(pair.id),
                        onDrop: (dropped) => _handleDrop(pair, dropped),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Word Bank ───────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.dLow : const Color(0xFFF8F6EF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppTheme.dHst : const Color(0xFFE0DCD4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 18,
                              color: AppTheme.electricBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Word Bank',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (unplacedWords.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '🎉 All words matched!',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: muted,
                                ),
                              ),
                            ),
                          )
                        else
                          ...unplacedWords.map(
                            (pair) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _WordTile(pair: pair, isDark: isDark),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Teacher's Tip ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.electricBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.electricBlue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.electricBlue.withValues(
                              alpha: 0.15,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 17,
                            color: AppTheme.electricBlue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Teacher's Tip",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.electricBlue,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.level.teacherTip,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppTheme.dMuted
                                      : AppTheme.lMuted,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Success overlay ─────────────────────────────────────────────
          if (_showSuccess)
            _SuccessOverlay(
              level: widget.level,
              isDark: isDark,
              onNext: () {
                final idx = matchWordsLevels.indexWhere(
                  (l) => l.levelNumber == widget.level.levelNumber,
                );
                if (idx < matchWordsLevels.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          _MatchWordsPlay(level: matchWordsLevels[idx + 1]),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              onRetry: _resetGame,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ImageDropSlot — DragTarget card for an image pair
// ─────────────────────────────────────────────────────────────────────────────
class _ImageDropSlot extends StatelessWidget {
  const _ImageDropSlot({
    required this.pair,
    required this.isDark,
    required this.matchedWord,
    required this.isError,
    required this.onDrop,
  });

  final MatchWordPair pair;
  final bool isDark;
  final MatchWordPair? matchedWord;
  final bool isError;
  final ValueChanged<MatchWordPair> onDrop;

  @override
  Widget build(BuildContext context) {
    final isMatched = matchedWord != null;

    return DragTarget<MatchWordPair>(
      onWillAcceptWithDetails: (details) => !isMatched,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        Color borderColor;
        if (isMatched) {
          borderColor = Colors.green.shade400;
        } else if (isError) {
          borderColor = Colors.red.shade400;
        } else if (isHovering) {
          borderColor = AppTheme.electricBlue;
        } else {
          borderColor = isDark ? AppTheme.dHst : const Color(0xFFD8D4CC);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isMatched
                ? Colors.green.withValues(alpha: 0.08)
                : isError
                ? Colors.red.withValues(alpha: 0.08)
                : isHovering
                ? AppTheme.electricBlue.withValues(alpha: 0.06)
                : (isDark ? AppTheme.dHigh : AppTheme.lSurf),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: isMatched || isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Image / emoji area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: pair.cardColor.withValues(alpha: 0.25),
                  child: Center(
                    child: Text(
                      pair.emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ),

              // Bonus label
              if (pair.isBonus)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '⭐  Bonus Item',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.glowingAmber,
                    ),
                  ),
                ),

              // Drop zone
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isMatched
                        ? Colors.green.withValues(alpha: 0.12)
                        : isDark
                        ? AppTheme.dBg.withValues(alpha: 0.6)
                        : const Color(0xFFF0EDE5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isMatched
                          ? Colors.green.shade400
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: isMatched
                        ? Text(
                            matchedWord!.wordSinhala,
                            style: GoogleFonts.notoSansSinhala(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.green.shade400,
                            ),
                          )
                        : Text(
                            isHovering ? 'Release to drop' : 'Drop word here',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: isHovering
                                  ? AppTheme.electricBlue
                                  : (isDark
                                        ? AppTheme.dMuted
                                        : AppTheme.lMuted),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _WordTile — draggable word chip in the Word Bank
// ─────────────────────────────────────────────────────────────────────────────
class _WordTile extends StatelessWidget {
  const _WordTile({required this.pair, required this.isDark});
  final MatchWordPair pair;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dHst : const Color(0xFFEFEBE2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3E44) : const Color(0xFFD8D4CC),
        ),
      ),
      child: Row(
        children: [
          Text(pair.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pair.wordSinhala,
              style: GoogleFonts.notoSansSinhala(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
          ),
          Icon(
            Icons.drag_indicator_rounded,
            size: 20,
            color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
          ),
        ],
      ),
    );

    return Draggable<MatchWordPair>(
      data: pair,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: Container(
            width:
                MediaQuery.of(context).size.width -
                32 -
                36, // account for padding
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dHst : const Color(0xFFEFEBE2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.electricBlue, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.electricBlue.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(pair.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pair.wordSinhala,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: tile),
      child: tile,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SuccessOverlay — shown when all words are matched correctly
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessOverlay extends StatelessWidget {
  const _SuccessOverlay({
    required this.level,
    required this.isDark,
    required this.onNext,
    required this.onRetry,
  });

  final MatchWordsLevel level;
  final bool isDark;
  final VoidCallback onNext;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isLastLevel = level.levelNumber == matchWordsLevels.length;

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? AppTheme.dHst : const Color(0xFFE0DCD4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                'Level ${level.levelNumber} Complete!',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.dText : AppTheme.lText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job matching all the ${level.categoryLabel} words!',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 14,
                  color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: AppTheme.glowingAmber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.dHst
                              : const Color(0xFFF0EDE5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Play Again',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppTheme.dText : AppTheme.lText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onNext,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.electricBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            isLastLevel ? 'Back to Levels' : 'Next Level →',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
