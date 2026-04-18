import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GamesScreen — Interactive mini-games hub
// Traditional cultural items have been moved to Lessons > Traditional Items
// ─────────────────────────────────────────────────────────────────────────────

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.dBg : AppTheme.lBg;
    final textColor = isDark ? AppTheme.dText : AppTheme.lText;
    final muted = isDark ? AppTheme.dMuted : AppTheme.lMuted;

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
                    Icon(
                      Icons.sports_esports_rounded,
                      size: 28,
                      color: AppTheme.electricBlue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ක්‍රීඩා',
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

            // ── Heading ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Interactive ',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Games',
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
                    const SizedBox(height: 6),
                    Text(
                      'Learn Sinhala through play — choose a game and start your adventure!',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Game cards ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList.separated(
                itemCount: _gameEntries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final g = _gameEntries[i];
                  return _GameCard(entry: g, isDark: isDark);
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
// Game entry data
// ─────────────────────────────────────────────────────────────────────────────
class _GameEntry {
  const _GameEntry({
    required this.emoji,
    required this.title,
    required this.titleSinhala,
    required this.description,
    required this.levelLabel,
    required this.accentColor,
    required this.bgDark,
    required this.bgLight,
    required this.route,
  });

  final String emoji;
  final String title;
  final String titleSinhala;
  final String description;
  final String levelLabel;
  final Color accentColor;
  final Color bgDark;
  final Color bgLight;
  final String route;
}

const List<_GameEntry> _gameEntries = [
  _GameEntry(
    emoji: '🔤',
    title: 'Match the Words',
    titleSinhala: 'ශබ්ද ගැළපීම',
    description:
        'Drag Sinhala word blocks onto their matching picture cards. '
        'Test your vocabulary across 5 themed levels!',
    levelLabel: '5 levels · Drag & Drop',
    accentColor: AppTheme.electricBlue,
    bgDark: Color(0xFF0D2137),
    bgLight: Color(0xFFEAF3FF),
    route: '/games/match-words',
  ),
  _GameEntry(
    emoji: '✏️',
    title: 'Letter Drawing',
    titleSinhala: 'අකුරු ඇදීම',
    description:
        'Trace the glowing guide paths to learn how to write Sinhala letters. '
        'Complete 5 progressive lessons with accuracy tracking!',
    levelLabel: '5 lessons · Trace & Learn',
    accentColor: AppTheme.glowingAmber,
    bgDark: Color(0xFF1A1000),
    bgLight: Color(0xFFFFF8E1),
    route: '/games/letter-drawing',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// _GameCard — full-detail card for each interactive game
// ─────────────────────────────────────────────────────────────────────────────
class _GameCard extends StatelessWidget {
  const _GameCard({required this.entry, required this.isDark});
  final _GameEntry entry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(entry.route);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? entry.bgDark : entry.bgLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: entry.accentColor.withValues(alpha: isDark ? 0.25 : 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: entry.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      entry.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppTheme.lText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.titleSinhala,
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 14,
                          color: entry.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: entry.accentColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: entry.accentColor,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              entry.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.6)
                    : AppTheme.lMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: entry.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: entry.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                entry.levelLabel,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: entry.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
