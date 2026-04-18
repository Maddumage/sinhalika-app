import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../theme/app_theme.dart';

// Which sign-in method was chosen before entering this screen
enum AuthMethod { google, guest }

class TermsAndConditionsScreen extends ConsumerStatefulWidget {
  const TermsAndConditionsScreen({super.key, required this.authMethod});

  final AuthMethod authMethod;

  @override
  ConsumerState<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState
    extends ConsumerState<TermsAndConditionsScreen> {
  bool _loading = false;

  Future<void> _agree() async {
    setState(() => _loading = true);
    try {
      if (widget.authMethod == AuthMethod.google) {
        await AuthService.instance.signInWithGoogle();
      } else {
        await AuthService.instance.signInAsGuest();
      }
      // Router redirect handles navigation to /home
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reject() => context.pop();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                    onPressed: _reject,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'සේවා නියමයන්',
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.dText : AppTheme.lText,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Scroll image placeholder
                    _ScrollIllustration(isDark: isDark),

                    const SizedBox(height: 24),

                    // Terms card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.dLow : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.dHst
                              : const Color(0xFFE8E4DC),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _TermsSection(
                            heading: 'කොන්දේසි පිළිගැනීම',
                            body:
                                'මෙම යෙදුම භාවිතා කිරීමෙන් ඔබ අපගේ සේවා කොන්දේසි වලට එකගව සිටින බව සලකන්න. අපගේ ශිෂ්‍යත්ව මෙවලම් භාවිතා කිරීමේදී ඔබ මෙම නීති රීති අනුගමනය කළ යුතුය. ඔබ මෙම කොන්දේසි වලට එකග නොවන්නේ නම්, කරුණාකර මෙම සේවාව භාවිතා කිරීමෙන් වළකින්න.',
                          ),
                          SizedBox(height: 20),
                          _TermsSection(
                            heading: 'පෞද්ගලිකත්වය',
                            body:
                                'ඔබේ දත්තවල රහස්‍යභාවය අපට ඉතා වැදගත් වේ. දරුවන්ගේ ආරක්ෂාව සහ පෞද්ගලිකත්වය තහවුරු කිරීම සඳහා අපි ජාත්‍යන්තර ප්‍රමිතීන් අනුගමනය කරන්නෙමු. අපි කිසිවිටෙකත් ඔබේ තොරතුරු තෙවන පාර්ශවයකට අලෙව් නොකරන්නෙමු.',
                          ),
                          SizedBox(height: 20),
                          _TermsSection(
                            heading: 'පරිශීලක හැසිරීම',
                            body:
                                'මෙම යෙදුම ඉගෙනුම් කටයුතු සඳහා පමණක් භාවිතා කළ යුතුය. වෙනත් පරිශීලකයින්ට බාධාවක් වන අයුරින් හෝ අනිසි ලෙස පද්ධතිය භාවිතා කිරීම තහනම් වේ. යහපත් ඉගෙනුම් පරිසරයක් පවත්වා ගැනීමට ඔබේ සහයෝගය බලාපොරොත්තු වෙමු.',
                          ),
                          SizedBox(height: 20),
                          _TermsSection(
                            heading: 'බුද්ධිමය දේපළ',
                            body:
                                'යෙදුමෙහි ඇති සියලුම පාඩම් මාලා, රූප සටහන් සහ මාදිලාංශ ශේෂය අප සතු බුද්ධිමය දේපළ වේ. මෙවා අනවසරයෙන් පිටපත් කිරීම හෝ වාණිජ අරමුණු සඳහා භාවිතා කිරීම නීතියෙන් දඩුවම් ලැබිය හැකි වරදකි.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Last updated footer
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'අවසන් වරට යාවත්කාලීන කළේ: 2024 මැයි',
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Bottom buttons ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.dBg : AppTheme.lBg,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Agree — filled
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _loading ? null : _agree,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.oceanBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        textStyle: GoogleFonts.notoSansSinhala(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'එකගයි',
                              style: GoogleFonts.notoSansSinhala(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Reject — outlined
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _loading ? null : _reject,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDark
                              ? AppTheme.dMuted
                              : const Color(0xFFAAABAF),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(
                        'ප්‍රතික්ෂේප කරන්න',
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section widget ────────────────────────────────────────────────────────────
class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.heritageRed,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                heading,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.dText : AppTheme.lText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            body,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 13.5,
              height: 1.7,
              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Scroll illustration placeholder ──────────────────────────────────────────
class _ScrollIllustration extends StatelessWidget {
  const _ScrollIllustration({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 110,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dHigh : const Color(0xFFF0EBE0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFE0D8CC),
          width: 1.5,
        ),
      ),
      child: const Center(child: Text('📜', style: TextStyle(fontSize: 56))),
    );
  }
}
