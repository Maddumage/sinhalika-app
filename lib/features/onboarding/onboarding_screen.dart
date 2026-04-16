import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/providers/providers.dart';

// ── Page data ─────────────────────────────────────────────────────────────────
class _Page {
  const _Page({
    required this.tag,
    required this.title,
    required this.titleBlue,
    required this.body,
    required this.cta,
  });
  final String tag, title, titleBlue, body, cta;
}

List<_Page> _buildPages(AppLocalizations l10n) => [
  _Page(
    tag: l10n.onboardingPage1Tag,
    title: l10n.onboardingPage1Title,
    titleBlue: l10n.onboardingPage1TitleBlue,
    body: l10n.onboardingPage1Body,
    cta: l10n.onboardingCtaNext,
  ),
  _Page(
    tag: '',
    title: '',
    titleBlue: l10n.onboardingPage2TitleBlue,
    body: l10n.onboardingPage2Body,
    cta: l10n.onboardingCtaNext,
  ),
  _Page(
    tag: '',
    title: l10n.onboardingPage3Title,
    titleBlue: l10n.onboardingPage3TitleBlue,
    body: l10n.onboardingPage3Body,
    cta: l10n.onboardingCtaGetStarted,
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  void _markSeen() =>
      ref.read(sharedPrefsProvider).setBool('onboarding_seen', true);

  void _next(int pageCount) {
    if (_page < pageCount - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _markSeen();
      context.go('/sign-in');
    }
  }

  void _skip() {
    _markSeen();
    context.go('/sign-in');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final pages = _buildPages(l10n);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: pages.length,
            itemBuilder: (_, i) =>
                _PageView(page: pages[i], index: i, isDark: isDark),
          ),

          // Skip
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 20,
            child: TextButton(
              onPressed: _skip,
              style: TextButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF23262A)
                    : const Color(0xFFE9E6DE),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                l10n.onboardingSkip,
                style: GoogleFonts.inter(
                  color: isDark
                      ? const Color(0xFFAAABAF)
                      : const Color(0xFF77776F),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          // Dots + CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(pages.length, (i) {
                        final active = i == _page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999),
                            color: active
                                ? (isDark
                                      ? const Color(0xFF6CB2FD)
                                      : const Color(0xFF0067AD))
                                : (isDark
                                      ? const Color(0xFF46484B)
                                      : const Color(0xFFD0CEC5)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _next(pages.length),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(pages[_page].cta),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual page layout ────────────────────────────────────────────────────
class _PageView extends StatelessWidget {
  const _PageView({
    required this.page,
    required this.index,
    required this.isDark,
  });

  final _Page page;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration area
          SizedBox(
            width: size.width,
            height: size.width * 0.90,
            child: _Illustration(index: index),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: index == 2
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                // Tag chip
                if (page.tag.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.12),
                      border: Border.all(
                        color: const Color(0xFFFF9800).withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      page.tag,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFF9800),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                if (page.tag.isNotEmpty) const SizedBox(height: 16),

                // Title
                RichText(
                  textAlign: index == 2 ? TextAlign.center : TextAlign.start,
                  text: TextSpan(
                    children: [
                      if (page.title.isNotEmpty)
                        TextSpan(
                          text: page.title,
                          style: GoogleFonts.inter(
                            color: isDark
                                ? const Color(0xFFF9F9FD)
                                : const Color(0xFF383833),
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      TextSpan(
                        text: page.titleBlue,
                        style: GoogleFonts.inter(
                          color: isDark
                              ? const Color(0xFF6CB2FD)
                              : const Color(0xFF0067AD),
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Body
                Text(
                  page.body,
                  textAlign: index == 2 ? TextAlign.center : TextAlign.start,
                  style: GoogleFonts.inter(
                    color: isDark
                        ? const Color(0xFFAAABAF)
                        : const Color(0xFF77776F),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                // Stats row – page 3 only
                if (index == 2) ...[
                  const SizedBox(height: 28),
                  _StatsRow(isDark: isDark),
                ],

                // Extra space so CTA overlay doesn't overlap
                const SizedBox(height: 130),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Illustration widgets per page ─────────────────────────────────────────────
class _Illustration extends StatelessWidget {
  const _Illustration({required this.index});
  final int index;

  static const _images = [
    'assets/images/learning_kid.png',
    'assets/images/drawing_kid.png',
    'assets/images/study_room.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _images[index],
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

// ── Stats row (page 3) ───────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatItem(
          iconBg: const Color(0xFF3D2200),
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFFF9800),
          label: 'POINTS',
          value: '1,250',
          isDark: isDark,
        ),
        Container(
          width: 1,
          height: 48,
          color: isDark ? const Color(0xFF2E3035) : const Color(0xFFD0CEC5),
          margin: const EdgeInsets.symmetric(horizontal: 28),
        ),
        _StatItem(
          iconBg: const Color(0xFF3D0A0A),
          icon: Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFFF7161),
          label: 'STREAK',
          value: '7 Days',
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final Color iconBg, iconColor;
  final IconData icon;
  final String label, value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFFAAABAF)
                    : const Color(0xFF77776F),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFFF9F9FD)
                    : const Color(0xFF383833),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
