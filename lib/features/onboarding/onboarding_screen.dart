import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

const _pages = [
  _Page(
    tag: 'AYUBOWAN',
    title: 'Explore the\n',
    titleBlue: 'Magic of\nSinhala',
    body:
        'Start a journey through stories, games, and traditional Sri Lankan culture.',
    cta: 'Next',
  ),
  _Page(
    tag: '',
    title: '',
    titleBlue: 'Learning\nis Play',
    body:
        'Master vocabulary and verbs through interactive games designed for kids.',
    cta: 'Next',
  ),
  _Page(
    tag: '✦  Learn with Magic',
    title: 'Sinhala ',
    titleBlue: 'Kids',
    body: 'Made with Love for Sri Lanka',
    cta: "Let's Play!",
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

  void _next() {
    if (_page < _pages.length - 1) {
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

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) =>
                _PageView(page: _pages[i], index: i, isDark: isDark),
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
                'Skip',
                style: GoogleFonts.plusJakartaSans(
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
                      children: List.generate(_pages.length, (i) {
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
                        onPressed: _next,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_pages[_page].cta),
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
            child: _Illustration(index: index, isDark: isDark),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: GoogleFonts.plusJakartaSans(
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
                  text: TextSpan(
                    children: [
                      if (page.title.isNotEmpty)
                        TextSpan(
                          text: page.title,
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark
                                ? const Color(0xFFF9F9FD)
                                : const Color(0xFF383833),
                            fontSize: index == 2 ? 44 : 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      TextSpan(
                        text: page.titleBlue,
                        style: GoogleFonts.plusJakartaSans(
                          color: isDark
                              ? const Color(0xFF6CB2FD)
                              : const Color(0xFF0067AD),
                          fontSize: index == 2 ? 44 : 40,
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
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark
                        ? const Color(0xFFAAABAF)
                        : const Color(0xFF77776F),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

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
  const _Illustration({required this.index, required this.isDark});
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return switch (index) {
      0 => _ExploreIllustration(isDark: isDark),
      1 => _LearningIllustration(isDark: isDark),
      _ => _IntroIllustration(isDark: isDark),
    };
  }
}

// Page 0 – glowing book scene
class _ExploreIllustration extends StatelessWidget {
  const _ExploreIllustration({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0D2137), Color(0xFF091A28)]
              : const [Color(0xFFDEEEFF), Color(0xFFC5DFFC)],
        ),
      ),
      child: Stack(
        children: [
          // Ambient glow
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6CB2FD).withOpacity(0.25),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Book icon centred
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A3A5C).withOpacity(0.7)
                    : const Color(0xFFB3D4FF).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 70,
                color: isDark
                    ? const Color(0xFF6CB2FD)
                    : const Color(0xFF0067AD),
              ),
            ),
          ),
          // Top-right book badge
          Positioned(
            top: 32,
            right: 32,
            child: _Badge(
              icon: Icons.menu_book_rounded,
              color: const Color(0xFFFF9800),
            ),
          ),
          // Left star badge
          Positioned(
            left: 20,
            top: 120,
            child: _Badge(
              icon: Icons.star_rounded,
              color: const Color(0xFF6CB2FD),
            ),
          ),
        ],
      ),
    );
  }
}

// Page 1 – floating letters scene
class _LearningIllustration extends StatelessWidget {
  const _LearningIllustration({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0A1F14), Color(0xFF071510)]
              : const [Color(0xFFD6F5E0), Color(0xFFC2EFD1)],
        ),
      ),
      child: Stack(
        children: [
          // Central glow
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00751F).withOpacity(0.25),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Boy silhouette icon
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A3A2C).withOpacity(0.7)
                    : const Color(0xFF91F78E).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_rounded,
                size: 60,
                color: isDark
                    ? const Color(0xFF91F78E)
                    : const Color(0xFF00751F),
              ),
            ),
          ),
          // Floating letter chips
          ..._letterChips(isDark),
          // New Level badge
          Positioned(
            bottom: 48,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'New Level',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _letterData = [
    ('A', Color(0xFF6CB2FD), Offset(60, 80)),
    ('Z', Color(0xFFFF9800), Offset(280, 100)),
    ('M', Color(0xFFFF7161), Offset(50, 280)),
  ];

  List<Widget> _letterChips(bool isDark) => _letterData
      .map(
        (d) => Positioned(
          left: d.$3.dx,
          top: d.$3.dy,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: d.$2.withOpacity(isDark ? 0.15 : 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: d.$2.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              d.$1,
              style: GoogleFonts.plusJakartaSans(
                color: d.$2,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      )
      .toList();
}

// Page 2 – intro / mascot scene
class _IntroIllustration extends StatelessWidget {
  const _IntroIllustration({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0C0E11), Color(0xFF111417)]
              : const [Color(0xFFEEF4FF), Color(0xFFDDE8F8)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: _MascotPainter(isDark: isDark),
            ),
          ),
          // Orange star
          Positioned(
            top: 60,
            right: 60,
            child: _Badge(
              icon: Icons.star_rounded,
              color: const Color(0xFFFF9800),
            ),
          ),
          // Red heart
          Positioned(
            left: 55,
            top: 200,
            child: _Badge(
              icon: Icons.favorite_rounded,
              color: const Color(0xFFFF7161),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared badge widget ───────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.35)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12)],
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 20),
    );
  }
}

// ── Mascot painter (reused from splash) ──────────────────────────────────────
class _MascotPainter extends CustomPainter {
  const _MascotPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final c = Offset(cx, cy);
    final or = size.width / 2;

    // Outer glow
    for (final blur in [20.0, 10.0]) {
      canvas.drawCircle(
        c,
        or - 4,
        Paint()
          ..color = const Color(
            0xFF4FC3F7,
          ).withOpacity(blur == 20 ? 0.18 : 0.28)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
      );
    }
    // Ring
    canvas.drawCircle(
      c,
      or - 5,
      Paint()
        ..color = const Color(0xFF4FC3F7).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
    // Inner circle
    canvas.drawCircle(c, or - 12, Paint()..color = const Color(0xFF141621));
    // Face
    final fr = (or - 12) * 0.60;
    canvas.drawCircle(c, fr, Paint()..color = const Color(0xFF5AABDB));
    // Visor
    final vp = Path()
      ..addArc(
        Rect.fromCircle(center: c, radius: fr),
        math.pi * 0.05,
        math.pi * 0.90,
      )
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(vp, Paint()..color = const Color(0xFF141621));
    // Eyes
    final ep = Paint()..color = Colors.white;
    final ey = cy - fr * 0.09;
    canvas.drawCircle(Offset(cx - fr * 0.30, ey), fr * 0.13, ep);
    canvas.drawCircle(Offset(cx + fr * 0.30, ey), fr * 0.13, ep);
    // Stars
    _star(
      canvas,
      Offset(cx + or * 0.56, cy - or * 0.50),
      14,
      5.5,
      const Color(0xFFFF9800),
    );
    _star(
      canvas,
      Offset(cx - or * 0.50, cy + or * 0.36),
      11,
      4.5,
      const Color(0xFFFF5252),
    );
    _star(
      canvas,
      Offset(cx - or * 0.33, cy + or * 0.55),
      6.5,
      2.5,
      const Color(0xFFFF5252),
    );
  }

  void _star(Canvas canvas, Offset c, double or, double ir, Color color) {
    const pts = 4;
    final step = math.pi / pts;
    final path = Path();
    for (int i = 0; i < pts * 2; i++) {
      final a = -math.pi / 2 + i * step;
      final r = i.isEven ? or : ir;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MascotPainter o) => o.isDark != isDark;
}
