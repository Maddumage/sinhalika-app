import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/phrase_item.dart';
import '../../core/providers/providers.dart';
import '../../theme/app_theme.dart';
import 'data/phrases_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class PhrasesScreen extends ConsumerStatefulWidget {
  const PhrasesScreen({super.key});

  @override
  ConsumerState<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends ConsumerState<PhrasesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  int _practiced = 3; // simulated progress

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _stagger(int index) {
    final start = (index * 0.07).clamp(0.0, 0.9);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
      floatingActionButton: _SearchFab(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDark),
          SliverToBoxAdapter(
            child: _FadeSlide(
              animation: _stagger(0),
              child: _buildHeader(isDark),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _FadeSlide(
                    animation: _stagger(i + 1),
                    child: _PhraseCard(
                      phrase: phraseItems[i],
                      isDark: isDark,
                      onSpeak: (text) =>
                          ref.read(ttsServiceProvider).speak(text),
                      onPractice: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          if (_practiced < phraseItems.length) _practiced++;
                        });
                      },
                    ),
                  ),
                ),
                childCount: phraseItems.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _FadeSlide(
              animation: _stagger(phraseItems.length + 1),
              child: _TodayGoalBanner(
                practiced: _practiced,
                total: phraseItems.length,
                isDark: isDark,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: (isDark ? AppTheme.dBg : AppTheme.lBg).withValues(
        alpha: 0.95,
      ),
      leading: BackButton(color: isDark ? AppTheme.dText : AppTheme.lText),
      title: Text(
        'Phrases (වාක්‍ය)',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.heritageRed,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: isDark ? AppTheme.dHigh : const Color(0xFFE8E8E8),
            child: Icon(
              Icons.person_rounded,
              size: 20,
              color: isDark ? AppTheme.dText : AppTheme.lText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's talk!",
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.dText : AppTheme.lText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Learn common Sinhala phrases for everyday fun.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phrase card
// ─────────────────────────────────────────────────────────────────────────────

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({
    required this.phrase,
    required this.isDark,
    required this.onSpeak,
    required this.onPractice,
  });
  final PhraseItem phrase;
  final bool isDark;
  final void Function(String text) onSpeak;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final cat = phrase.category;
    final bgColor = isDark
        ? cat.chipColor.withValues(alpha: 0.10)
        : cat.cardBgLight;

    return Column(
      children: [
        // Main phrase bubble
        _TapScale(
          onTap: () {
            HapticFeedback.lightImpact();
            onSpeak(phrase.sinhala);
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cat.chipColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat.label,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Sinhala phrase (large)
                      Text(
                        phrase.sinhala,
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: cat.chipColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // English translation
                      Text(
                        phrase.english,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? AppTheme.dText : AppTheme.lText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Volume button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSpeak(phrase.sinhala);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cat.chipColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Speech-bubble tail pointer
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: CustomPaint(
              size: const Size(16, 8),
              painter: _TailPainter(color: bgColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Record practice button
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: onPractice,
            icon: Icon(Icons.mic_rounded, size: 18, color: cat.chipColor),
            label: Text(
              'Record Practice',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cat.chipColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cat.chipColor.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's goal banner
// ─────────────────────────────────────────────────────────────────────────────

class _TodayGoalBanner extends StatelessWidget {
  const _TodayGoalBanner({
    required this.practiced,
    required this.total,
    required this.isDark,
  });
  final int practiced;
  final int total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = (practiced / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Goal",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: isDark
                          ? AppTheme.dHst
                          : const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$practiced/$total',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.dText : AppTheme.lText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              practiced >= total
                  ? '🌟 Goal complete! Amazing work!'
                  : '${total - practiced} more phrase${total - practiced == 1 ? '' : 's'} to reach your star!',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Speech bubble tail painter
// ─────────────────────────────────────────────────────────────────────────────

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TailPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Search FAB
// ─────────────────────────────────────────────────────────────────────────────

class _SearchFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => HapticFeedback.mediumImpact(),
      backgroundColor: AppTheme.oceanBlue,
      child: const Icon(Icons.search_rounded, color: Colors.white),
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
          begin: const Offset(0, 0.10),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 0.95,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
