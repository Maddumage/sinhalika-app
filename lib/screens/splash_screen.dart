import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  late final _progCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  @override
  void initState() {
    super.initState();
    _progCtrl.forward().then((_) {
      if (!mounted) return;
      final signedIn = ref.read(authStateProvider).valueOrNull != null;
      final seen = ref.read(onboardingSeenProvider);
      if (!seen) {
        context.go('/onboarding');
      } else if (!signedIn) {
        context.go('/sign-in');
      } else {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _progCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF0A0B10), Color(0xFF0F0B08)]
                : const [Color(0xFFF0F5FF), Color(0xFFE8F0FA)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeCtrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 5),

                // Mascot
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CustomPaint(painter: _MascotPainter(isDark: isDark)),
                ),

                const SizedBox(height: 44),

                const Text(
                  'Sinhala Kids',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4FC3F7),
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'අනාගතය වෙනුවෙන් අද ඉගෙන ගමු',
                  style: TextStyle(
                    fontSize: 15.5,
                    color: isDark
                        ? const Color(0xFFB0B8C8)
                        : const Color(0xFF5A6070),
                  ),
                ),

                const Spacer(flex: 4),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52),
                  child: AnimatedBuilder(
                    animation: _progCtrl,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 5,
                        child: Stack(
                          children: [
                            Container(
                              color: isDark
                                  ? const Color(0xFF252830)
                                  : const Color(0xFFD0DAEA),
                            ),
                            FractionallySizedBox(
                              widthFactor: _progCtrl.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4FC3F7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'LOADING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4FC3F7),
                    letterSpacing: 3.0,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'ලෝඩ් වෙමින් පවතිසි...',
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark
                        ? const Color(0xFF888EA0)
                        : const Color(0xFF7A8090),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mascot painter ────────────────────────────────────────────────────────────
class _MascotPainter extends CustomPainter {
  const _MascotPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final c = Offset(cx, cy);
    final or = size.width / 2;

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
    canvas.drawCircle(
      c,
      or - 5,
      Paint()
        ..color = const Color(0xFF4FC3F7).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final ir = or - 12;
    canvas.drawCircle(c, ir, Paint()..color = const Color(0xFF141621));

    final fr = ir * 0.60;
    canvas.drawCircle(c, fr, Paint()..color = const Color(0xFF5AABDB));

    final vp = Path()
      ..addArc(
        Rect.fromCircle(center: c, radius: fr),
        math.pi * 0.05,
        math.pi * 0.90,
      )
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(vp, Paint()..color = const Color(0xFF141621));

    final ep = Paint()..color = Colors.white;
    final ey = cy - fr * 0.09;
    canvas.drawCircle(Offset(cx - fr * 0.30, ey), fr * 0.13, ep);
    canvas.drawCircle(Offset(cx + fr * 0.30, ey), fr * 0.13, ep);

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
