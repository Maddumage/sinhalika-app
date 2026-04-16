import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../theme/app_theme.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.gamesScreenTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_rounded,
              size: 64,
              color: AppTheme.glowingAmber,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.gamesComingSoonTitle,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.gamesComingSoonSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
