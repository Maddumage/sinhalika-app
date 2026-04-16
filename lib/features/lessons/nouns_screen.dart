import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/adapters/content_adapter.dart';
import '../../core/models/noun_item.dart';
import '../../core/providers/content_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'data/nouns_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class NounsScreen extends ConsumerStatefulWidget {
  const NounsScreen({super.key});

  @override
  ConsumerState<NounsScreen> createState() => _NounsScreenState();
}

class _NounsScreenState extends ConsumerState<NounsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

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
    final start = (index * 0.06).clamp(0.0, 0.9);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final displayList = ref.watch(nounDisplayListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
      floatingActionButton: _SearchFab(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDark, l10n),
          SliverToBoxAdapter(
            child: _FadeSlide(
              animation: _stagger(0),
              child: _buildHeroBanner(isDark, l10n),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _FadeSlide(
                    animation: _stagger(i + 1),
                    child: _NounCard(
                      noun: nounItems[i],
                      isDark: isDark,
                      display: displayList[i],
                      onSpeak: (text, audioPath) {
                        if (audioPath != null) {
                          ref.read(audioServiceProvider).play(audioPath);
                        } else {
                          ref.read(ttsServiceProvider).speak(text);
                        }
                      },
                    ),
                  ),
                ),
                childCount: nounItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(bool isDark, AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: (isDark ? AppTheme.dBg : AppTheme.lBg).withValues(
        alpha: 0.95,
      ),
      leading: BackButton(color: isDark ? AppTheme.dText : AppTheme.lText),
      title: Text(
        l10n.nounsScreenTitle,
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

  Widget _buildHeroBanner(bool isDark, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0A1A2E) : const Color(0xFFE8F0FE),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.electricBlue.withValues(alpha: 0.2)
                          : AppTheme.oceanBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.nounsBannerChip,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppTheme.electricBlue
                            : AppTheme.oceanBlue,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.lessonCategoryNounsTitle,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                  ),
                  Text(
                    l10n.nounsBannerTitle,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.nounsBannerDescription,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('🌿📚', style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Noun card — multi-style renderer
// ─────────────────────────────────────────────────────────────────────────────

class _NounCard extends StatelessWidget {
  const _NounCard({
    required this.noun,
    required this.isDark,
    required this.display,
    required this.onSpeak,
  });
  final NounItem noun;
  final bool isDark;
  final NounDisplay display;
  final void Function(String ttsText, String? audioPath) onSpeak;

  Color get _accent => noun.accentColor ?? AppTheme.oceanBlue;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: () {
        HapticFeedback.lightImpact();
        onSpeak(display.ttsText, display.audioPath);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: _buildCardContent(context, display),
      ),
    );
  }

  Color get _cardBackground {
    switch (noun.style) {
      case NounCardStyle.imageTop:
        return isDark ? const Color(0xFF1A1016) : const Color(0xFFFDE8E8);
      case NounCardStyle.tinted:
        final color = noun.accentColor ?? AppTheme.oceanBlue;
        return isDark
            ? color.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.08);
      default:
        return isDark ? AppTheme.dHigh : AppTheme.lSurf;
    }
  }

  Widget _buildCardContent(BuildContext context, NounDisplay display) {
    switch (noun.style) {
      case NounCardStyle.imageTop:
        return _ImageTopCard(
          noun: noun,
          isDark: isDark,
          accent: _accent,
          display: display,
          onSpeak: onSpeak,
        );
      case NounCardStyle.withExample:
        return _WithExampleCard(
          noun: noun,
          isDark: isDark,
          accent: _accent,
          display: display,
          onSpeak: onSpeak,
        );
      case NounCardStyle.tinted:
        return _TintedCard(
          noun: noun,
          isDark: isDark,
          accent: _accent,
          display: display,
          onSpeak: onSpeak,
        );
      default:
        return _PlainCard(
          noun: noun,
          isDark: isDark,
          accent: _accent,
          display: display,
          onSpeak: onSpeak,
        );
    }
  }
}

// Style A — plain white/dark card
class _PlainCard extends StatelessWidget {
  const _PlainCard({
    required this.noun,
    required this.isDark,
    required this.accent,
    required this.display,
    required this.onSpeak,
  });
  final NounItem noun;
  final bool isDark;
  final Color accent;
  final NounDisplay display;
  final void Function(String ttsText, String? audioPath) onSpeak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noun.sinhala,
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
                Text(
                  noun.english,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.dText : AppTheme.lText,
                  ),
                ),
                if (display.transliteration != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    display.transliteration!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSpeak(display.ttsText, display.audioPath);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Style B — image-top card (big emoji fills top half)
class _ImageTopCard extends StatelessWidget {
  const _ImageTopCard({
    required this.noun,
    required this.isDark,
    required this.accent,
    required this.display,
    required this.onSpeak,
  });
  final NounItem noun;
  final bool isDark;
  final Color accent;
  final NounDisplay display;
  final void Function(String ttsText, String? audioPath) onSpeak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.dHst : accent.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Center(
            child: Text(noun.emoji, style: const TextStyle(fontSize: 64)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noun.sinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                    Text(
                      noun.english,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                      ),
                    ),
                    if (display.transliteration != null)
                      Text(
                        display.transliteration!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSpeak(display.ttsText, display.audioPath);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent,
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
      ],
    );
  }
}

// Style C — with example sentence + Listen button
class _WithExampleCard extends StatelessWidget {
  const _WithExampleCard({
    required this.noun,
    required this.isDark,
    required this.accent,
    required this.display,
    required this.onSpeak,
  });
  final NounItem noun;
  final bool isDark;
  final Color accent;
  final NounDisplay display;
  final void Function(String ttsText, String? audioPath) onSpeak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dHst : accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(noun.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noun.sinhala,
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
                Text(
                  noun.english,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.dText : AppTheme.lText,
                  ),
                ),
                if (display.exampleLine != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    display.exampleLine!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      onSpeak(display.ttsText, display.audioPath);
                    },
                    icon: const Icon(Icons.hearing_rounded, size: 16),
                    label: Text(
                      l10n.nounsListenButton,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accent,
                      side: BorderSide(color: accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Style D — tinted card
class _TintedCard extends StatelessWidget {
  const _TintedCard({
    required this.noun,
    required this.isDark,
    required this.accent,
    required this.display,
    required this.onSpeak,
  });
  final NounItem noun;
  final bool isDark;
  final Color accent;
  final NounDisplay display;
  final void Function(String ttsText, String? audioPath) onSpeak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(noun.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noun.sinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                    Text(
                      noun.english,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                      ),
                    ),
                    if (display.transliteration != null)
                      Text(
                        display.transliteration!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                onSpeak(display.ttsText, display.audioPath);
              },
              icon: const Icon(Icons.volume_up_rounded, size: 18),
              label: Text(
                'Hear Pronunciation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
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
