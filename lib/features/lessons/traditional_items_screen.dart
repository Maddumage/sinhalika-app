import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/traditional_game_item.dart';
import '../../theme/app_theme.dart';
import '../games/data/games_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TraditionalItemsScreen — Sri Lankan cultural heritage items under Lessons
// Moved from GamesScreen so Games stays focused on interactive games only
// ─────────────────────────────────────────────────────────────────────────────

class TraditionalItemsScreen extends StatefulWidget {
  const TraditionalItemsScreen({super.key});

  @override
  State<TraditionalItemsScreen> createState() => _TraditionalItemsScreenState();
}

class _TraditionalItemsScreenState extends State<TraditionalItemsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  GameCategory? _selectedCategory;
  String _query = '';

  static const List<_FilterChipData> _filters = [
    _FilterChipData(null, 'සියල්ල'),
    _FilterChipData(GameCategory.games, 'ක්‍රීඩා'),
    _FilterChipData(GameCategory.arts, 'කලා'),
    _FilterChipData(GameCategory.food, 'ආහාර'),
    _FilterChipData(GameCategory.dance, 'නැටුම්'),
    _FilterChipData(GameCategory.ritual, 'චාරිත්‍ර'),
  ];

  List<TraditionalGameItem> get _filtered {
    return traditionalGames.where((g) {
      final matchCat =
          _selectedCategory == null || g.category == _selectedCategory;
      final matchQuery =
          _query.isEmpty ||
          g.titleSinhala.contains(_query) ||
          g.titleEnglish.toLowerCase().contains(_query.toLowerCase()) ||
          g.descriptionSinhala.contains(_query);
      return matchCat && matchQuery;
    }).toList();
  }

  TraditionalGameItem? get _featured {
    final items = _filtered;
    if (items.isEmpty) return null;
    return items.firstWhere((g) => g.isFeatured, orElse: () => items.first);
  }

  List<TraditionalGameItem> get _listItems =>
      _filtered.where((g) => !g.isFeatured).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;
    final filtered = _filtered;
    final featured = _featured;
    final listItems = _listItems;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── AppBar ─────────────────────────────────────────────────────
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
                      child: Text(
                        'සංස්කෘතිය',
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: surfColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(Icons.search_rounded, size: 20, color: muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v),
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 14,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'සොයන්න, සොයන්න...',
                            hintStyle: GoogleFonts.notoSansSinhala(
                              fontSize: 14,
                              color: muted,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      Icon(Icons.mic_rounded, size: 20, color: muted),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ),
            ),

            // ── Filter chips ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = _filters[i];
                    final selected = _selectedCategory == f.category;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategory = f.category);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppTheme.heritageRed : surfColor,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: selected
                                ? AppTheme.heritageRed
                                : (isDark
                                      ? AppTheme.dHst
                                      : const Color(0xFFE0DCD4)),
                          ),
                        ),
                        child: Text(
                          f.label,
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : (isDark ? AppTheme.dText : AppTheme.lText),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 18)),

            // ── Featured card ──────────────────────────────────────────────
            if (featured != null && filtered.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _FeaturedCard(item: featured, isDark: isDark),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Items list ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList.separated(
                itemCount: listItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) =>
                    _TraditionalListItem(item: listItems[i], isDark: isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FilterChipData
// ─────────────────────────────────────────────────────────────────────────────
class _FilterChipData {
  const _FilterChipData(this.category, this.label);
  final GameCategory? category;
  final String label;
}

// ─────────────────────────────────────────────────────────────────────────────
// _FeaturedCard — large hero card at the top
// ─────────────────────────────────────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.isDark});
  final TraditionalGameItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF1A1208) : const Color(0xFFFFF8EE),
        border: Border.all(
          color: isDark ? const Color(0xFF332810) : const Color(0xFFEDD9A3),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.glowingAmber.withValues(
                  alpha: isDark ? 0.06 : 0.08,
                ),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.heritageRed.withValues(
                  alpha: isDark ? 0.05 : 0.07,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: AppTheme.heritageRed,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'ජනප්‍රිය',
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.titleSinhala,
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppTheme.dText : AppTheme.lText,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.descriptionSinhala,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 12,
                          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => HapticFeedback.lightImpact(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.heritageRed,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            'වැඩිදේ දෙස් »',
                            style: GoogleFonts.notoSansSinhala(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (item.imageAsset != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item.imageAsset!,
                      width: 110,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 110,
                    height: 130,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.dHst : const Color(0xFFEDE8D8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.sports_esports_rounded,
                      size: 48,
                      color: AppTheme.glowingAmber,
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

// ─────────────────────────────────────────────────────────────────────────────
// _TraditionalListItem — horizontal card with thumbnail, info, and add button
// ─────────────────────────────────────────────────────────────────────────────
class _TraditionalListItem extends StatelessWidget {
  const _TraditionalListItem({required this.item, required this.isDark});
  final TraditionalGameItem item;
  final bool isDark;

  Color get _categoryColor {
    switch (item.category) {
      case GameCategory.games:
        return const Color(0xFF2E7D32);
      case GameCategory.arts:
        return AppTheme.heritageRed;
      case GameCategory.food:
        return AppTheme.glowingAmber;
      case GameCategory.dance:
        return AppTheme.oceanBlue;
      case GameCategory.ritual:
        return const Color(0xFF6A1B9A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;
    final surfColor = isDark ? AppTheme.dHigh : AppTheme.lSurf;

    return Container(
      decoration: BoxDecoration(
        color: surfColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: item.imageAsset != null
                      ? Image.asset(
                          item.imageAsset!,
                          width: 88,
                          height: 88,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.dHst
                                : const Color(0xFFEDE8D8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.image_rounded,
                            size: 36,
                            color: isDark
                                ? AppTheme.dMuted
                                : const Color(0xFFAFA89C),
                          ),
                        ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _categoryColor,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: _categoryColor.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item.categoryLabelSinhala,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titleSinhala,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.descriptionSinhala,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 12,
                      color: muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 14,
                        color: muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.viewCountLabel} views',
                        style: GoogleFonts.inter(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
            child: GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
