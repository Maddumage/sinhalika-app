import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/providers.dart';
import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _LetterData {
  const _LetterData({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.colorIndex, // 0=red 1=blue 2=green
  });
  final String letter;
  final String word;
  final String emoji;
  final int colorIndex;
}

const _letters = [
  _LetterData(letter: 'අ', word: 'අම්මා', emoji: '👩', colorIndex: 0),
  _LetterData(letter: 'ආ', word: 'ආච්චි', emoji: '👵', colorIndex: 1),
  _LetterData(letter: 'ඇ', word: 'ඇතා', emoji: '🐘', colorIndex: 2),
  _LetterData(letter: 'ඈ', word: 'ඈත', emoji: '🏔️', colorIndex: 0),
  _LetterData(letter: 'ඉ', word: 'ඉරු', emoji: '☀️', colorIndex: 0),
  _LetterData(letter: 'ඊ', word: 'ඊතලය', emoji: '🏹', colorIndex: 1),
  _LetterData(letter: 'උ', word: 'උයන', emoji: '🌿', colorIndex: 2),
  _LetterData(letter: 'ඌ', word: 'ඌරා', emoji: '🐗', colorIndex: 0),
  _LetterData(letter: 'එ', word: 'එළවළු', emoji: '🥦', colorIndex: 0),
  _LetterData(letter: 'ඒ', word: 'ඒකා', emoji: '🦁', colorIndex: 1),
  _LetterData(letter: 'ඔ', word: 'ඔරුව', emoji: '⛵', colorIndex: 2),
  _LetterData(letter: 'ඕ', word: 'ඕලු', emoji: '🌸', colorIndex: 0),
  _LetterData(letter: 'ඖ', word: 'ඖෂධ', emoji: '💊', colorIndex: 1),
  _LetterData(letter: 'අං', word: 'අංශය', emoji: '🔢', colorIndex: 2),
  _LetterData(letter: 'අඃ', word: 'අඃස්ථාන', emoji: '📍', colorIndex: 0),
  _LetterData(letter: 'ක', word: 'කළු', emoji: '⚫', colorIndex: 1),
  _LetterData(letter: 'ඛ', word: 'ඛනිජ', emoji: '💎', colorIndex: 2),
  _LetterData(letter: 'ග', word: 'ගස', emoji: '🌳', colorIndex: 0),
  _LetterData(letter: 'ඝ', word: 'ඝෝෂා', emoji: '🔊', colorIndex: 1),
  _LetterData(letter: 'ච', word: 'චොකලට්', emoji: '🍫', colorIndex: 2),
  _LetterData(letter: 'ජ', word: 'ජලය', emoji: '💧', colorIndex: 0),
  _LetterData(letter: 'ට', word: 'ටෙලිෆෝන', emoji: '📞', colorIndex: 1),
  _LetterData(letter: 'ඩ', word: 'ඩොල්ෆින්', emoji: '🐬', colorIndex: 2),
  _LetterData(letter: 'ත', word: 'තරු', emoji: '⭐', colorIndex: 0),
  _LetterData(letter: 'ද', word: 'දව', emoji: '🌅', colorIndex: 1),
  _LetterData(letter: 'න', word: 'නෙළුම', emoji: '🪷', colorIndex: 2),
  _LetterData(letter: 'ප', word: 'පොත', emoji: '📖', colorIndex: 0),
  _LetterData(letter: 'බ', word: 'බල්ලා', emoji: '🐕', colorIndex: 1),
  _LetterData(letter: 'ම', word: 'මල', emoji: '🌺', colorIndex: 2),
  _LetterData(letter: 'ය', word: 'යතුර', emoji: '🗝️', colorIndex: 0),
  _LetterData(letter: 'ර', word: 'රෝදය', emoji: '🎡', colorIndex: 1),
  _LetterData(letter: 'ල', word: 'ලිය', emoji: '🦚', colorIndex: 2),
  _LetterData(letter: 'ව', word: 'වලිගය', emoji: '🦊', colorIndex: 0),
  _LetterData(letter: 'ස', word: 'සෙල්ලම', emoji: '🎮', colorIndex: 1),
  _LetterData(letter: 'හ', word: 'හදවත', emoji: '❤️', colorIndex: 2),
];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class HodiyaScreen extends ConsumerStatefulWidget {
  const HodiyaScreen({super.key});

  @override
  ConsumerState<HodiyaScreen> createState() => _HodiyaScreenState();
}

class _HodiyaScreenState extends ConsumerState<HodiyaScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
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
    final start = (index * 0.04).clamp(0.0, 0.9);
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
          SliverToBoxAdapter(child: _buildHeroBanner(isDark)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                return _FadeSlide(
                  animation: _stagger(i + 2),
                  child: _LetterCard(
                    data: _letters[i],
                    isDark: isDark,
                    onSpeak: (text) => ref.read(ttsServiceProvider).speak(text),
                  ),
                );
              }, childCount: _letters.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
            ),
          ),
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
        'සිංහල හෝඩිය',
        style: GoogleFonts.notoSansSinhala(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppTheme.heritageRed,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: isDark ? AppTheme.dText : AppTheme.lText,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroBanner(bool isDark) {
    return _FadeSlide(
      animation: _stagger(0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A1A1A) : const Color(0xFFFDE8E8),
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
                    Text(
                      'අකුරු හදනාගමු',
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 12,
                        color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ලස්සන සිංහල\nහෝඩිය ඉගෙන ගමු',
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.heritageRed,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.dHigh : const Color(0xFFFFD6D6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('📚', style: TextStyle(fontSize: 36)),
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
// Letter card
// ─────────────────────────────────────────────────────────────────────────────

class _LetterCard extends StatelessWidget {
  const _LetterCard({
    required this.data,
    required this.isDark,
    required this.onSpeak,
  });
  final _LetterData data;
  final bool isDark;
  final void Function(String text) onSpeak;

  Color get _letterColor {
    switch (data.colorIndex) {
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
    return _TapScale(
      onTap: () {
        HapticFeedback.lightImpact();
        onSpeak(data.letter);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
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
        child: Stack(
          children: [
            // Large letter centre
            Center(
              child: Text(
                data.letter,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: _letterColor,
                ),
              ),
            ),
            // Volume button top-right
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSpeak('${data.letter} ${data.word}');
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.neonCoral,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Emoji illustration bottom-left
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.dHst : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(data.emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
            ),
            // Word label bottom-right
            Positioned(
              bottom: 12,
              right: 12,
              child: Text(
                data.word,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
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
// Shared animation helpers (local copies so screens are self-contained)
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
