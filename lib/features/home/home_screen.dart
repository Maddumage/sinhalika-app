import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeScreen
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  Animation<double> _stagger(double start, double end) => CurvedAnimation(
    parent: _entrance,
    curve: Interval(start, end, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final firstName = user?.displayName?.split(' ').first;
    final name = (user?.isAnonymous ?? true)
        ? 'Explorer'
        : (firstName ?? 'Learner');

    return Scaffold(
      floatingActionButton: _FadeSlide(
        animation: _stagger(0.65, 1.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.search_rounded),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: isDark ? AppTheme.dBg : AppTheme.lBg,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: ColoredBox(
                color: isDark ? AppTheme.dBg : AppTheme.lBg,
              ),
              title: Text(
                'Sinhala Kids',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FadeSlide(
                  animation: _stagger(0.00, 0.45),
                  child: _GreetingCard(isDark: isDark, name: name),
                ),
                const SizedBox(height: 20),

                _FadeSlide(
                  animation: _stagger(0.10, 0.55),
                  child: _GameOfDayCard(isDark: isDark),
                ),
                const SizedBox(height: 28),

                _FadeSlide(
                  animation: _stagger(0.20, 0.65),
                  child: _TapScale(
                    onTap: () {},
                    child: _LetterSection(
                      title: 'Vowels',
                      sinhalaLabel: 'ස්වර (Swara)',
                      letters: 'අ  ආ',
                      accentColor: AppTheme.heritageRed,
                      isDark: isDark,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                _FadeSlide(
                  animation: _stagger(0.28, 0.72),
                  child: _TapScale(
                    onTap: () {},
                    child: _LetterSection(
                      title: 'Consonants',
                      sinhalaLabel: 'ව්‍යංජන (Wyanjana)',
                      letters: 'ක  බ',
                      accentColor: isDark
                          ? AppTheme.electricBlue
                          : AppTheme.oceanBlue,
                      isDark: isDark,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                _FadeSlide(
                  animation: _stagger(0.36, 0.80),
                  child: _DiscoverMore(isDark: isDark),
                ),
                const SizedBox(height: 28),

                _FadeSlide(
                  animation: _stagger(0.44, 0.88),
                  child: _DailyQuestCard(isDark: isDark),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FadeSlide  — staggered entrance wrapper
// ─────────────────────────────────────────────────────────────────────────────
class _FadeSlide extends StatelessWidget {
  const _FadeSlide({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.10),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TapScale — spring press-bounce for tappable cards
// ─────────────────────────────────────────────────────────────────────────────
class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 0.95,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Greeting card
// ─────────────────────────────────────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.isDark, required this.name});
  final bool isDark;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayubowan, $name!',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.dText : AppTheme.lText,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ready to explore your heritage today?',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 4',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
                ),
              ),
              Text(
                '240 / 500 XP',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 240 / 500),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: isDark
                    ? AppTheme.dHst
                    : const Color(0xFFE0DCD4),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Game of the Day card  — Play Now button pulses on a loop
// ─────────────────────────────────────────────────────────────────────────────
class _GameOfDayCard extends StatefulWidget {
  const _GameOfDayCard({required this.isDark});
  final bool isDark;

  @override
  State<_GameOfDayCard> createState() => _GameOfDayCardState();
}

class _GameOfDayCardState extends State<_GameOfDayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _btnScale = Tween<double>(
    begin: 1.0,
    end: 1.07,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return _TapScale(
      onTap: () {},
      child: Container(
        height: 220,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D2137),
                    Color(0xFF1A3A5C),
                    Color(0xFF133726),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFDDE8F5),
                    Color(0xFFF2DDD6),
                    Color(0xFFD4ECD4),
                  ],
                ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: _Circle(size: 140, opacity: isDark ? 0.06 : 0.09),
            ),
            Positioned(
              right: 40,
              bottom: -36,
              child: _Circle(size: 110, opacity: isDark ? 0.05 : 0.07),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(
                        0.10,
                      ),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: (isDark ? Colors.white : Colors.black)
                            .withOpacity(0.14),
                      ),
                    ),
                    child: Text(
                      'GAME OF THE DAY',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The Lotus Collector',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppTheme.lText,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Match the Sinhala vowels with falling\nlotus flowers to win extra points!',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? AppTheme.dMuted : const Color(0xFF5A5A55),
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  ScaleTransition(
                    scale: _btnScale,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : AppTheme.lText,
                        foregroundColor: isDark ? AppTheme.dBg : Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        elevation: 0,
                        textStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Play Now'),
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

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vowels / Consonants card
// ─────────────────────────────────────────────────────────────────────────────
class _LetterSection extends StatelessWidget {
  const _LetterSection({
    required this.title,
    required this.sinhalaLabel,
    required this.letters,
    required this.accentColor,
    required this.isDark,
  });
  final String title;
  final String sinhalaLabel;
  final String letters;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sinhalaLabel,
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 12,
                    color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  letters,
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 42,
                    fontWeight: FontWeight.w400,
                    color: accentColor.withOpacity(isDark ? 0.85 : 0.90),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(isDark ? 0.15 : 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: accentColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Discover More
// ─────────────────────────────────────────────────────────────────────────────
class _DiscoverMore extends StatelessWidget {
  const _DiscoverMore({required this.isDark});
  final bool isDark;

  static const _items = [
    _DiscItem('Words', 'වජන', Icons.abc_rounded, Color(0xFFE53935)),
    _DiscItem(
      'Vocabulary',
      'වජන භාගුව',
      Icons.menu_book_rounded,
      Color(0xFF1565C0),
    ),
    _DiscItem(
      'Phrases',
      'වාකිය',
      Icons.chat_bubble_outline_rounded,
      Color(0xFF2E7D32),
    ),
    _DiscItem(
      'Culture',
      'සංස්කූතිය',
      Icons.temple_hindu_rounded,
      Color(0xFFE65100),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discover More',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
            _TapScale(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.electricBlue
                          : AppTheme.oceanBlue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.05,
          children: _items
              .map((item) => _DiscCard(item: item, isDark: isDark))
              .toList(),
        ),
      ],
    );
  }
}

class _DiscItem {
  const _DiscItem(this.title, this.sinhala, this.icon, this.color);
  final String title;
  final String sinhala;
  final IconData icon;
  final Color color;
}

class _DiscCard extends StatelessWidget {
  const _DiscCard({required this.item, required this.isDark});
  final _DiscItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.dHigh : AppTheme.lSurf,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.dHst : const Color(0xFFE8E4DC),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const Spacer(),
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.dText : AppTheme.lText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.sinhala,
              style: GoogleFonts.notoSansSinhala(
                fontSize: 12,
                color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Daily Quest card  — star button pulses on a loop
// ─────────────────────────────────────────────────────────────────────────────
class _DailyQuestCard extends StatefulWidget {
  const _DailyQuestCard({required this.isDark});
  final bool isDark;

  @override
  State<_DailyQuestCard> createState() => _DailyQuestCardState();
}

class _DailyQuestCardState extends State<_DailyQuestCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _starScale = Tween<double>(
    begin: 1.0,
    end: 1.14,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.dHigh : const Color(0xFFF2F0E8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.dHst : const Color(0xFFD8D4C8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY QUEST',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: isDark ? AppTheme.electricBlue : AppTheme.oceanBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Greeting 5 People',
                  style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppTheme.dText : AppTheme.lText,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Practice your Sinhala greetings with your family or friends today and earn the "Lotus Badge"!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(5, (i) {
                    final filled = i < 2;
                    return Container(
                      width: filled ? 22 : 16,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: filled
                            ? const Color(0xFF2E7D32)
                            : (isDark
                                  ? AppTheme.dHst
                                  : const Color(0xFFCECABE)),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 5),
                Text(
                  '2 of 5 completed',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ScaleTransition(
            scale: _starScale,
            child: _TapScale(
              onTap: () {},
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
