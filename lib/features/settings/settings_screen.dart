import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import '../../core/providers/providers.dart';
import '../../core/services/auth_service.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final themeMode = ref.watch(themeModeProvider);
    final notifsEnabled = ref.watch(notificationsEnabledProvider);
    final isGuest = user?.isAnonymous ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsScreenTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // ── Profile ──────────────────────────────────────────────────────
          _Section(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      backgroundColor: isDark
                          ? AppTheme.electricBlue.withOpacity(0.15)
                          : AppTheme.oceanBlue.withOpacity(0.1),
                      child: user?.photoURL == null
                          ? Icon(
                              Icons.person_rounded,
                              color: isDark
                                  ? AppTheme.electricBlue
                                  : AppTheme.oceanBlue,
                              size: 28,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGuest
                                ? l10n.settingsGuestUserName
                                : (user?.displayName ?? 'User'),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isDark ? AppTheme.dText : AppTheme.lText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isGuest
                                ? l10n.settingsGuestSubtitle
                                : (user?.email ?? ''),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Appearance ───────────────────────────────────────────────────
          _SectionHeader(l10n.settingsSectionAppearance, isDark: isDark),
          _Section(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsThemeLabel,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppTheme.dText : AppTheme.lText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ThemeSelector(
                      current: themeMode,
                      isDark: isDark,
                      ref: ref,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Preferences ──────────────────────────────────────────────────
          _SectionHeader(l10n.settingsSectionPreferences, isDark: isDark),
          _Section(
            children: [
              _SettingsTile(
                icon: Icons.notifications_rounded,
                label: l10n.settingsNotificationsLabel,
                isDark: isDark,
                trailing: Switch(
                  value: notifsEnabled,
                  onChanged: (v) =>
                      ref.read(notificationsEnabledProvider.notifier).toggle(v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── About ────────────────────────────────────────────────────────
          _SectionHeader(l10n.settingsSectionAbout, isDark: isDark),
          _Section(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: l10n.settingsAppVersionLabel,
                isDark: isDark,
                trailing: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, snap) => Text(
                    snap.data != null
                        ? '${snap.data!.version} (${snap.data!.buildNumber})'
                        : '1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Account ──────────────────────────────────────────────────────
          _SectionHeader(l10n.settingsSectionAccount, isDark: isDark),
          _Section(
            children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                label: l10n.settingsSignOutLabel,
                isDark: isDark,
                iconColor: AppTheme.neonCoral,
                labelColor: AppTheme.neonCoral,
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.settingsSignOutDialogTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          l10n.settingsSignOutConfirmMessage,
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.settingsSignOutCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await AuthService.instance.signOut();
              // Router redirect handles navigation automatically via authStateProvider.
            },
            child: Text(
              l10n.settingsSignOutConfirm,
              style: TextStyle(color: AppTheme.neonCoral),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme selector segmented control ─────────────────────────────────────────
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.current,
    required this.isDark,
    required this.ref,
  });
  final ThemeMode current;
  final bool isDark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modes = [
      (ThemeMode.system, Icons.brightness_auto_rounded, l10n.settingsThemeModeSystem),
      (ThemeMode.light, Icons.light_mode_rounded, l10n.settingsThemeModeLight),
      (ThemeMode.dark, Icons.dark_mode_rounded, l10n.settingsThemeModeDark),
    ];

    return Row(
      children: modes.map((m) {
        final selected = current == m.$1;
        final accent = isDark ? AppTheme.electricBlue : AppTheme.oceanBlue;
        return Expanded(
          child: GestureDetector(
            onTap: () => ref.read(themeModeProvider.notifier).set(m.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? accent.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? accent
                      : (isDark
                            ? const Color(0xFF46484B)
                            : const Color(0xFFD0CEC5)),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    m.$2,
                    color: selected
                        ? accent
                        : (isDark ? AppTheme.dMuted : AppTheme.lMuted),
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.$3,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? accent
                          : (isDark ? AppTheme.dMuted : AppTheme.lMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label, {required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? AppTheme.dMuted : AppTheme.lMuted,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.isDark,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });
  final IconData icon;
  final String label;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor ?? (isDark ? AppTheme.dMuted : AppTheme.lMuted),
        size: 22,
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: labelColor ?? (isDark ? AppTheme.dText : AppTheme.lText),
        ),
      ),
      trailing: trailing,
    );
  }
}
