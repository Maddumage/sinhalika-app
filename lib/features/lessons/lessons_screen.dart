import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lessons',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 64,
              color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
            ),
            const SizedBox(height: 16),
            Text(
              'Lessons Coming Soon',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interactive Sinhala lessons\nare on their way.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
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
