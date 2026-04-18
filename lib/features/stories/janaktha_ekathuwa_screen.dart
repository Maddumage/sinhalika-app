import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/story_item.dart';
import '../../theme/app_theme.dart';
import 'data/stories_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// JanakthaEkathuwaScreen  — Folk Tales Collection
// Design: search bar + category chips + story cards with image area
// ─────────────────────────────────────────────────────────────────────────────

class JanakthaEkathuwaScreen extends StatefulWidget {
  const JanakthaEkathuwaScreen({super.key});

  @override
  State<JanakthaEkathuwaScreen> createState() => _JanakthaEkathuwaScreenState();
}

class _JanakthaEkathuwaScreenState extends State<JanakthaEkathuwaScreen> {
  StoryCategory? _selectedCategory; // null = all
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<StoryItem> get _filtered {
    return storyItems.where((s) {
      final matchCat =
          _selectedCategory == null || s.category == _selectedCategory;
      final matchQ =
          _query.isEmpty ||
          s.titleSinhala.contains(_query) ||
          s.titleEnglish.toLowerCase().contains(_query.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final surf = isDark ? AppTheme.dHigh : AppTheme.lSurf;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final border = isDark ? AppTheme.dHst : const Color(0xFFE8E4DC);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22,
                      color: AppTheme.heritageRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ජනකතා එකතුව',
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.heritageRed,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isDark
                        ? AppTheme.dHigh
                        : const Color(0xFFE8E4DC),
                    child: Icon(Icons.person_rounded, color: muted, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 14,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'කතාවක් සොයන්න...',
                  hintStyle: GoogleFonts.notoSansSinhala(
                    fontSize: 14,
                    color: muted,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: muted,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: surf,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppTheme.heritageRed,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ── Category chips ───────────────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryChip(
                    label: 'සියල්ල',
                    selected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null),
                  ),
                  const SizedBox(width: 8),
                  ...StoryCategory.values.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        label: cat.sinhalaLabel,
                        selected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ── Story list ───────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: _filtered.length,
                separatorBuilder: (context, i) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final story = _filtered[i];
                  final isFeatured =
                      i == 0 && _selectedCategory == null && _query.isEmpty;
                  return _StoryCard(
                    story: story,
                    isFeatured: isFeatured,
                    isDark: isDark,
                    onTap: () => context.push('/stories/details', extra: story),
                    onListen: () =>
                        context.push('/stories/details', extra: story),
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

// ── Category chip ──────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.heritageRed : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.heritageRed : const Color(0xFFCCCCCC),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSansSinhala(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}

// ── Story card ─────────────────────────────────────────────────────────────────
class _StoryCard extends StatefulWidget {
  const _StoryCard({
    required this.story,
    required this.isFeatured,
    required this.isDark,
    required this.onTap,
    required this.onListen,
  });
  final StoryItem story;
  final bool isFeatured;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onListen;

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.96,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surf = widget.isDark ? AppTheme.dHigh : AppTheme.lSurf;
    final border = widget.isDark ? AppTheme.dHst : const Color(0xFFE8E4DC);
    final textColor = widget.isDark ? AppTheme.dText : AppTheme.lText;
    final muted = widget.isDark ? AppTheme.dMuted : AppTheme.lMuted;

    return ScaleTransition(
      scale: _press,
      child: GestureDetector(
        onTapDown: (_) => _press.reverse(),
        onTapUp: (_) {
          _press.forward();
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        onTapCancel: () => _press.forward(),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: surf,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: widget.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area ─────────────────────────────────────────────
              Stack(
                children: [
                  _StoryImage(
                    gradientColors: widget.story.gradientColors,
                    emoji: widget.story.emoji,
                    height: 180,
                  ),
                  // Featured badge (top-right)
                  if (widget.isFeatured)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFFF9800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'පිතාමය',
                              style: GoogleFonts.notoSansSinhala(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Category badge (top-left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.story.category.sinhalaLabel,
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ── Content ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.story.titleSinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.story.descriptionSinhala,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 13,
                        color: muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        // Listen button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              widget.onListen();
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.heritageRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'සවන් දෙනා',
                                    style: GoogleFonts.notoSansSinhala(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Book icon
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            widget.onTap();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 20,
                              color: muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Reading time
                        Icon(Icons.schedule_rounded, size: 14, color: muted),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.story.readingMinutes} min',
                          style: GoogleFonts.inter(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
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

// ── Gradient image placeholder ─────────────────────────────────────────────────
class _StoryImage extends StatelessWidget {
  const _StoryImage({
    required this.gradientColors,
    required this.emoji,
    required this.height,
  });
  final List<Color> gradientColors;
  final String emoji;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Center(child: Text(emoji, style: const TextStyle(fontSize: 72))),
        ],
      ),
    );
  }
}
