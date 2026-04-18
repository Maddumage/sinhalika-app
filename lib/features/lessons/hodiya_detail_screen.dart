import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/hodiya_item.dart';
import '../../core/providers/providers.dart';
import '../../theme/app_theme.dart';
import 'data/hodiya_data.dart';
import 'letter_write_practice_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HodiyaDetailScreen — full-screen detail view for a single Sinhala letter
// ─────────────────────────────────────────────────────────────────────────────

class HodiyaDetailScreen extends ConsumerStatefulWidget {
  const HodiyaDetailScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  ConsumerState<HodiyaDetailScreen> createState() => _HodiyaDetailScreenState();
}

class _HodiyaDetailScreenState extends ConsumerState<HodiyaDetailScreen>
    with TickerProviderStateMixin {
  late PageController _pageCtrl;
  late int _currentIndex;

  late AnimationController _entryCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double> _letterScale;
  late Animation<double> _letterBounce;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _letterScale = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _letterBounce = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _entryCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _entryCtrl.forward(from: 0);
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

  void _speak(HodiyaItem item) {
    HapticFeedback.lightImpact();
    _bounceCtrl.forward(from: 0).then((_) => _bounceCtrl.reverse());
    ref.read(ttsServiceProvider).speak(item.letter);
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
          // ── Page view (swipeable letters) ──────────────────────────────
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: _onPageChanged,
            itemCount: hodiyaItems.length,
            itemBuilder: (context, index) {
              return _LetterDetailPage(
                item: hodiyaItems[index],
                index: index,
                total: hodiyaItems.length,
                isDark: isDark,
                textColor: textColor,
                muted: muted,
                surfColor: surfColor,
                entryCtrl: _entryCtrl,
                letterScale: _letterScale,
                letterBounce: _letterBounce,
                onSpeak: () => _speak(hodiyaItems[index]),
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
                    // Back button
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

          // ── Prev / Next navigation arrows ──────────────────────────────
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
                    // Dot indicators (show at most 7 at a time)
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
// _LetterDetailPage — content for a single letter
// ─────────────────────────────────────────────────────────────────────────────

class _LetterDetailPage extends StatelessWidget {
  const _LetterDetailPage({
    required this.item,
    required this.index,
    required this.total,
    required this.isDark,
    required this.textColor,
    required this.muted,
    required this.surfColor,
    required this.entryCtrl,
    required this.letterScale,
    required this.letterBounce,
    required this.onSpeak,
  });

  final HodiyaItem item;
  final int index;
  final int total;
  final bool isDark;
  final Color textColor;
  final Color muted;
  final Color surfColor;
  final AnimationController entryCtrl;
  final Animation<double> letterScale;
  final Animation<double> letterBounce;
  final VoidCallback onSpeak;

  Color get _accentColor {
    switch (item.colorIndex) {
      case 1:
        return isDark ? AppTheme.electricBlue : AppTheme.oceanBlue;
      case 2:
        return const Color(0xFF2E7D32);
      default:
        return AppTheme.heritageRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;
    final bgAccent = isDark
        ? accent.withValues(alpha: 0.08)
        : accent.withValues(alpha: 0.06);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero section ───────────────────────────────────────────────
          _HeroSection(
            item: item,
            accent: accent,
            bgAccent: bgAccent,
            isDark: isDark,
            textColor: textColor,
            muted: muted,
            letterScale: letterScale,
            letterBounce: letterBounce,
            onSpeak: onSpeak,
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Phonetic info card ─────────────────────────────────
                _FadeSlide(
                  animation: CurvedAnimation(
                    parent: entryCtrl,
                    curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
                  ),
                  child: _InfoCard(
                    title: 'Pronunciation',
                    isDark: isDark,
                    surfColor: surfColor,
                    textColor: textColor,
                    muted: muted,
                    accent: accent,
                    child: Row(
                      children: [
                        _PhoneticBadge(
                          label: 'Sound',
                          value: item.transliteration.toUpperCase(),
                          accent: accent,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _PhoneticBadge(
                          label: 'Type',
                          value: _letterType,
                          accent: accent,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Example word card ──────────────────────────────────
                _FadeSlide(
                  animation: CurvedAnimation(
                    parent: entryCtrl,
                    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                  ),
                  child: _InfoCard(
                    title: 'Example Word',
                    isDark: isDark,
                    surfColor: surfColor,
                    textColor: textColor,
                    muted: muted,
                    accent: accent,
                    child: Row(
                      children: [
                        // Emoji circle
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.dHst
                                : accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              item.emoji,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.word,
                                style: GoogleFonts.notoSansSinhala(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.wordTransliteration,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.english,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Fun facts card ─────────────────────────────────────
                _FadeSlide(
                  animation: CurvedAnimation(
                    parent: entryCtrl,
                    curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
                  ),
                  child: _InfoCard(
                    title: 'Did you know?',
                    isDark: isDark,
                    surfColor: surfColor,
                    textColor: textColor,
                    muted: muted,
                    accent: accent,
                    child: Column(
                      children: [
                        _FactRow(
                          icon: Icons.auto_awesome_rounded,
                          text:
                              '"${item.letter}" is romanised as '
                              '"${item.transliteration}" — '
                              'say it aloud 3 times!',
                          accent: accent,
                          muted: muted,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _FactRow(
                          icon: Icons.lightbulb_outline_rounded,
                          text:
                              '${item.word} (${item.english}) '
                              'starts with this letter.',
                          accent: accent,
                          muted: muted,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Write it yourself card ─────────────────────────────
                _FadeSlide(
                  animation: CurvedAnimation(
                    parent: entryCtrl,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ),
                  child: _WriteItCard(
                    letter: item.letter,
                    letterIndex: index,
                    accent: accent,
                    isDark: isDark,
                    surfColor: surfColor,
                    textColor: textColor,
                    muted: muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _letterType {
    // Vowels are the first 16 items (index 0–15), rest are consonants
    if (index < 16) return 'Vowel';
    return 'Consonant';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeroSection — large letter display with gradient bg + sound button
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.item,
    required this.accent,
    required this.bgAccent,
    required this.isDark,
    required this.textColor,
    required this.muted,
    required this.letterScale,
    required this.letterBounce,
    required this.onSpeak,
  });

  final HodiyaItem item;
  final Color accent;
  final Color bgAccent;
  final bool isDark;
  final Color textColor;
  final Color muted;
  final Animation<double> letterScale;
  final Animation<double> letterBounce;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 64;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topPad, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? AppTheme.dLow : const Color(0xFFFCFAF5),
            isDark
                ? accent.withValues(alpha: 0.12)
                : accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
          ),
        ),
      ),
      child: Column(
        children: [
          // ── Decorative circles + big letter ───────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: isDark ? 0.07 : 0.06),
                ),
              ),
              // Inner ring
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: isDark ? 0.12 : 0.1),
                ),
              ),
              // Letter
              AnimatedBuilder(
                animation: Listenable.merge([letterScale, letterBounce]),
                builder: (_, __) {
                  final scale = letterScale.value * letterBounce.value;
                  return Transform.scale(
                    scale: scale,
                    child: Text(
                      item.letter,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        color: accent,
                        height: 1,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Phonetic label ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.15 : 0.12),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: accent.withValues(alpha: isDark ? 0.3 : 0.25),
              ),
            ),
            child: Text(
              '/ ${item.transliteration} /',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: accent,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Sound button ───────────────────────────────────────────────
          GestureDetector(
            onTap: onSpeak,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hear the sound',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoCard — titled section card
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.isDark,
    required this.surfColor,
    required this.textColor,
    required this.muted,
    required this.accent,
    required this.child,
  });

  final String title;
  final bool isDark;
  final Color surfColor;
  final Color textColor;
  final Color muted;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFECE8DE),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PhoneticBadge
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneticBadge extends StatelessWidget {
  const _PhoneticBadge({
    required this.label,
    required this.value,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final String value;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: accent.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FactRow
// ─────────────────────────────────────────────────────────────────────────────

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.text,
    required this.accent,
    required this.muted,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final Color accent;
  final Color muted;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 13, color: muted, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _WriteItCard — interactive practice section (4 drawable canvases)
// ─────────────────────────────────────────────────────────────────────────────

class _WriteItCard extends StatefulWidget {
  const _WriteItCard({
    required this.letter,
    required this.letterIndex,
    required this.accent,
    required this.isDark,
    required this.surfColor,
    required this.textColor,
    required this.muted,
  });

  final String letter;
  final int letterIndex;
  final Color accent;
  final bool isDark;
  final Color surfColor;
  final Color textColor;
  final Color muted;

  @override
  State<_WriteItCard> createState() => _WriteItCardState();
}

class _WriteItCardState extends State<_WriteItCard> {
  // One strokes list per box
  final List<List<List<Offset>>> _boxStrokes = List.generate(4, (_) => []);

  void _clearBox(int i) {
    setState(() => _boxStrokes[i] = []);
    HapticFeedback.lightImpact();
  }

  void _clearAll() {
    setState(() {
      for (var i = 0; i < 4; i++) {
        _boxStrokes[i] = [];
      }
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final filledCount = _boxStrokes.where((s) => s.isNotEmpty).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: widget.surfColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDark ? AppTheme.dHst : const Color(0xFFECE8DE),
        ),
        boxShadow: widget.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          // Tap anywhere on the header to open the full-screen practice
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LetterWritePracticeScreen(
                    initialIndex: widget.letterIndex,
                  ),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'WRITE IT',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: widget.muted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.open_in_full_rounded, size: 13, color: widget.muted),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Quick-practice strip (tap card below opens full screen)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LetterWritePracticeScreen(
                    initialIndex: widget.letterIndex,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.accent.withValues(
                  alpha: widget.isDark ? 0.12 : 0.07,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.accent.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_note_rounded, size: 18, color: widget.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Open full-screen practice to write the letter',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: widget.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: widget.accent,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // ── Inline quick-practice row (header label) ───────────────────
          Row(
            children: [
              Text(
                'Quick Practice',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.muted,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // Clear all button
              if (filledCount > 0)
                GestureDetector(
                  onTap: _clearAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.heritageRed.withValues(
                        alpha: widget.isDark ? 0.15 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 12,
                          color: AppTheme.heritageRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Clear all',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.heritageRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(
                      alpha: widget.isDark ? 0.15 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Practice',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // ── 4 interactive drawing boxes ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                  child: _InteractiveTracingBox(
                    key: ValueKey('box_${widget.letter}_$i'),
                    letter: widget.letter,
                    showGuide: i == 0,
                    accent: widget.accent,
                    isDark: widget.isDark,
                    strokes: _boxStrokes[i],
                    onStrokeAdded: (stroke) {
                      setState(() => _boxStrokes[i].add(stroke));
                    },
                    onClear: () => _clearBox(i),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // ── Progress row ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  filledCount == 0
                      ? 'Trace the guide (box 1), then fill the rest!'
                      : filledCount < 4
                      ? 'Great! Keep going — $filledCount / 4 done.'
                      : 'Amazing! You wrote it 4 times! ⭐',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: filledCount == 4 ? widget.accent : widget.muted,
                    height: 1.4,
                    fontWeight: filledCount == 4
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              // Mini progress pip strip
              Row(
                children: List.generate(4, (i) {
                  final done = _boxStrokes[i].isNotEmpty;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(left: 4),
                    width: done ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: done
                          ? widget.accent
                          : (widget.isDark
                                ? AppTheme.dHst
                                : const Color(0xFFE0DCD4)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InteractiveTracingBox — single drawable canvas
// ─────────────────────────────────────────────────────────────────────────────

class _InteractiveTracingBox extends StatefulWidget {
  const _InteractiveTracingBox({
    super.key,
    required this.letter,
    required this.showGuide,
    required this.accent,
    required this.isDark,
    required this.strokes,
    required this.onStrokeAdded,
    required this.onClear,
  });

  final String letter;
  final bool showGuide;
  final Color accent;
  final bool isDark;
  final List<List<Offset>> strokes;
  final void Function(List<Offset> stroke) onStrokeAdded;
  final VoidCallback onClear;

  @override
  State<_InteractiveTracingBox> createState() => _InteractiveTracingBoxState();
}

class _InteractiveTracingBoxState extends State<_InteractiveTracingBox>
    with SingleTickerProviderStateMixin {
  List<Offset> _currentStroke = [];
  late AnimationController _starCtrl;
  late Animation<double> _starAnim;
  bool _justCompleted = false;

  @override
  void initState() {
    super.initState();
    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _starAnim = CurvedAnimation(parent: _starCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    super.dispose();
  }

  void _startStroke(Offset pos) {
    setState(() => _currentStroke = [pos]);
  }

  void _addPoint(Offset pos) {
    if (_currentStroke.isEmpty) return;
    setState(() => _currentStroke.add(pos));
  }

  void _endStroke() {
    if (_currentStroke.length < 2) {
      setState(() => _currentStroke = []);
      return;
    }
    final wasEmpty = widget.strokes.isEmpty;
    widget.onStrokeAdded(List.of(_currentStroke));
    setState(() => _currentStroke = []);
    if (wasEmpty) {
      _justCompleted = true;
      _starCtrl.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(_InteractiveTracingBox old) {
    super.didUpdateWidget(old);
    // Reset star animation when cleared
    if (old.strokes.isNotEmpty && widget.strokes.isEmpty) {
      _justCompleted = false;
      _starCtrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasStrokes = widget.strokes.isNotEmpty || _currentStroke.isNotEmpty;
    final bg = widget.isDark ? AppTheme.dHst : const Color(0xFFF8F6F0);
    final strokeColor = widget.isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onPanStart: (d) => _startStroke(d.localPosition),
            onPanUpdate: (d) => _addPoint(d.localPosition),
            onPanEnd: (_) => _endStroke(),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasStrokes
                      ? widget.accent.withValues(alpha: 0.6)
                      : widget.showGuide
                      ? widget.accent.withValues(alpha: 0.4)
                      : (widget.isDark
                            ? AppTheme.dHst
                            : const Color(0xFFE0DCD2)),
                  width: hasStrokes || widget.showGuide ? 1.5 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Stack(
                  children: [
                    // Crosshair
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CrosshairPainter(isDark: widget.isDark),
                      ),
                    ),
                    // Faded guide letter
                    if (widget.showGuide)
                      Center(
                        child: Text(
                          widget.letter,
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: widget.accent.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    // User strokes (committed)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _StrokesPainter(
                          strokes: widget.strokes,
                          currentStroke: _currentStroke,
                          strokeColor: strokeColor,
                        ),
                      ),
                    ),
                    // Star on first stroke
                    if (_justCompleted || widget.strokes.isNotEmpty)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: ScaleTransition(
                          scale: _starAnim,
                          child: const Text(
                            '⭐',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    // "Guide" label
                    if (widget.showGuide)
                      Positioned(
                        top: 5,
                        left: 6,
                        child: Text(
                          'Guide',
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: widget.accent.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Clear button below each box (visible only when has content)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: hasStrokes
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: widget.onClear,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: widget.isDark ? AppTheme.dMuted : AppTheme.lMuted,
              ),
            ),
          ),
          secondChild: const SizedBox(height: 21),
        ),
      ],
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
      ..strokeWidth = 3.0
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
// _DotIndicator — compact progress dots
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
    // Show at most 5 dots centred around current
    const visible = 5;
    final half = visible ~/ 2;
    int start = (current - half).clamp(0, (total - visible).clamp(0, total));
    int end = (start + visible).clamp(0, total);
    start = (end - visible).clamp(0, total);

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
                ? AppTheme.heritageRed
                : (isDark ? AppTheme.dHst : const Color(0xFFD4CFC4)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animation helpers
// ─────────────────────────────────────────────────────────────────────────────

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
