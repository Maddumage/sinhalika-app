import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../theme/app_theme.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _loading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      await AuthService.instance.signInWithGoogle();
      // Router redirect will handle navigation to /home
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

  Future<void> _continueAsGuest() async {
    setState(() => _loading = true);
    try {
      await AuthService.instance.signInAsGuest();
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AppLogoMark(isDark: isDark),
                  const SizedBox(width: 10),
                  Text(
                    'Sinhala Kids',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppTheme.electricBlue
                          : AppTheme.oceanBlue,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // ── Headline ──────────────────────────────────────────
                    Text(
                      'Welcome back.',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your Sinhala adventure is waiting for you.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Google sign-in button ─────────────────────────────
                    _AuthButton(
                      onTap: _loading ? null : _signInWithGoogle,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1F1F1F),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _GoogleLogo(),
                          const SizedBox(width: 12),
                          Text(
                            'Sign in with Google',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F1F),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Guest button ──────────────────────────────────────
                    _AuthButton(
                      onTap: _loading ? null : _continueAsGuest,
                      backgroundColor: isDark
                          ? const Color(0xFF1D2024)
                          : const Color(0xFFEFECE4),
                      foregroundColor: isDark ? AppTheme.dText : AppTheme.lText,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Continue as Guest',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDark ? AppTheme.dText : AppTheme.lText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Parental disclosure ───────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF111417)
                            : const Color(0xFFF4F1EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: AppTheme.glowingAmber,
                            size: 28,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'PARENTAL DISCLOSURE',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sinhala Kids prioritizes your child\'s digital safety. We do not sell personal data or display third-party advertisements.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Child Safety Policy',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.electricBlue
                                    : AppTheme.oceanBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Loading indicator ─────────────────────────────────────────
            if (_loading)
              LinearProgressIndicator(
                color: cs.primary,
                backgroundColor: cs.primary.withOpacity(0.1),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable auth button ──────────────────────────────────────────────────────
class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
  });

  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ── App logo mark ─────────────────────────────────────────────────────────────
class _AppLogoMark extends StatelessWidget {
  const _AppLogoMark({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _LogoPainter(isDark: isDark)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final color = isDark ? AppTheme.electricBlue : AppTheme.oceanBlue;
    final p = Paint()..color = color;
    final r = size.width * 0.22;
    canvas.drawCircle(Offset(r, r), r, p);
    canvas.drawCircle(Offset(size.width - r, r), r, p);
    canvas.drawCircle(
      Offset(size.width / 2, size.height - r),
      r,
      p..color = color.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(_LogoPainter o) => o.isDark != isDark;
}

// ── Google logo (painted) ─────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    // Simple coloured circle quadrants to represent Google G logo
    const colors = [
      Color(0xFF4285F4),
      Color(0xFF34A853),
      Color(0xFFFBBC05),
      Color(0xFFEA4335),
    ];
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        (i * math.pi / 2) - math.pi / 2,
        math.pi / 2,
        true,
        Paint()..color = colors[i],
      );
    }
    // White centre
    canvas.drawCircle(c, r * 0.55, Paint()..color = Colors.white);
    // G bar
    canvas.drawRect(
      Rect.fromLTWH(r * 0.9, r * 0.75, r * 0.95, r * 0.5),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(_GooglePainter o) => false;
}
