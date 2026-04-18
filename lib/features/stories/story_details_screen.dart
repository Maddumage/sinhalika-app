import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/story_item.dart';
import '../../core/providers/providers.dart';
import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StoryDetailsScreen — audio player, drop-cap text, vocab chips, did-you-know
// ─────────────────────────────────────────────────────────────────────────────

class StoryDetailsScreen extends ConsumerStatefulWidget {
  const StoryDetailsScreen({super.key, required this.story});
  final StoryItem story;

  @override
  ConsumerState<StoryDetailsScreen> createState() =>
      _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends ConsumerState<StoryDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  bool _expanded = false;
  int _elapsed = 0; // seconds
  Timer? _timer;

  int get _totalSeconds => widget.story.readingMinutes * 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmtTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _togglePlay() async {
    HapticFeedback.mediumImpact();
    final tts = ref.read(ttsServiceProvider);
    if (_isPlaying) {
      await tts.stop();
      _timer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      final text = widget.story.paragraphs.join(' ');
      await tts.speak(text);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_elapsed >= _totalSeconds) {
          t.cancel();
          setState(() {
            _isPlaying = false;
            _elapsed = 0;
          });
        } else {
          setState(() => _elapsed++);
        }
      });
      setState(() => _isPlaying = true);
    }
  }

  void _skip(int secs) {
    setState(() {
      _elapsed = (_elapsed + secs).clamp(0, _totalSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final surf = isDark ? AppTheme.dHigh : AppTheme.lSurf;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final border = isDark ? AppTheme.dHst : const Color(0xFFE8E4DC);
    final story = widget.story;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ── Cover image with play button overlay ──────────────────────────
          _CoverArea(
            story: story,
            isDark: isDark,
            onBack: () {
              if (_isPlaying) {
                ref.read(ttsServiceProvider).stop();
                _timer?.cancel();
              }
              context.pop();
            },
          ),
          // ── Scrollable content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  Text(
                    'ජනකතා පෙළගස්ම',
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 12,
                      color: AppTheme.glowingAmber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    story.titleSinhala,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // ── Audio player ──────────────────────────────────────────
                  _AudioPlayerCard(
                    isDark: isDark,
                    surf: surf,
                    border: border,
                    textColor: textColor,
                    muted: muted,
                    isPlaying: _isPlaying,
                    elapsed: _elapsed,
                    total: _totalSeconds,
                    onPlay: _togglePlay,
                    onSkipBack: () => _skip(-10),
                    onSkipForward: () => _skip(10),
                    fmtTime: _fmtTime,
                  ),
                  const SizedBox(height: 22),
                  // ── Story text (drop cap on first paragraph) ──────────────
                  _StoryTextSection(
                    paragraphs: story.paragraphs,
                    expanded: _expanded,
                    isDark: isDark,
                    textColor: textColor,
                    muted: muted,
                    onExpand: () => setState(() => _expanded = !_expanded),
                  ),
                  const SizedBox(height: 24),
                  // ── New Words ─────────────────────────────────────────────
                  if (story.vocabItems.isNotEmpty) ...[
                    _SectionHeader(
                      icon: '📖',
                      label: 'අලුත් වචන',
                      isDark: isDark,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 12),
                    _VocabGrid(
                      items: story.vocabItems,
                      isDark: isDark,
                      surf: surf,
                      border: border,
                    ),
                    const SizedBox(height: 24),
                  ],
                  // ── Did you know? ─────────────────────────────────────────
                  if (story.didYouKnow != null) ...[
                    _DidYouKnowCard(
                      text: story.didYouKnow!,
                      isDark: isDark,
                      surf: surf,
                      border: border,
                      textColor: textColor,
                      muted: muted,
                    ),
                    const SizedBox(height: 24),
                  ],
                  // ── Moral ─────────────────────────────────────────────────
                  if (story.moralSinhala != null) ...[
                    _MoralCard(
                      moralSinhala: story.moralSinhala!,
                      moralEnglish: story.moralEnglish,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cover area ─────────────────────────────────────────────────────────────────
class _CoverArea extends StatelessWidget {
  const _CoverArea({
    required this.story,
    required this.isDark,
    required this.onBack,
  });
  final StoryItem story;
  final bool isDark;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: story.gradientColors,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Center(
                child: Text(
                  story.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              // Bottom gradient fade
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.40),
                      ],
                      stops: const [0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Back button (top-left safe area)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _IconBtn(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
                Row(
                  children: [
                    _IconBtn(icon: Icons.bookmark_border_rounded, onTap: () {}),
                    const SizedBox(width: 4),
                    _IconBtn(icon: Icons.share_rounded, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ── Audio player card ──────────────────────────────────────────────────────────
class _AudioPlayerCard extends StatelessWidget {
  const _AudioPlayerCard({
    required this.isDark,
    required this.surf,
    required this.border,
    required this.textColor,
    required this.muted,
    required this.isPlaying,
    required this.elapsed,
    required this.total,
    required this.onPlay,
    required this.onSkipBack,
    required this.onSkipForward,
    required this.fmtTime,
  });

  final bool isDark;
  final Color surf;
  final Color border;
  final Color textColor;
  final Color muted;
  final bool isPlaying;
  final int elapsed;
  final int total;
  final VoidCallback onPlay;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final String Function(int) fmtTime;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? elapsed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surf,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Time row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fmtTime(elapsed),
                  style: GoogleFonts.inter(
                      fontSize: 13, color: muted, fontWeight: FontWeight.w500)),
              Text(fmtTime(total),
                  style: GoogleFonts.inter(
                      fontSize: 13, color: muted, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: isDark
                  ? AppTheme.dHst
                  : const Color(0xFFE0E0E0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.oceanBlue),
            ),
          ),
          const SizedBox(height: 16),
          // Controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skip back 10s
              _SkipBtn(
                label: '10',
                icon: Icons.replay_10_rounded,
                onTap: onSkipBack,
                color: muted,
              ),
              const SizedBox(width: 24),
              // Play / Pause
              GestureDetector(
                onTap: onPlay,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFB0C4DE)
                        : const Color(0xFFBBD0EE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: isDark ? AppTheme.dText : AppTheme.lText,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Skip forward 10s
              _SkipBtn(
                label: '10',
                icon: Icons.forward_10_rounded,
                onTap: onSkipForward,
                color: muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkipBtn extends StatelessWidget {
  const _SkipBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 32, color: color),
    );
  }
}

// ── Story text (drop-cap first letter + expand/collapse) ───────────────────────
class _StoryTextSection extends StatelessWidget {
  const _StoryTextSection({
    required this.paragraphs,
    required this.expanded,
    required this.isDark,
    required this.textColor,
    required this.muted,
    required this.onExpand,
  });
  final List<String> paragraphs;
  final bool expanded;
  final bool isDark;
  final Color textColor;
  final Color muted;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final shown = expanded ? paragraphs : [paragraphs.first];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First paragraph with drop cap
        _DropCapParagraph(
          text: shown.first,
          isDark: isDark,
          textColor: textColor,
        ),
        // Additional paragraphs
        for (final p in shown.skip(1)) ...[
          const SizedBox(height: 14),
          Text(
            p,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 15,
              color: textColor,
              height: 1.7,
            ),
          ),
        ],
        const SizedBox(height: 12),
        // Expand / collapse
        GestureDetector(
          onTap: onExpand,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                expanded ? 'අඩු කරන්න  ∧' : 'දිගටම කියවන්න  ∨',
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 14,
                  color: AppTheme.oceanBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DropCapParagraph extends StatelessWidget {
  const _DropCapParagraph({
    required this.text,
    required this.isDark,
    required this.textColor,
  });
  final String text;
  final bool isDark;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    // Split at first character boundary
    final characters = text.characters;
    final firstChar = characters.first;
    final rest = characters.skip(1).string;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drop cap
        Container(
          width: 52,
          height: 52,
          margin: const EdgeInsets.only(right: 10, top: 2),
          decoration: const BoxDecoration(
            color: AppTheme.heritageRed,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              firstChar,
              style: GoogleFonts.notoSansSinhala(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
        ),
        // Rest of paragraph
        Expanded(
          child: Text(
            rest,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 15,
              color: textColor,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Vocabulary grid ────────────────────────────────────────────────────────────
class _VocabGrid extends StatelessWidget {
  const _VocabGrid({
    required this.items,
    required this.isDark,
    required this.surf,
    required this.border,
  });
  final List<VocabItem> items;
  final bool isDark;
  final Color surf;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        ...items.map((v) => _VocabChip(item: v)),
        // "See all" chip
        Container(
          decoration: BoxDecoration(
            color: surf,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded,
                    size: 16,
                    color: isDark ? AppTheme.dMuted : AppTheme.lMuted),
                const SizedBox(width: 4),
                Text(
                  'සියල්ල බලන්න',
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 12,
                    color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    fontWeight: FontWeight.w600,
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

class _VocabChip extends StatelessWidget {
  const _VocabChip({required this.item});
  final VocabItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.sinhala,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: item.color,
            ),
          ),
          Text(
            item.english,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: item.color.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.textColor,
  });
  final String icon;
  final String label;
  final bool isDark;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.notoSansSinhala(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

// ── Did you know card ──────────────────────────────────────────────────────────
class _DidYouKnowCard extends StatelessWidget {
  const _DidYouKnowCard({
    required this.text,
    required this.isDark,
    required this.surf,
    required this.border,
    required this.textColor,
    required this.muted,
  });
  final String text;
  final bool isDark;
  final Color surf;
  final Color border;
  final Color textColor;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surf,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ඔබ දන්නවාද?',
            style: GoogleFonts.notoSansSinhala(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 14,
              color: muted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Moral card ─────────────────────────────────────────────────────────────────
class _MoralCard extends StatelessWidget {
  const _MoralCard({
    required this.moralSinhala,
    this.moralEnglish,
    required this.isDark,
  });
  final String moralSinhala;
  final String? moralEnglish;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.dHigh, AppTheme.dHst]
              : [const Color(0xFFFFF8EC), const Color(0xFFFFF3E0)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.glowingAmber.withValues(alpha: 0.40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'ඉගෙනෙන්නට ඇති දෙය',
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.glowingAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            moralSinhala,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.dText : AppTheme.lText,
              height: 1.5,
            ),
          ),
          if (moralEnglish != null) ...[
            const SizedBox(height: 4),
            Text(
              moralEnglish!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
