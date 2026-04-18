import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/celebration_item.dart';
import '../../theme/app_theme.dart';
import 'data/celebrations_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CelebrationsScreen — Sri Lankan cultural festivals
// Design: vertical list of colored cards, image area, "වැඩි විස්තර" button
// ─────────────────────────────────────────────────────────────────────────────

class CelebrationsScreen extends StatelessWidget {
  const CelebrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AppBar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'උත්සව',
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.search_rounded, size: 24, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // ── Subtitle ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ශ්‍රී ලංකාවේ පූර්ණ සංස්කෘතික උත්සව ගැන ඉගෙනෙනු ලබයි!',
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 13,
                  color: muted,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // ── Celebrations list ─────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: celebrationItems.length,
                separatorBuilder: (context, i) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  return _CelebrationCard(
                    item: celebrationItems[i],
                    isFirst: i == 0,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.heritageRed,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.search_rounded, size: 26),
      ),
    );
  }
}

// ── Celebration card ───────────────────────────────────────────────────────────
class _CelebrationCard extends StatefulWidget {
  const _CelebrationCard({
    required this.item,
    required this.isFirst,
    required this.isDark,
  });
  final CelebrationItem item;
  final bool isFirst;
  final bool isDark;

  @override
  State<_CelebrationCard> createState() => _CelebrationCardState();
}

class _CelebrationCardState extends State<_CelebrationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.97,
    upperBound: 1.0,
    value: 1.0,
  );

  bool _expanded = false;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final accentColor = item.gradientColors.first;
    final surf = widget.isDark ? AppTheme.dHigh : Colors.white;
    final textColor = widget.isDark ? AppTheme.dText : AppTheme.lText;
    final muted = widget.isDark ? AppTheme.dMuted : AppTheme.lMuted;

    return ScaleTransition(
      scale: _press,
      child: GestureDetector(
        onTapDown: (_) => _press.reverse(),
        onTapUp: (_) {
          _press.forward();
          HapticFeedback.lightImpact();
          setState(() => _expanded = !_expanded);
        },
        onTapCancel: () => _press.forward(),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: surf,
            borderRadius: BorderRadius.circular(22),
            boxShadow: widget.isDark
                ? null
                : [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner image area ──────────────────────────────────────
              _BannerArea(item: item, isDark: widget.isDark),
              // ── Content ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nameSinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.descriptionSinhala,
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 13,
                        color: muted,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Month & details row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 14,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.monthSinhala,
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 12,
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        // "More details" button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _expanded = !_expanded);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: widget.isFirst
                                  ? AppTheme.heritageRed
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: widget.isFirst
                                  ? null
                                  : Border.all(
                                      color: widget.isDark
                                          ? AppTheme.dHst
                                          : const Color(0xFFCCCCCC),
                                    ),
                            ),
                            child: Text(
                              'වැඩි විස්තර',
                              style: GoogleFonts.notoSansSinhala(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: widget.isFirst ? Colors.white : muted,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Expanded extra content
                    if (_expanded) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      if (item.cultureFacts.isNotEmpty) ...[
                        Text(
                          'සාංස්කෘතික කරුණු',
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...item.cultureFacts.map(
                          (fact) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(
                                    top: 6,
                                    right: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    fact,
                                    style: GoogleFonts.notoSansSinhala(
                                      fontSize: 12,
                                      color: muted,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (item.activitySinhala != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text('🎯', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.activitySinhala!,
                                  style: GoogleFonts.notoSansSinhala(
                                    fontSize: 13,
                                    color: accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Banner image area with gradient background ─────────────────────────────────
class _BannerArea extends StatelessWidget {
  const _BannerArea({required this.item, required this.isDark});
  final CelebrationItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = item.gradientColors;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -35,
            left: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Month chip (top-left)
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.monthSinhala,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Central emoji
          Center(child: Text(item.emoji, style: const TextStyle(fontSize: 72))),
          // Bottom gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.20),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
