import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../theme/app_theme.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  static const _categories = [
    (
      emoji: '📖',
      route: '/lessons/hodiya',
      accentLight: Color(0xFFFDE8E8),
      accentDark: Color(0xFF2A1A1A),
      textColor: AppTheme.heritageRed,
    ),
    (
      emoji: '🌿',
      route: '/lessons/nouns',
      accentLight: Color(0xFFE8F0FE),
      accentDark: Color(0xFF0A1A2E),
      textColor: AppTheme.oceanBlue,
    ),
    (
      emoji: '💬',
      route: '/lessons/phrases',
      accentLight: Color(0xFFE8F5E9),
      accentDark: Color(0xFF0A1F0D),
      textColor: Color(0xFF2E7D32),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final titles = [
      (title: l10n.lessonCategoryAlphabetTitle, subtitle: l10n.lessonCategoryAlphabetSubtitle),
      (title: l10n.lessonCategoryNounsTitle, subtitle: l10n.lessonCategoryNounsSubtitle),
      (title: l10n.lessonCategoryPhrasesTitle, subtitle: l10n.lessonCategoryPhrasesSubtitle),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
      appBar: AppBar(
        title: Text(
          l10n.lessonsScreenTitle,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.dText : AppTheme.lText,
          ),
        ),
        backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            l10n.lessonsScreenSubheading,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.dText : AppTheme.lText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(_categories.length, (i) {
            final cat = _categories[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _LessonCard(
                title: titles[i].title,
                subtitle: titles[i].subtitle,
                emoji: cat.emoji,
                accentColor: isDark ? cat.accentDark : cat.accentLight,
                textColor: cat.textColor,
                onTap: () => context.push(cat.route),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.accentColor,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final Color accentColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: textColor),
          ],
        ),
      ),
    );
  }
}
